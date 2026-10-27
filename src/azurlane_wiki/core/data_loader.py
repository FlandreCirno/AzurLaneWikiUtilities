# -*- coding: utf-8 -*-
"""Data loading and parsing utilities."""
import os
import json
import re
from ..config import get_config
from . import lua_parser


def save_json_file(data, file_name, config=None):
    """Save data to JSON file.

    Args:
        data: Data to save
        file_name: Name of the file (without .json extension)
        config: Config instance (uses default if None)
    """
    if config is None:
        config = get_config()

    file_path = os.path.join(config.json_directory, file_name + '.json')
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, sort_keys=True, indent=4, separators=(',', ': '))


def load_json_file(file_name, config=None):
    """Load data from JSON file.

    Args:
        file_name: Name of the file (without .json extension)
        config: Config instance (uses default if None)

    Returns:
        Parsed JSON data as dictionary
    """
    if config is None:
        config = get_config()

    file_name_data = os.path.join(config.json_directory, 'sharecfgdata', file_name + '.json')
    file_name_game = os.path.join(config.json_directory, 'GameCfg', file_name + '.json')
    file_name_share = os.path.join(config.json_directory, 'ShareCfg', file_name + '.json')

    if os.path.isfile(file_name_data):
        if os.path.isfile(file_name_share):
            if os.path.getsize(file_name_share) > os.path.getsize(file_name_data):
                with open(file_name_share, 'r+', encoding='utf-8') as f:
                    content = json.load(f)
                    _clean_metadata(content)
                    return _parse_json(content)
            else:
                with open(file_name_data, 'r+', encoding='utf-8') as f:
                    content = json.load(f)
                    _clean_metadata(content)
                    return _parse_json(content)
    elif file_name in config.gamecfg_list:
        with open(file_name_game, 'r+', encoding='utf-8') as f:
            content = json.load(f)
            _clean_metadata(content)
            return _parse_json(content)
    else:
        with open(file_name_share, 'r+', encoding='utf-8') as f:
            content = json.load(f)
            _clean_metadata(content)
            return _parse_json(content)


def _clean_metadata(content):
    """Remove metadata keys from content dictionary."""
    if 'all' in content.keys():
        del content['all']
    if 'get_id_list_by_group_type' in content.keys():
        del content['get_id_list_by_group_type']


def _parse_json(data):
    """Recursively parse JSON data, converting string keys to integers where possible.

    Args:
        data: JSON data to parse

    Returns:
        Parsed data with integer keys where applicable
    """
    if isinstance(data, dict):
        output = {}
        for k, v in data.items():
            if isinstance(k, str) and k.isdigit():
                output[int(k)] = _parse_json(v)
            else:
                output[k] = _parse_json(v)
    elif isinstance(data, list):
        output = []
        for i in data:
            output.append(_parse_json(i))
    else:
        output = data
    return output


def has_json_file(file_name, config=None):
    """Check if JSON file exists.

    Args:
        file_name: Name of the file (without .json extension)
        config: Config instance (uses default if None)

    Returns:
        True (always returns True for now)
    """
    return True


# ---------------------------------------------------------------------------
# Lua sources (AzurLaneLuaScripts - upstream of the AzurLaneData JSON dumps)
# ---------------------------------------------------------------------------

# Records live in sharecfgdata/, dungeon & story in gamecfg/, everything else
# in sharecfg/. Older checkouts vary in capitalisation, so probe both spellings.
_LUA_RECORD_DIR = 'sharecfgdata'
_LUA_GAMECFG_DIRS = ('gamecfg', 'GameCfg')
_LUA_SHARECFG_DIRS = ('sharecfg', 'ShareCfg')

# A single table can weight a few MB and generators request the same tables
# repeatedly, so parsed tables are cached for the lifetime of the process.
_LUA_CACHE = {}


def lua_file_paths(file_name, config=None):
    """Return candidate Lua paths for a table, highest priority first.

    Args:
        file_name: Name of the table (without extension)
        config: Config instance (uses default if None)

    Returns:
        List of absolute paths that may hold the table
    """
    if config is None:
        config = get_config()

    base = config.lua_directory
    paths = [os.path.join(base, _LUA_RECORD_DIR, file_name + '.lua')]
    paths += [os.path.join(base, d, file_name + '.lua') for d in _LUA_GAMECFG_DIRS]
    paths += [os.path.join(base, d, file_name + '.lua') for d in _LUA_SHARECFG_DIRS]
    return paths


def lua_directory_paths(file_name, config=None):
    """Return candidate directories that hold one Lua file per record.

    ``dungeon`` and ``story`` are shipped this way (``gamecfg/dungeon/0000000.lua``)
    instead of as a single table file.

    Args:
        file_name: Name of the table
        config: Config instance (uses default if None)

    Returns:
        List of absolute directories that may hold the records
    """
    if config is None:
        config = get_config()

    base = config.lua_directory
    return [
        os.path.join(base, 'gamecfg', file_name),
        os.path.join(base, 'GameCfg', file_name),
        os.path.join(base, 'sharecfgdata', file_name),
        os.path.join(base, 'sharecfg', file_name + '_sublist'),
        os.path.join(base, 'sharecfg', file_name),
    ]


def has_lua_directory(file_name, config=None):
    """Check whether a table is stored as one Lua file per record.

    Args:
        file_name: Name of the table
        config: Config instance (uses default if None)

    Returns:
        True if a matching directory exists
    """
    return any(os.path.isdir(path) for path in lua_directory_paths(file_name, config))


def has_lua_file(file_name, config=None):
    """Check whether a table is available from the Lua sources.

    Args:
        file_name: Name of the table (without extension)
        config: Config instance (uses default if None)

    Returns:
        True if a matching .lua file or record directory exists
    """
    if has_lua_directory(file_name, config):
        return True
    return any(os.path.isfile(path) for path in lua_file_paths(file_name, config))


def _record_key(stem):
    """Mirror the JSON dumps: numeric file stems become integer keys."""
    try:
        return int(stem)
    except ValueError:
        return stem


def load_lua_directory(file_name, config=None):
    """Load a table that is shipped as one Lua file per record.

    Each file simply ``return``s its record, e.g.
    ``CN/gamecfg/dungeon/0000000.lua`` -> ``return { map_id = 10005, ... }``.
    Records are keyed by file stem with numeric stems turned into integers,
    which is exactly the layout the JSON dumps use.

    Args:
        file_name: Name of the table
        config: Config instance (uses default if None)

    Returns:
        Dictionary of records keyed by file stem

    Raises:
        FileNotFoundError: if no record directory provides the table
    """
    if config is None:
        config = get_config()

    for path in lua_directory_paths(file_name, config):
        if not os.path.isdir(path):
            continue
        key = ('dir', path)
        if key in _LUA_CACHE:
            return _LUA_CACHE[key]

        records = {}
        for root, _, files in os.walk(path):
            for name in sorted(files):
                if not name.endswith('.lua'):
                    continue
                full = os.path.join(root, name)
                stem = os.path.splitext(name)[0]
                try:
                    env = lua_parser.parse_lua_file(full)
                except Exception as exc:  # keep going on a broken record
                    print('Warning: failed to parse %s: %s' % (full, exc))
                    continue
                record = env.get('_return')
                if record is None:
                    record = lua_parser.extract_table(env, stem)
                records[_record_key(stem)] = _parse_json(record)
        _LUA_CACHE[key] = records
        return records

    raise FileNotFoundError(
        'Lua record directory not found for table %r (looked under %s)'
        % (file_name, config.lua_directory))


def load_lua_file(file_name, config=None):
    """Load a configuration table from the Lua sources.

    Mirrors :func:`load_json_file` so the rest of the package sees the same
    layout whichever source is used: metadata keys are stripped and numeric
    keys are converted to integers.

    Args:
        file_name: Name of the table (without extension)
        config: Config instance (uses default if None)

    Returns:
        Parsed table as dictionary

    Raises:
        FileNotFoundError: if no Lua source provides the table
    """
    if config is None:
        config = get_config()

    # dungeon / story / storyjp are shipped as one file per record, so they
    # always take the directory path (see load_lua_directory).
    gamecfg_list = getattr(config, 'gamecfg_list', ())
    if file_name in gamecfg_list and has_lua_directory(file_name, config):
        return load_lua_directory(file_name, config)

    # Every other table is a single file, and the biggest candidate wins: the
    # record dump in sharecfgdata/ is larger than the header-only copy in
    # sharecfg/, matching what load_json_file does. This also keeps the
    # partial *_sublist/ directories (a handful of shards) from shadowing a
    # complete table - e.g. sharecfgdata/ship_skin_template.lua holds all 2887
    # skins while sharecfg/ship_skin_template_sublist/ only carries 20.
    best_path = None
    best_size = -1
    for path in lua_file_paths(file_name, config):
        if not os.path.isfile(path):
            continue
        try:
            size = os.path.getsize(path)
        except OSError:
            size = 0
        if size > best_size:
            best_path, best_size = path, size

    if best_path is not None:
        try:
            stat = os.stat(best_path)
            key = (best_path, stat.st_mtime, stat.st_size)
        except OSError:
            key = (best_path, 0, 0)
        if key in _LUA_CACHE:
            return _LUA_CACHE[key]
        try:
            env = lua_parser.parse_lua_file(best_path)
        except Exception as exc:  # a broken file must not kill the generator
            print('Warning: failed to parse %s: %s' % (best_path, exc))
        else:
            content = _parse_json(lua_parser.extract_table(env, file_name))
            _clean_metadata(content)
            _LUA_CACHE[key] = content
            return content

    # No single file at all: fall back to one-file-per-record directories.
    if has_lua_directory(file_name, config):
        return load_lua_directory(file_name, config)

    raise FileNotFoundError(
        'Lua data file not found for table %r (looked under %s)'
        % (file_name, config.lua_directory))


def clear_lua_cache():
    """Drop cached Lua tables, e.g. after refreshing the data sources."""
    _LUA_CACHE.clear()


def parse_data_file(file_name, file_path='sharecfg', mode=0, config=None):
    """Parse a configuration table from the Lua sources or the JSON dumps.

    The source is selected with ``config.data_source``: ``'lua'`` reads
    AzurLaneLuaScripts, ``'json'`` reads AzurLaneData and ``'auto'`` (default)
    prefers the Lua sources, falling back to JSON when a table is missing there.

    Args:
        file_name: Name of the file
        file_path: Relative path to the file (unused, kept for compatibility)
        mode: 0 for single file, 1 for sublist directory (unused)
        config: Config instance (uses default if None)

    Returns:
        Parsed data as dictionary
    """
    if config is None:
        config = get_config()

    source = getattr(config, 'data_source', 'auto')
    if source in ('lua', 'auto') and has_lua_file(file_name, config):
        return load_lua_file(file_name, config)
    if source == 'lua':
        return {}
    return load_json_file(file_name, config)


def get_chapter_template(file_name='chapter_template', file_path='sharecfg', config=None):
    """Get chapter template data.

    Args:
        file_name: Name of the chapter template file
        file_path: Relative path to the file (unused, kept for compatibility)
        config: Config instance (uses default if None)

    Returns:
        Chapter template data as dictionary
    """
    if config is None:
        config = get_config()

    source = getattr(config, 'data_source', 'auto')
    if source in ('lua', 'auto') and has_lua_file(file_name, config):
        return load_lua_file(file_name, config)
    if source == 'lua':
        return {}
    return load_json_file(file_name, config)
