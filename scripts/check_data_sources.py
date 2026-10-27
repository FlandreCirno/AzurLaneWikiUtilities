# -*- coding: utf-8 -*-
"""Report which game data sources are available.

Run from CI right before generating the wiki so the job log records exactly
which source was live, how recent it is and what it contains. This is what
makes a green run trustworthy: a run that silently fell back to the stale JSON
dumps looks the same as one that read fresh Lua data, unless we print it.
"""
import os
import subprocess
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from azurlane_wiki.config import Config  # noqa: E402

REGIONS = ('CN', 'JP', 'EN', 'KR', 'TW')
EXTS = ('.lua', '.json')

# Record directories plus the one-file-per-record memory/story trees.
LUA_TABLE_DIRS = ('sharecfg', 'sharecfgdata')
LUA_RECORD_DIRS = ('dungeon', 'story', 'storyjp')
JSON_TABLE_DIRS = ('ShareCfg', 'sharecfgdata')
JSON_RECORD_DIRS = ('dungeon', 'story', 'storyjp')


def _count(path):
    """Count data files in a directory tree, or None when it is missing."""
    total = 0
    try:
        for dirpath, _dirnames, filenames in os.walk(path):
            total += sum(1 for f in filenames if f.endswith(EXTS))
    except OSError:
        return None
    # walk() silently yields nothing for a missing path, so report it as absent.
    return total if os.path.isdir(path) else None


def _head(repo_root):
    """Return '<sha> <date>' for a checkout, or None."""
    try:
        return subprocess.run(
            ['git', '-C', repo_root, 'log', '-1', '--format=%h %ad',
             '--date=short'],
            capture_output=True, text=True, check=True,
        ).stdout.strip()
    except (subprocess.CalledProcessError, OSError):
        return None


def _report_source(title, root, table_dirs, record_dirs, ext):
    print('\n%s' % title)
    if not os.path.isdir(root):
        print('  MISSING (%s)' % root)
        return False

    head = _head(root)
    print('  HEAD: %s' % (head or 'unknown'))

    any_ready = False
    for region in REGIONS:
        cells = []
        for name in table_dirs:
            count = _count(os.path.join(root, region, name))
            cells.append('%s=%s' % (name, count if count is not None else '-'))
            if count:
                any_ready = True
        for name in record_dirs:
            path = os.path.join(root, region, 'gamecfg', name)
            count = _count(path)
            if count is None:
                path = os.path.join(root, region, 'GameCfg', name)
                count = _count(path)
            if count is not None:
                cells.append('%s=%d' % (name, count))
                any_ready = True
        print('  %-3s %s' % (region, '  '.join(cells)))

    if not any_ready:
        print('  (directory present but empty - no data checked out)')
    return any_ready


def main():
    config = Config()
    root = str(config.project_root)
    print('=' * 60)
    print('Data sources')
    print('=' * 60)

    lua_ready = _report_source(
        'Lua  (AzurLaneLuaScripts)', os.path.join(root, 'AzurLaneLuaScripts'),
        LUA_TABLE_DIRS, LUA_RECORD_DIRS, '.lua')
    json_ready = _report_source(
        'JSON (AzurLaneData)', os.path.join(root, 'AzurLaneData'),
        JSON_TABLE_DIRS, JSON_RECORD_DIRS, '.json')

    print('\n%s' % ('=' * 60))
    print('data_source=%s  ->  %s' % (
        config.data_source,
        'Lua preferred, JSON fallback' if config.data_source == 'auto'
        else config.data_source))
    print('Lua ready: %s   JSON ready: %s' % (lua_ready, json_ready))
    print('=' * 60)

    if config.data_source == 'lua' and not lua_ready:
        print('✗ data_source=lua but no Lua data is available', file=sys.stderr)
        return 1
    if not lua_ready and not json_ready:
        print('✗ no game data available at all', file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
