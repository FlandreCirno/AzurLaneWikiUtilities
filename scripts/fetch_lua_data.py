# -*- coding: utf-8 -*-
"""Fetch the raw Lua configuration from AzurLaneLuaScripts.

``AzurLaneData`` (the JSON dumps) stopped being refreshed in May 2026, while
``AzurLaneLuaScripts`` - the upstream it is generated from - is still updated
daily. This script pulls that upstream so the generators can read fresh data.

The upstream repository is 2.7 GB, but only about 130 MB per region is ever
read. Cloning it whole would waste several minutes of CI time on every run, so
this script uses a **blobless** clone (``--filter=blob:none``) combined with a
**sparse** checkout: git downloads the tree structure and then fetches only the
blobs that actually land in the working tree.

Usage::

    python scripts/fetch_lua_data.py                  # all regions
    python scripts/fetch_lua_data.py --regions CN JP  # a subset
    python scripts/fetch_lua_data.py --force          # re-clone from scratch

Requirements: git >= 2.30 (for --filter and cone-mode sparse-checkout).
"""
import argparse
import os
import shutil
import subprocess
import sys

REPO_URL = 'https://github.com/AzurLaneTools/AzurLaneLuaScripts'
DEFAULT_BRANCH = 'main'
DEFAULT_REGIONS = ('CN', 'JP', 'EN', 'KR', 'TW')

# Present in every region: table headers plus the bulk record dumps.
FIXED_DIRS = ('sharecfg', 'sharecfgdata')
# Memory / story records live under gamecfg/ as one file per record. Only some
# regions ship them (CN has both, EN only dungeon), so they are probed first.
STORY_DIRS = ('dungeon', 'story')

MIN_GIT_VERSION = (2, 30)


def _run(args, cwd=None, capture=False):
    """Run a git command, letting long operations stream to the terminal."""
    return subprocess.run(
        args, cwd=cwd, check=True, text=True,
        capture_output=capture,
    )


def _git_version():
    """Return the installed git version as a tuple, or None if unusable."""
    try:
        raw = _run(['git', '--version'], capture=True).stdout.strip()
    except (subprocess.CalledProcessError, OSError):
        return None
    # "git version 2.49.0" -> (2, 49, 0)
    parts = raw.split()[2] if len(raw.split()) > 2 else ''
    numbers = []
    for chunk in parts.split('.'):
        digits = ''.join(c for c in chunk if c.isdigit())
        numbers.append(int(digits) if digits else 0)
    return tuple(numbers[:3]) if numbers else None


def _dir_exists(repo, path):
    """Check whether a directory exists in the checked-out tree."""
    try:
        _run(['git', '-C', repo, 'ls-tree', '-d', '--name-only',
              'HEAD:%s' % path], capture=True)
        return True
    except subprocess.CalledProcessError:
        return False


def _wanted_paths(repo, regions):
    """Build the sparse-checkout list, skipping directories the region lacks."""
    paths = []
    for region in regions:
        for name in FIXED_DIRS:
            path = '%s/%s' % (region, name)
            if _dir_exists(repo, path):
                paths.append(path)
            else:
                print('  ! %s not present, skipping' % path)
        for name in STORY_DIRS:
            path = '%s/gamecfg/%s' % (region, name)
            if _dir_exists(repo, path):
                paths.append(path)
            else:
                print('  ! %s not present, skipping' % path)
    return paths


def _clone(dest, branch):
    print('Cloning %s (blobless, no checkout) ...' % REPO_URL)
    _run(['git', 'clone', '--filter=blob:none', '--sparse', '--depth', '1',
          '--branch', branch, REPO_URL, dest])


def _refresh(dest, branch):
    """Fetch the latest commit into an existing checkout."""
    print('Fetching latest %s ...' % branch)
    _run(['git', '-C', dest, 'fetch', '--filter=blob:none', '--depth', '1',
          'origin', branch])
    _run(['git', '-C', dest, 'reset', '--hard', 'FETCH_HEAD'])


def fetch(dest, branch=DEFAULT_BRANCH, regions=DEFAULT_REGIONS, force=False):
    """Fetch the Lua sources into ``dest``.

    Returns 0 on success, 1 on failure.
    """
    version = _git_version()
    if version is None:
        print('✗ git is not available on PATH', file=sys.stderr)
        return 1
    if version < MIN_GIT_VERSION:
        print('✗ git %s found, but %s or newer is required for blobless '
              'sparse clones' % ('.'.join(str(v) for v in version),
                                 '.'.join(str(v) for v in MIN_GIT_VERSION)),
              file=sys.stderr)
        return 1

    if force and os.path.isdir(dest):
        print('Removing stale checkout at %s ...' % dest)
        shutil.rmtree(dest, ignore_errors=True)

    already = os.path.isdir(os.path.join(dest, '.git'))
    if already:
        _refresh(dest, branch)
    else:
        if os.path.isdir(dest):
            # Non-git leftovers would break `git clone` into the same path.
            shutil.rmtree(dest, ignore_errors=True)
        _clone(dest, branch)

    print('Selecting directories to check out ...')
    paths = _wanted_paths(dest, regions)
    if not paths:
        print('✗ none of the expected data directories were found in %s @ %s'
              % (REPO_URL, branch), file=sys.stderr)
        return 1
    for path in paths:
        print('  + %s' % path)

    _run(['git', '-C', dest, 'sparse-checkout', 'set'] + paths)
    print('Checking out files (first run downloads the blobs) ...')
    _run(['git', '-C', dest, 'checkout'])

    try:
        head = _run(['git', '-C', dest, 'log', '-1', '--format=%h %ad %s',
                     '--date=short'], capture=True).stdout.strip()
    except subprocess.CalledProcessError:
        head = '(unknown)'
    print('✓ Lua sources ready: %s' % head)
    return 0


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument('--dest', default=None,
                        help='target directory (default: AzurLaneLuaScripts '
                             'next to the repository root)')
    parser.add_argument('--branch', default=DEFAULT_BRANCH,
                        help='upstream branch (default: %s)' % DEFAULT_BRANCH)
    parser.add_argument('--regions', nargs='+', default=list(DEFAULT_REGIONS),
                        help='regions to fetch (default: %s)'
                             % ' '.join(DEFAULT_REGIONS))
    parser.add_argument('--force', action='store_true',
                        help='delete any existing checkout and re-clone')
    args = parser.parse_args(argv)

    if args.dest is None:
        root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        args.dest = os.path.join(root, 'AzurLaneLuaScripts')

    return fetch(args.dest, args.branch, args.regions, args.force)


if __name__ == '__main__':
    sys.exit(main())
