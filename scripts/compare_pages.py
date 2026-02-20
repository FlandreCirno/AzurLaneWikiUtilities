#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Compare locally generated character pages against live wiki pages.

Extracts and diffs template fields from the {{舰娘图鉴}} template.
Only compares fields that the generator actually fills in (stats, equipment,
armor, properties, etc.). Ignores voice lines and manually-maintained content.

Usage:
  # Compare a handful of specific ships
  python scripts/compare_pages.py 杜威 吾妻 飞龙·META

  # Compare all PR ships in Wiki/character/科研/
  python scripts/compare_pages.py --category 科研

  # Compare all META ships
  python scripts/compare_pages.py --category Meta

  # Compare all regular ships (建造)
  python scripts/compare_pages.py --category 建造

  # Compare every category
  python scripts/compare_pages.py --all

  # Show only ships with differences
  python scripts/compare_pages.py --all --diff-only

  # Show raw template fields side-by-side for one ship
  python scripts/compare_pages.py --raw 杜威
"""

import sys
import io
import re
import argparse
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from wiki_client import WikiClient

PROJECT_ROOT = Path(__file__).parent.parent
WIKI_DIR = PROJECT_ROOT / 'Wiki' / 'character'

# ── Fields to compare ────────────────────────────────────────────────────────
# These are the fields the generator fills in.  Fields NOT in this list
# (voice lines, skills, artist, etc.) are skipped — they are manually filled.

COMPARE_FIELDS = [
    # Basic identity
    '名称', '类型', '稀有度', '阵营', '编号', '装甲类型',
    # Initial stats
    '初始耐久', '初始装填', '初始命中', '初始炮击', '初始雷击',
    '初始机动', '初始防空', '初始航空', '初始消耗', '初始反潜',
    # Max stats
    '满级耐久', '满级装填', '满级命中', '满级炮击', '满级雷击',
    '满级机动', '满级防空', '满级航空', '满级消耗', '满级反潜',
    # Fixed stats
    '航速', '幸运',
    # Property ratings
    '图鉴耐久', '图鉴防空', '图鉴机动', '图鉴航空', '图鉴雷击', '图鉴炮击',
    # Equipment slots
    '1号槽装备类型', '2号槽装备类型', '3号槽装备类型',
    '1号槽装备效率初始', '2号槽装备效率初始', '3号槽装备效率初始',
    '1号槽装备效率满破', '2号槽装备效率满破', '3号槽装备效率满破',
    '1号槽满破武器数', '2号槽满破武器数', '3号槽满破武器数',
    '1号槽满破预装填数', '2号槽满破预装填数', '3号槽满破预装填数',
    # Strengthen bonuses (META)
    '强化加成炮击', '强化加成雷击', '强化加成航空', '强化加成装填',
    '强化加成耐久', '强化加成防空', '强化加成命中', '强化加成机动',
    # Tech points
    '解锁图鉴科技点', '突破至满星科技点', '达到120级科技点',
    # PR development bonuses (only present for PR ships)
    '5级开发加成', '10级开发加成', '15级开发加成',
    '20级开发加成', '25级开发加成', '30级开发加成',
]


# ── Parsing ──────────────────────────────────────────────────────────────────

def extract_fields(text: str, fields: list) -> dict:
    """Extract requested template fields from wikitext.

    Returns {field_name: value_string} for fields found in text.
    Values are stripped of surrounding whitespace.
    """
    result = {}
    for field in fields:
        # Match |field = value — capture only same-line content (no newlines)
        pattern = r'\|' + re.escape(field) + r'[ \t]*=[ \t]*([^\n]*)'
        m = re.search(pattern, text)
        if m:
            result[field] = m.group(1).strip()
    return result


def extract_all_fields(text: str) -> dict:
    """Extract ALL template fields (for --raw display)."""
    result = {}
    # Each field is |name = value on one line
    pattern = r'\|([^=|\n]+?)[ \t]*=[ \t]*([^\n]*)'
    for m in re.finditer(pattern, text):
        field = m.group(1).strip()
        value = m.group(2).strip()
        result[field] = value
    return result


# ── Comparison ───────────────────────────────────────────────────────────────

def compare_page(ship_name: str, local_text: str, wiki_text: str,
                 diff_only: bool = False) -> list:
    """Compare two page texts field by field.

    Returns list of (field, local_value, wiki_value) tuples for differing fields.
    """
    local = extract_fields(local_text, COMPARE_FIELDS)
    wiki = extract_fields(wiki_text, COMPARE_FIELDS)

    diffs = []
    for field in COMPARE_FIELDS:
        lv = local.get(field, '')
        wv = wiki.get(field, '')
        if lv != wv:
            # Skip if both are effectively empty/whitespace
            if not lv.strip() and not wv.strip():
                continue
            diffs.append((field, lv, wv))
    return diffs


def print_comparison(ship_name: str, diffs: list, show_header: bool = True):
    if show_header:
        print(f"\n{'─'*70}")
        print(f"  {ship_name}")
        print(f"{'─'*70}")

    if not diffs:
        print(f"  [OK] {ship_name}")
        return

    print(f"  [!!] {ship_name}  ({len(diffs)} difference(s))")
    print(f"  {'Field':<30}  {'Local':>25}    {'Wiki':>25}")
    print(f"  {'─'*30}  {'─'*25}    {'─'*25}")
    for field, lv, wv in diffs:
        lv_s = (lv[:22] + '...') if len(lv) > 25 else lv
        wv_s = (wv[:22] + '...') if len(wv) > 25 else wv
        print(f"  {field:<30}  {lv_s:>25}  →  {wv_s:<25}")


def print_raw_side_by_side(ship_name: str, local_text: str, wiki_text: str):
    """Print all fields side-by-side for manual inspection."""
    local = extract_all_fields(local_text)
    wiki = extract_all_fields(wiki_text)
    all_fields = sorted(set(local) | set(wiki))

    print(f"\n{'═'*90}")
    print(f"  Raw field comparison: {ship_name}")
    print(f"{'═'*90}")
    print(f"  {'Field':<35}  {'Local':>25}    {'Wiki':<30}")
    print(f"  {'─'*35}  {'─'*25}    {'─'*30}")
    for field in all_fields:
        lv = local.get(field, '(absent)')
        wv = wiki.get(field, '(absent)')
        lv_s = (lv[:22] + '...') if len(lv) > 25 else lv
        wv_s = (wv[:27] + '...') if len(wv) > 30 else wv
        marker = '  ' if lv == wv else '>>'
        print(f"{marker} {field:<35}  {lv_s:>25}    {wv_s:<30}")


# ── File discovery ───────────────────────────────────────────────────────────

CATEGORY_MAP = {
    '建造': WIKI_DIR / '建造',
    '科研': WIKI_DIR / '科研',
    'Meta': WIKI_DIR / 'Meta',
    'meta': WIKI_DIR / 'Meta',
}


def get_ships_in_category(category: str) -> list:
    """Return list of (ship_name, local_path) for a category."""
    path = CATEGORY_MAP.get(category)
    if not path or not path.exists():
        print(f"[ERROR] Category directory not found: {path}")
        return []
    return [(p.stem, p) for p in sorted(path.glob('*.txt'))]


# ── Main ─────────────────────────────────────────────────────────────────────

def main():
    if sys.platform == 'win32':
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
        sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')
    parser = argparse.ArgumentParser(
        description="Compare generated character pages against wiki.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python scripts/compare_pages.py 杜威 吾妻
  python scripts/compare_pages.py --category 科研
  python scripts/compare_pages.py --category Meta
  python scripts/compare_pages.py --all --diff-only
  python scripts/compare_pages.py --raw 杜威
""")
    parser.add_argument('ships', nargs='*', help='Ship name(s) to compare')
    parser.add_argument('--category', '-c', choices=['建造', '科研', 'Meta'],
                        help='Compare all ships in a category folder')
    parser.add_argument('--all', '-a', action='store_true',
                        help='Compare all categories')
    parser.add_argument('--diff-only', '-d', action='store_true',
                        help='Only show ships with differences')
    parser.add_argument('--raw', metavar='SHIP',
                        help='Show all fields side-by-side for one ship')
    parser.add_argument('--no-fetch', action='store_true',
                        help='Use cached wiki files from wiki_cache/')
    parser.add_argument('--cache-dir', default='wiki_cache',
                        help='Cache directory (default: wiki_cache/)')
    parser.add_argument('--limit', type=int, default=0,
                        help='Limit number of ships per category (for testing)')
    args = parser.parse_args()

    client = WikiClient()
    cache_dir = Path(args.cache_dir)

    def get_local_text(ship_name: str, local_path: Path = None) -> str:
        if local_path and local_path.exists():
            return local_path.read_text(encoding='utf-8')
        # Search all categories
        for cat_path in CATEGORY_MAP.values():
            p = cat_path / f"{ship_name}.txt"
            if p.exists():
                return p.read_text(encoding='utf-8')
        return ''

    def get_wiki_text(ship_name: str) -> str:
        cache_path = cache_dir / 'pages' / f"{ship_name}.txt"
        if args.no_fetch and cache_path.exists():
            return cache_path.read_text(encoding='utf-8')
        text = client.fetch_raw(ship_name)
        if text:
            cache_path.parent.mkdir(parents=True, exist_ok=True)
            cache_path.write_text(text, encoding='utf-8')
        return text

    # ── --raw mode ──
    if args.raw:
        ship_name = args.raw
        local = get_local_text(ship_name)
        if not local:
            print(f"[ERROR] Local file not found for: {ship_name}")
            return
        wiki = get_wiki_text(ship_name)
        if not wiki:
            print(f"[ERROR] Could not fetch wiki page: {ship_name}")
            return
        print_raw_side_by_side(ship_name, local, wiki)
        return

    # ── Build ship list ──
    ship_list: list  # [(ship_name, local_path_or_None)]
    ship_list = []

    if args.ships:
        ship_list = [(name, None) for name in args.ships]

    if args.category:
        ship_list += get_ships_in_category(args.category)

    if args.all:
        for cat in ['建造', '科研', 'Meta']:
            ship_list += get_ships_in_category(cat)

    if not ship_list:
        parser.print_help()
        return

    # Deduplicate
    seen = set()
    deduped = []
    for item in ship_list:
        if item[0] not in seen:
            seen.add(item[0])
            deduped.append(item)
    ship_list = deduped

    if args.limit:
        ship_list = ship_list[:args.limit]

    # ── Compare ──
    total = len(ship_list)
    ok = 0
    diff_count = 0
    error_count = 0
    ships_with_diffs = []

    print(f"Comparing {total} ship(s)...\n")

    for i, (ship_name, local_path) in enumerate(ship_list):
        local = get_local_text(ship_name, local_path)
        if not local:
            print(f"  [??] {ship_name}: local file not found")
            error_count += 1
            continue

        wiki = get_wiki_text(ship_name)
        if not wiki:
            print(f"  [XX] {ship_name}: failed to fetch wiki page")
            error_count += 1
            continue

        diffs = compare_page(ship_name, local, wiki)

        if diffs:
            diff_count += 1
            ships_with_diffs.append((ship_name, diffs))
            if not args.diff_only or diffs:
                print_comparison(ship_name, diffs, show_header=True)
        else:
            ok += 1
            if not args.diff_only:
                print(f"  [OK] {ship_name}")

    # ── Summary ──
    print(f"\n{'═'*70}")
    print(f"  SUMMARY  ({total} ships)")
    print(f"{'═'*70}")
    print(f"  OK:     {ok:4d}")
    print(f"  DIFFS:  {diff_count:4d}")
    print(f"  ERRORS: {error_count:4d}")

    if ships_with_diffs:
        print(f"\n  Ships with differences:")
        for ship_name, diffs in ships_with_diffs:
            print(f"    {ship_name} ({len(diffs)} fields)")

    print()


if __name__ == '__main__':
    main()
