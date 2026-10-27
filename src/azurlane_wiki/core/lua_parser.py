# -*- coding: utf-8 -*-
"""Minimal Lua parser for AzurLane sharecfg configuration tables.

AzurLaneTools/AzurLaneLuaScripts ships the game configuration as raw Lua source:

* ``sharecfg/<name>.lua``      - table header plus the ``all`` id index
* ``sharecfgdata/<name>.lua``  - the actual records:
      ``_G.pg.base.<name>[<id>] = { ... }``
* ``gamecfg/<name>.lua``       - a handful of tables (``dungeon``, ``story``...)

This module executes just enough Lua to materialise those tables as plain
Python objects whose layout matches the JSON dumps produced by AzurLaneData,
so the rest of ``azurlane_wiki`` can consume either source transparently.

Supported subset: assignments (dotted / bracketed paths), table constructors
(positional and keyed, nested), strings (short and long brackets, with escapes),
numbers (decimal, scientific, hexadecimal), booleans, ``nil``, ``or``/``and``,
unary ``-``/``not``/``#`` and the ``rawget``/``setmetatable`` helpers the config
headers rely on. Anything else is skipped so a single odd statement can never
abort the whole file.
"""

import re


class LuaParseError(Exception):
    """Raised internally when a statement cannot be parsed; triggers resync."""


_EOF = ('eof', '')

# Order matters: multi-char tokens and strings must win over single punctuation.
_TOKEN_RE = re.compile(
    r"""
      (?P<ws>[ \t\r\f\v]+)
    | (?P<nl>\n)
    | (?P<blockcomment>--\[(?P<lvl1>=*)\[[\s\S]*?\](?P=lvl1)\])
    | (?P<linecomment>--[^\n]*)
    | (?P<longstr>\[(?P<lvl2>=*)\[[\s\S]*?\](?P=lvl2)\])
    | (?P<str>"(?:\\.|[^"\\\n])*"|'(?:\\.|[^'\\\n])*')
    | (?P<num>0[xX][0-9a-fA-F]+|(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?)
    | (?P<id>[A-Za-z_][A-Za-z0-9_]*)
    | (?P<punct>\.\.\.|\.\.|==|~=|<=|>=|&&|\|\||[:{}\[\]()=,;.+\-*/%^<>#~])
    """,
    re.VERBOSE,
)

_SIMPLE_ESCAPES = {
    'n': '\n', 't': '\t', 'r': '\r', 'a': '\a', 'b': '\b',
    'f': '\f', 'v': '\v', '\\': '\\', '"': '"', "'": "'", '0': '\0',
}


def _unescape(body):
    """Decode Lua short-string escape sequences."""
    out = []
    i = 0
    n = len(body)
    while i < n:
        ch = body[i]
        if ch == '\\' and i + 1 < n:
            nxt = body[i + 1]
            if nxt in _SIMPLE_ESCAPES:
                out.append(_SIMPLE_ESCAPES[nxt])
                i += 2
                continue
            if nxt == 'x' and i + 3 < n:
                try:
                    out.append(chr(int(body[i + 2:i + 4], 16)))
                    i += 4
                    continue
                except ValueError:
                    pass
            if nxt.isdigit():
                j = i + 1
                digits = ''
                while j < n and len(digits) < 3 and body[j].isdigit():
                    digits += body[j]
                    j += 1
                out.append(chr(int(digits)))
                i = j
                continue
            if nxt == 'z':  # \z skips following whitespace
                i += 2
                while i < n and body[i] in ' \t\r\n\f\v':
                    i += 1
                continue
            out.append(nxt)
            i += 2
            continue
        out.append(ch)
        i += 1
    return ''.join(out)


def _lua_rawget(table, key, *rest):
    if isinstance(table, dict):
        return table.get(key)
    return None


def _lua_setmetatable(table, metatable, *rest):
    """Config headers only use the metatable for runtime lookups; drop it."""
    return table


_BUILTINS = {
    'rawget': _lua_rawget,
    'setmetatable': _lua_setmetatable,
}


def tokenize(text):
    """Split Lua source into a list of ``(kind, value)`` tokens."""
    tokens = []
    for match in _TOKEN_RE.finditer(text):
        if match.group('ws') is not None:
            continue
        if match.group('nl') is not None:
            tokens.append(('nl', '\n'))
            continue
        if match.group('blockcomment') is not None:
            continue
        if match.group('linecomment') is not None:
            continue
        if match.group('longstr') is not None:
            tokens.append(('longstr', match.group()))
            continue
        if match.group('str') is not None:
            tokens.append(('str', match.group()))
            continue
        if match.group('num') is not None:
            tokens.append(('num', match.group()))
            continue
        if match.group('id') is not None:
            tokens.append(('id', match.group()))
            continue
        if match.group('punct') is not None:
            tokens.append(('punct', match.group()))
            continue
    tokens.append(_EOF)
    return tokens


class _Parser(object):
    """Recursive-descent parser for the Lua subset used by sharecfg files."""

    def __init__(self, tokens):
        self.toks = tokens
        self.i = 0

    # ---------------------------------------------------------------- helpers
    def peek(self):
        """Next meaningful token (newlines are transparent)."""
        while self.i < len(self.toks) and self.toks[self.i][0] == 'nl':
            self.i += 1
        if self.i >= len(self.toks):
            return _EOF
        return self.toks[self.i]

    def next_tok(self):
        tok = self.peek()
        self.i += 1
        return tok

    def at(self, kind, value=None):
        tok = self.peek()
        return tok[0] == kind and (value is None or tok[1] == value)

    def resync(self):
        """Skip to the end of the current statement (newline or ``;``)."""
        n = len(self.toks)
        j = self.i
        while j < n:
            kind, value = self.toks[j]
            if kind == 'nl' or (kind == 'punct' and value == ';'):
                break
            j += 1
        self.i = j

    # ------------------------------------------------------------- statements
    def parse_program(self, env):
        while True:
            tok = self.peek()
            if tok[0] == 'eof':
                break
            if tok[0] == 'punct' and tok[1] == ';':
                self.next_tok()
                continue
            self.parse_statement(env)

    def parse_statement(self, env):
        tok = self.peek()
        if tok[0] == 'id':
            if tok[1] == 'local':
                self.next_tok()
                self.parse_assignment_or_skip(env)
                return
            if tok[1] == 'return':
                self.next_tok()
                env['_return'] = None
                if not (self.at('eof') or self.at('punct', ';')):
                    try:
                        env['_return'] = self.parse_expr(env)
                    except LuaParseError:
                        self.resync()
                return
            if tok[1] in ('function', 'for', 'while', 'repeat', 'if', 'do',
                          'end', 'else', 'elseif', 'until', 'then', 'break',
                          'goto'):
                self.resync()
                return
        self.parse_assignment_or_skip(env)

    def parse_assignment_or_skip(self, env):
        save = self.i
        try:
            accessors = self.parse_path(env)
            if self.at('punct', '='):
                self.next_tok()
                value = self.parse_expr(env)
                self.assign(accessors, value, env)
                return
            self.i = save
        except LuaParseError:
            self.i = save
        except (IndexError, ValueError, TypeError):
            self.i = save
        # Not an assignment we understand - drop the statement.
        self.resync()

    def parse_path(self, env):
        tok = self.next_tok()
        if tok[0] != 'id':
            raise LuaParseError('expected name, got %r' % (tok,))
        accessors = [('root', tok[1])]
        while True:
            if self.at('punct', '.'):
                self.next_tok()
                field = self.next_tok()
                if field[0] != 'id':
                    raise LuaParseError('expected field name')
                accessors.append(('attr', field[1]))
            elif self.at('punct', '['):
                self.next_tok()
                key = self.parse_expr(env)
                if not self.at('punct', ']'):
                    raise LuaParseError("expected ']'")
                self.next_tok()
                accessors.append(('index', key))
            else:
                break
        return accessors

    def assign(self, accessors, value, env):
        if len(accessors) == 1:
            env[accessors[0][1]] = value
            return
        root = accessors[0][1]
        cur = env if root == '_G' else env.get(root)
        if not isinstance(cur, dict):
            if root == '_G':
                return
            cur = {}
            env[root] = cur
        for _, key in accessors[1:-1]:
            if not isinstance(cur, dict):
                return
            child = cur.get(key) if isinstance(key, (str, int, float)) else None
            if not isinstance(child, dict):
                child = {}
                cur[key] = child
            cur = child
        _, key = accessors[-1]
        if isinstance(cur, dict):
            cur[key] = value

    # ------------------------------------------------------------ expressions
    def parse_expr(self, env):
        return self.parse_or(env)

    def parse_or(self, env):
        left = self.parse_and(env)
        while self.at('id', 'or'):
            self.next_tok()
            right = self.parse_and(env)
            if left is None or left is False:
                left = right
        return left

    def parse_and(self, env):
        left = self.parse_unary(env)
        while self.at('id', 'and'):
            self.next_tok()
            right = self.parse_unary(env)
            if not (left is None or left is False):
                left = right
        return left

    def parse_unary(self, env):
        if self.at('punct', '-'):
            self.next_tok()
            value = self.parse_unary(env)
            return -value if isinstance(value, (int, float)) else 0
        if self.at('id', 'not'):
            self.next_tok()
            return not self.parse_unary(env)
        if self.at('punct', '#'):
            self.next_tok()
            value = self.parse_unary(env)
            try:
                return len(value)
            except TypeError:
                return 0
        return self.parse_primary(env)

    def parse_primary(self, env):
        tok = self.peek()
        if tok[0] == 'num':
            self.next_tok()
            return self.number(tok[1])
        if tok[0] == 'str':
            self.next_tok()
            return _unescape(tok[1][1:-1])
        if tok[0] == 'longstr':
            self.next_tok()
            return self.long_string(tok[1])
        if tok[0] == 'punct' and tok[1] == '(':
            self.next_tok()
            value = self.parse_expr(env)
            if not self.at('punct', ')'):
                raise LuaParseError("expected ')'")
            self.next_tok()
            return value
        if tok[0] == 'punct' and tok[1] == '{':
            return self.parse_table(env)
        if tok[0] == 'id':
            if tok[1] in ('true', 'false', 'nil'):
                self.next_tok()
                return {'true': True, 'false': False, 'nil': None}[tok[1]]
            name = self.next_tok()[1]
            value = env.get(name)
            if self.at('punct', '('):
                value = self.parse_call(env, name, value)
            return self.parse_suffixes(env, value)
        raise LuaParseError('unexpected token %r' % (tok,))

    def parse_suffixes(self, env, value):
        while True:
            if self.at('punct', '.'):
                self.next_tok()
                field = self.next_tok()
                if field[0] != 'id':
                    raise LuaParseError('expected field name')
                value = self.index(value, field[1])
            elif self.at('punct', '['):
                self.next_tok()
                key = self.parse_expr(env)
                if not self.at('punct', ']'):
                    raise LuaParseError("expected ']'")
                self.next_tok()
                value = self.index(value, key)
            else:
                break
        return value

    def index(self, value, key):
        if isinstance(value, dict):
            return value.get(key)
        if isinstance(value, (list, tuple)) and isinstance(key, int):
            try:
                return value[key - 1]  # Lua arrays are 1-based
            except (IndexError, TypeError):
                return None
        return None

    def parse_call(self, env, name, funcval):
        if not self.at('punct', '('):
            return funcval
        self.next_tok()
        args = []
        while not self.at('punct', ')'):
            if self.at('eof'):
                raise LuaParseError('unterminated call')
            args.append(self.parse_expr(env))
            if self.at('punct', ',') or self.at('punct', ';'):
                self.next_tok()
        self.next_tok()  # consume ')'
        builtin = _BUILTINS.get(name)
        if builtin is not None:
            return builtin(*args)
        if callable(funcval):
            try:
                return funcval(*args)
            except Exception:
                return None
        return None

    # ----------------------------------------------------------------- tables
    def parse_table(self, env):
        if not self.at('punct', '{'):
            raise LuaParseError("expected '{'")
        self.next_tok()
        table = {}
        positional = 0
        while not self.at('punct', '}'):
            if self.at('eof'):
                raise LuaParseError('unterminated table')
            tok = self.peek()
            if tok[0] == 'punct' and tok[1] == '[':
                self.next_tok()
                key = self.parse_expr(env)
                if not self.at('punct', ']'):
                    raise LuaParseError("expected ']'")
                self.next_tok()
                if not self.at('punct', '='):
                    raise LuaParseError("expected '='")
                self.next_tok()
                table[key] = self.parse_expr(env)
            elif tok[0] == 'id':
                save = self.i
                self.next_tok()
                if self.at('punct', '='):
                    self.next_tok()
                    table[tok[1]] = self.parse_expr(env)
                else:
                    self.i = save
                    positional += 1
                    table[positional] = self.parse_expr(env)
            else:
                positional += 1
                table[positional] = self.parse_expr(env)
            if self.at('punct', ',') or self.at('punct', ';'):
                self.next_tok()
        self.next_tok()  # consume '}'
        return self.finish_table(table, positional)

    @staticmethod
    def finish_table(table, positional):
        """Emit a Python list for pure arrays, a dict otherwise."""
        if positional and len(table) == positional and all(
                isinstance(key, int) for key in table):
            return [table[i] for i in range(1, positional + 1)]
        return table

    # ----------------------------------------------------------------- values
    @staticmethod
    def number(raw):
        if raw[:2].lower() == '0x':
            try:
                return int(raw, 16)
            except ValueError:
                return 0
        if any(ch in raw for ch in '.eE'):
            try:
                return float(raw)
            except ValueError:
                return 0
        try:
            return int(raw)
        except ValueError:
            return 0

    @staticmethod
    def long_string(raw):
        match = re.match(r'\[=*\[', raw)
        if not match:
            return raw
        body = raw[match.end():]
        body = re.sub(r'\]=*\]\s*$', '', body)
        # A newline immediately following the opening bracket is ignored in Lua.
        if body.startswith('\r\n'):
            body = body[2:]
        elif body.startswith('\n'):
            body = body[1:]
        return body


def new_env():
    """Create a fresh Lua global environment with the helpers config files need."""
    env = {}
    env['_G'] = env
    env['pg'] = {}
    env['confNEO'] = {}
    env.update(_BUILTINS)
    return env


def parse_lua_text(text):
    """Execute a Lua snippet and return the resulting globals."""
    env = new_env()
    _Parser(tokenize(text)).parse_program(env)
    return env


def parse_lua_file(path):
    """Parse a Lua config file and return the resulting globals."""
    with open(path, 'r', encoding='utf-8', errors='replace') as handle:
        return parse_lua_text(handle.read())


def extract_table(env, name):
    """Return configuration table ``name``, preferring records over the header.

    ``sharecfgdata`` files store records under ``pg.base.<name>`` while
    ``sharecfg`` only defines the header (``pg.<name>`` with ``all``). Records
    win whenever they are present.
    """
    pg = env.get('pg') or {}
    base = pg.get('base') if isinstance(pg, dict) else None
    if isinstance(base, dict):
        records = base.get(name)
        if isinstance(records, dict) and records:
            return records
    if isinstance(pg, dict):
        return pg.get(name) or {}
    return {}
