#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Core client for fetching raw wikitext from wiki.biligame.com/blhx.

Usage as a module:
    from scripts.wiki_client import WikiClient
    client = WikiClient()
    text = client.fetch_raw("杜威")
    pages = client.fetch_multiple(["杜威", "模块:舰娘数据"])

Usage as a standalone script:
    python scripts/wiki_client.py 杜威
    python scripts/wiki_client.py --save 模块:舰娘数据
    python scripts/wiki_client.py --list ships.txt --output-dir cache/
"""

import sys
import io
import time
import argparse
import os
from pathlib import Path
from typing import Optional

try:
    import requests
except ImportError:
    print("requests not installed. Run: pip install requests")
    sys.exit(1)


def _fix_win_encoding():
    """Fix Windows console encoding for UTF-8 output. Call once in main()."""
    if sys.platform == 'win32':
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
        sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')

WIKI_BASE = "https://wiki.biligame.com/blhx"

# Default request delay (seconds) — be polite to the wiki server
DEFAULT_DELAY = 0.5

# Cookies file is searched relative to the project root (parent of scripts/)
_PROJECT_ROOT = Path(__file__).parent.parent
_COOKIES_FILE = _PROJECT_ROOT / 'cookies.json'


def load_cookies(path: Optional[Path] = None) -> dict:
    """Load wiki cookies from a JSON file.

    Looks for cookies.json in the project root by default.
    Copy cookies.json.example to cookies.json and fill in your values.

    Raises:
        FileNotFoundError: if the cookies file does not exist.
        ValueError: if the file is not valid JSON.
    """
    import json
    cookies_path = path or _COOKIES_FILE
    if not cookies_path.exists():
        raise FileNotFoundError(
            f"Cookies file not found: {cookies_path}\n"
            f"Copy cookies.json.example to cookies.json and fill in your values."
        )
    return json.loads(cookies_path.read_text(encoding='utf-8'))


class WikiClient:
    """Client for fetching raw wikitext from the Azur Lane wiki."""

    def __init__(self, cookies: Optional[dict] = None, delay: float = DEFAULT_DELAY):
        self.cookies = cookies or load_cookies()
        self.delay = delay
        self._session = requests.Session()
        self._session.cookies.update(self.cookies)

    def fetch_raw(self, title: str) -> str:
        """Fetch raw wikitext for a given page title.

        Args:
            title: Wiki page title (e.g. "杜威", "模块:舰娘数据")

        Returns:
            Raw wikitext string, or "" on failure.
        """
        url = f"{WIKI_BASE}/index.php"
        params = {'title': title, 'action': 'raw'}
        try:
            response = self._session.get(url, params=params, timeout=30)
            response.encoding = 'utf-8'
            if self.delay > 0:
                time.sleep(self.delay)
            if response.status_code == 200:
                return response.text
            elif response.status_code == 404:
                print(f"  [404] Page not found: {title}", file=sys.stderr)
                return ""
            else:
                print(f"  [{response.status_code}] Failed: {title}", file=sys.stderr)
                return ""
        except Exception as e:
            print(f"  [ERROR] {title}: {e}", file=sys.stderr)
            return ""

    def fetch_multiple(self, titles: list, verbose: bool = True) -> dict:
        """Fetch multiple pages.

        Returns:
            {title: wikitext} dict.
        """
        results = {}
        for i, title in enumerate(titles):
            if verbose:
                print(f"  [{i+1}/{len(titles)}] {title}")
            results[title] = self.fetch_raw(title)
        return results

    def fetch_and_save(self, title: str, output_dir: str) -> Optional[Path]:
        """Fetch a page and save to a file.

        Returns:
            Path to saved file, or None on failure.
        """
        text = self.fetch_raw(title)
        if not text:
            return None

        # Sanitize filename: replace : with _ and other unsafe chars
        safe_name = title.replace(':', '_').replace('/', '_').replace('\\', '_')
        output_path = Path(output_dir) / f"{safe_name}.txt"
        output_path.parent.mkdir(parents=True, exist_ok=True)
        output_path.write_text(text, encoding='utf-8')
        return output_path


# ── CLI entry point ──────────────────────────────────────────────────────────

def main():
    _fix_win_encoding()
    parser = argparse.ArgumentParser(
        description="Fetch raw wikitext from wiki.biligame.com/blhx",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Print raw wikitext
  python scripts/wiki_client.py 杜威

  # Save to file
  python scripts/wiki_client.py --save --output-dir wiki_cache/ 模块:舰娘数据

  # Fetch a list of pages from a file
  python scripts/wiki_client.py --list ships.txt --save --output-dir wiki_cache/

  # Extract specific template fields
  python scripts/wiki_client.py --field 舰种 --field 稀有度 杜威
""")
    parser.add_argument('titles', nargs='*', help='Page title(s) to fetch')
    parser.add_argument('--list', '-l', metavar='FILE',
                        help='File with one page title per line')
    parser.add_argument('--save', '-s', action='store_true',
                        help='Save output to files instead of printing')
    parser.add_argument('--output-dir', '-o', default='wiki_cache',
                        help='Directory for saved files (default: wiki_cache/)')
    parser.add_argument('--field', '-f', action='append', dest='fields',
                        help='Extract specific template field(s) only')
    parser.add_argument('--delay', type=float, default=DEFAULT_DELAY,
                        help=f'Delay between requests in seconds (default: {DEFAULT_DELAY})')

    args = parser.parse_args()

    # Collect titles
    titles = list(args.titles)
    if args.list:
        with open(args.list, encoding='utf-8') as f:
            titles += [line.strip() for line in f if line.strip()]

    if not titles:
        parser.print_help()
        sys.exit(0)

    client = WikiClient(delay=args.delay)

    for title in titles:
        print(f"Fetching: {title}")
        text = client.fetch_raw(title)
        if not text:
            continue

        if args.fields:
            # Extract and print only the requested fields
            import re
            print(f"\n{'─'*60}")
            print(f"Page: {title}")
            print(f"{'─'*60}")
            for field in args.fields:
                pattern = rf'\|{re.escape(field)}\s*=\s*([^\n|}}]*)'
                match = re.search(pattern, text)
                val = match.group(1).strip() if match else '(not found)'
                print(f"  |{field} = {val}")
        elif args.save:
            path = client.fetch_and_save(title, args.output_dir)
            if path:
                print(f"  Saved: {path}")
        else:
            print(f"\n{'='*80}")
            print(f"Page: {title}")
            print(f"{'='*80}\n")
            print(text)


if __name__ == '__main__':
    main()
