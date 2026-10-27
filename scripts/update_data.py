# -*- coding: utf-8 -*-
"""Update the game data sources.

Two sources carry the game data:

* ``AzurLaneLuaScripts`` - the raw Lua configuration extracted from the game,
  still updated daily. This is what the generators read by default
  (``data_source='auto'``). It is *not* a submodule: the repository is 2.7 GB
  and only a fraction is ever read, so it is fetched with a blobless sparse
  clone instead. See :mod:`fetch_lua_data`.
* ``AzurLaneData`` - the JSON dumps derived from those Lua scripts. It stopped
  being refreshed in May 2026 and stays registered as a submodule purely as a
  fallback for tables the Lua sources do not carry (notably the JP ``storyjp``
  records).

Usage::

    python scripts/update_data.py          # update both
    python scripts/update_data.py lua      # only the Lua sources
    python scripts/update_data.py json     # only the JSON dumps
"""
import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import fetch_lua_data  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
JSON_SUBMODULE = 'AzurLaneData'
JSON_PATH = os.path.join(ROOT, JSON_SUBMODULE)
LUA_PATH = os.path.join(ROOT, 'AzurLaneLuaScripts')


def _run(args):
    return subprocess.run(args, capture_output=True, text=True, check=True)


def update_json():
    """Update the JSON dumps submodule, initialising it first if needed."""
    print('Updating %s ...' % JSON_SUBMODULE)
    try:
        result = _run(['git', 'submodule', 'update', '--init', '--remote',
                       JSON_SUBMODULE])
        if result.stdout.strip():
            print(result.stdout.strip())
        result = _run(['git', '-C', JSON_PATH, 'log', '-1', '--oneline'])
        print('✓ %s updated to: %s' % (JSON_SUBMODULE, result.stdout.strip()))
        return 0
    except subprocess.CalledProcessError as exc:
        print('✗ Error updating %s: %s' % (JSON_SUBMODULE, exc), file=sys.stderr)
        if exc.stderr:
            print(exc.stderr, file=sys.stderr)
        return 1


def update(source='all'):
    """Update the requested data sources ('lua', 'json' or 'all')."""
    if source not in ('all', 'lua', 'json'):
        print('Unknown data source %r (expected lua, json or all)' % source,
              file=sys.stderr)
        return 1

    status = 0
    if source in ('all', 'lua'):
        print('Updating AzurLaneLuaScripts ...')
        status |= fetch_lua_data.fetch(LUA_PATH)
    if source in ('all', 'json'):
        status |= update_json()
    return status


if __name__ == '__main__':
    sys.exit(update(sys.argv[1] if len(sys.argv) > 1 else 'all'))
