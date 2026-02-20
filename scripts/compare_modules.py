#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Compare locally generated Lua modules against the live wiki versions.

Compares:
  - Wiki/模块_舰娘数据.lua  vs  wiki page 模块:舰娘数据  (p.ship_data table)
  - Wiki/模块_装备数据.lua  vs  wiki page 模块:装备数据  (p.equip_data table)

Usage:
  python scripts/compare_modules.py              # compare both
  python scripts/compare_modules.py --ships      # compare ship data only
  python scripts/compare_modules.py --equip      # compare equipment only
  python scripts/compare_modules.py --summary    # one-line summary per module
"""

import sys
import io
import re
import argparse
from pathlib import Path

# Allow importing wiki_client from same directory
sys.path.insert(0, str(Path(__file__).parent))
from wiki_client import WikiClient

PROJECT_ROOT = Path(__file__).parent.parent
WIKI_DIR = PROJECT_ROOT / 'Wiki'


# ── Lua parsers ──────────────────────────────────────────────────────────────

def _extract_table_body(text: str, table_name: str) -> str:
    """Extract the content of a Lua table assignment `p.TABLE_NAME = { ... }`.

    Returns the text between the outer braces (exclusive).
    """
    pattern = rf'p\.{re.escape(table_name)}\s*=\s*\{{'
    m = re.search(pattern, text)
    if not m:
        return ''
    start = m.end()
    depth = 1
    pos = start
    while pos < len(text) and depth > 0:
        if text[pos] == '{':
            depth += 1
        elif text[pos] == '}':
            depth -= 1
        pos += 1
    return text[start:pos - 1]


def parse_ship_data(text: str) -> dict:
    """Parse p.ship_data table into {name: {field: value}} dict.

    Expected format:
        ["名前"] = { id = 123, nationality = 1, type = 1, rarity = 3 },
        ["名前2"] = { id = 456, nationality = 1, type = 1, rarity = 4, transform = true },
    """
    body = _extract_table_body(text, 'ship_data')
    if not body:
        return {}

    ships = {}
    # Match: ["name"] = { ... }
    entry_pattern = re.compile(r'\["([^"]+)"\]\s*=\s*\{([^}]+)\}')
    field_pattern = re.compile(r'(\w+)\s*=\s*(true|false|\d+)')

    for m in entry_pattern.finditer(body):
        name = m.group(1)
        fields_str = m.group(2)
        entry = {}
        for fm in field_pattern.finditer(fields_str):
            key, val = fm.group(1), fm.group(2)
            if val == 'true':
                entry[key] = True
            elif val == 'false':
                entry[key] = False
            else:
                entry[key] = int(val)
        ships[name] = entry
    return ships


def parse_equip_data(text: str) -> dict:
    """Parse p.equip_data table into {id: {field: value}} dict.

    Expected format (array of records without string keys):
        {
            id = 500,
            name = "小海狸中队队徽",
            type = 10,
            nationality = 1,
            displayname = "...",          -- optional
            sub_equips = {
                { tech = 0, rarity = 5, id = 500 };
                { tech = 1, rarity = 5, id = 501 };
            }
        };
    """
    body = _extract_table_body(text, 'equip_data')
    if not body:
        return {}

    equips = {}
    # Split on top-level record boundaries: find `{` ... `};`
    # We do a manual depth-tracking scan so nested braces are handled.
    pos = 0
    while pos < len(body):
        if body[pos] != '{':
            pos += 1
            continue
        # Found start of a record
        depth = 1
        start = pos + 1
        pos += 1
        while pos < len(body) and depth > 0:
            if body[pos] == '{':
                depth += 1
            elif body[pos] == '}':
                depth -= 1
            pos += 1
        record_text = body[start:pos - 1]

        # Parse simple scalar fields (exclude sub_equips block)
        entry = {}

        # id
        m = re.search(r'\bid\s*=\s*(\d+)', record_text)
        if not m:
            continue
        entry['id'] = int(m.group(1))

        # name  (may contain Chinese/special chars; quoted string)
        m = re.search(r'\bname\s*=\s*"([^"]*)"', record_text)
        entry['name'] = m.group(1) if m else ''

        # type
        m = re.search(r'\btype\s*=\s*(\d+)', record_text)
        entry['type'] = int(m.group(1)) if m else 0

        # nationality
        m = re.search(r'\bnationality\s*=\s*(\d+)', record_text)
        entry['nationality'] = int(m.group(1)) if m else 0

        # displayname (optional)
        m = re.search(r'\bdisplayname\s*=\s*"([^"]*)"', record_text)
        if m:
            entry['displayname'] = m.group(1)

        # sub_equips: list of {tech, rarity, id}
        sub_equips = []
        sub_body_m = re.search(r'\bsub_equips\s*=\s*\{(.+?)\}', record_text, re.DOTALL)
        if sub_body_m:
            sub_text = sub_body_m.group(1)
            sub_pattern = re.compile(
                r'\{\s*tech\s*=\s*(\d+),\s*rarity\s*=\s*(\d+),\s*id\s*=\s*(\d+)\s*\}'
            )
            for sm in sub_pattern.finditer(sub_text):
                sub_equips.append({
                    'tech': int(sm.group(1)),
                    'rarity': int(sm.group(2)),
                    'id': int(sm.group(3)),
                })
        entry['sub_equips'] = sub_equips

        equips[entry['id']] = entry

    return equips


# ── Comparison helpers ───────────────────────────────────────────────────────

def _fmt_ship(entry: dict) -> str:
    parts = [f"id={entry.get('id')}", f"nat={entry.get('nationality')}",
             f"type={entry.get('type')}", f"rarity={entry.get('rarity')}"]
    if entry.get('transform'):
        parts.append('transform=true')
    return '{' + ', '.join(parts) + '}'


def compare_ship_data(local_text: str, wiki_text: str, summary_only: bool = False):
    """Compare p.ship_data tables between local and wiki."""
    local = parse_ship_data(local_text)
    wiki = parse_ship_data(wiki_text)

    if not local:
        print("[ERROR] Could not parse local ship_data table")
        return
    if not wiki:
        print("[ERROR] Could not parse wiki ship_data table")
        return

    local_names = set(local)
    wiki_names = set(wiki)

    only_local = sorted(local_names - wiki_names)
    only_wiki = sorted(wiki_names - local_names)
    common = local_names & wiki_names

    diffs = []
    for name in sorted(common):
        le, we = local[name], wiki[name]
        fields = set(le) | set(we)
        changed = {}
        for f in fields:
            lv, wv = le.get(f), we.get(f)
            if lv != wv:
                changed[f] = (lv, wv)
        if changed:
            diffs.append((name, changed))

    if summary_only:
        print(f"  ship_data: {len(local)} local, {len(wiki)} wiki | "
              f"+{len(only_local)} new, -{len(only_wiki)} removed, ~{len(diffs)} changed")
        return

    print(f"\n{'═'*70}")
    print(f"  模块:舰娘数据  —  p.ship_data comparison")
    print(f"{'═'*70}")
    print(f"  Local: {len(local):4d} ships   Wiki: {len(wiki):4d} ships")

    if only_local:
        print(f"\n  [+] In local only ({len(only_local)}) — new ships not yet on wiki:")
        for name in only_local:
            print(f"      {name:20s}  {_fmt_ship(local[name])}")

    if only_wiki:
        print(f"\n  [-] In wiki only ({len(only_wiki)}) — removed from generated output:")
        for name in only_wiki:
            print(f"      {name:20s}  {_fmt_ship(wiki[name])}")

    if diffs:
        print(f"\n  [~] Different values ({len(diffs)}):")
        for name, changed in diffs:
            parts = []
            for f, (lv, wv) in sorted(changed.items()):
                parts.append(f"{f}: {lv!r} → {wv!r}")
            print(f"      {name:20s}  {',  '.join(parts)}")

    if not only_local and not only_wiki and not diffs:
        print("\n  [OK] Perfect match — no differences found.")
    else:
        total = len(only_local) + len(only_wiki) + len(diffs)
        print(f"\n  Total issues: {total}")


def _fmt_equip(entry: dict) -> str:
    subs = ','.join(f"t{s['tech']}r{s['rarity']}" for s in entry.get('sub_equips', []))
    return (f"name={entry.get('name')!r}, type={entry.get('type')}, "
            f"nat={entry.get('nationality')}, subs=[{subs}]")


def compare_equip_data(local_text: str, wiki_text: str, summary_only: bool = False):
    """Compare p.equip_data tables between local and wiki."""
    local = parse_equip_data(local_text)
    wiki = parse_equip_data(wiki_text)

    if not local:
        print("[ERROR] Could not parse local equip_data table")
        return
    if not wiki:
        print("[ERROR] Could not parse wiki equip_data table")
        return

    local_ids = set(local)
    wiki_ids = set(wiki)

    only_local = sorted(local_ids - wiki_ids)
    only_wiki = sorted(wiki_ids - local_ids)
    common = local_ids & wiki_ids

    diffs = []
    for eid in sorted(common):
        le, we = local[eid], wiki[eid]
        changed = {}
        for f in ('name', 'type', 'nationality', 'displayname'):
            lv, wv = le.get(f), we.get(f)
            if lv != wv:
                changed[f] = (lv, wv)
        # Compare sub_equips
        lsubs = le.get('sub_equips', [])
        wsubs = we.get('sub_equips', [])
        if lsubs != wsubs:
            changed['sub_equips'] = (lsubs, wsubs)
        if changed:
            diffs.append((eid, le.get('name', str(eid)), changed))

    if summary_only:
        print(f"  equip_data: {len(local)} local, {len(wiki)} wiki | "
              f"+{len(only_local)} new, -{len(only_wiki)} removed, ~{len(diffs)} changed")
        return

    print(f"\n{'═'*70}")
    print(f"  模块:装备数据  —  p.equip_data comparison")
    print(f"{'═'*70}")
    print(f"  Local: {len(local):4d} equips   Wiki: {len(wiki):4d} equips")

    if only_local:
        print(f"\n  [+] In local only ({len(only_local)}) — new equipment not yet on wiki:")
        for eid in only_local:
            print(f"      id={eid:5d}  {_fmt_equip(local[eid])}")

    if only_wiki:
        print(f"\n  [-] In wiki only ({len(only_wiki)}) — removed from generated output:")
        for eid in only_wiki:
            print(f"      id={eid:5d}  {_fmt_equip(wiki[eid])}")

    if diffs:
        print(f"\n  [~] Different values ({len(diffs)}):")
        for eid, name, changed in diffs:
            print(f"      id={eid:5d}  {name!r}")
            for f, (lv, wv) in sorted(changed.items()):
                if f == 'sub_equips':
                    print(f"        sub_equips:")
                    print(f"          local: {lv}")
                    print(f"          wiki:  {wv}")
                else:
                    print(f"        {f}: {lv!r}  →  {wv!r}")

    if not only_local and not only_wiki and not diffs:
        print("\n  [OK] Perfect match — no differences found.")
    else:
        total = len(only_local) + len(only_wiki) + len(diffs)
        print(f"\n  Total issues: {total}")


# ── Main ─────────────────────────────────────────────────────────────────────

def main():
    if sys.platform == 'win32':
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
        sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')
    parser = argparse.ArgumentParser(
        description="Compare generated Lua modules against the live wiki.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python scripts/compare_modules.py               # compare both modules
  python scripts/compare_modules.py --ships       # ship data only
  python scripts/compare_modules.py --equip       # equipment only
  python scripts/compare_modules.py --summary     # one-line summary
""")
    parser.add_argument('--ships', action='store_true', help='Compare ship data module')
    parser.add_argument('--equip', action='store_true', help='Compare equipment module')
    parser.add_argument('--summary', '-s', action='store_true',
                        help='Print a one-line summary per module (no detail)')
    parser.add_argument('--no-fetch', action='store_true',
                        help='Use cached wiki files from wiki_cache/ instead of fetching')
    parser.add_argument('--cache-dir', default='wiki_cache',
                        help='Directory for cached wiki pages (default: wiki_cache/)')
    args = parser.parse_args()

    # Default: compare both
    do_ships = args.ships or not (args.ships or args.equip)
    do_equip = args.equip or not (args.ships or args.equip)

    client = WikiClient()
    cache_dir = Path(args.cache_dir)

    def get_wiki_text(page_title: str, filename: str) -> str:
        """Fetch from wiki or load from cache."""
        cache_path = cache_dir / filename
        if args.no_fetch and cache_path.exists():
            print(f"  Using cached: {cache_path}")
            return cache_path.read_text(encoding='utf-8')
        print(f"  Fetching: {page_title} ...")
        text = client.fetch_raw(page_title)
        if text:
            cache_path.parent.mkdir(parents=True, exist_ok=True)
            cache_path.write_text(text, encoding='utf-8')
        return text

    if do_ships:
        local_path = WIKI_DIR / '模块_舰娘数据.lua'
        if not local_path.exists():
            print(f"[ERROR] Local file not found: {local_path}")
            print("  Run: python scripts/generate_all.py --generator wiki_modules")
        else:
            local_text = local_path.read_text(encoding='utf-8')
            wiki_text = get_wiki_text('模块:舰娘数据', '模块_舰娘数据_wiki.lua')
            if wiki_text:
                compare_ship_data(local_text, wiki_text, summary_only=args.summary)
            else:
                print("[ERROR] Failed to fetch 模块:舰娘数据")

    if do_equip:
        local_path = WIKI_DIR / '模块_装备数据.lua'
        if not local_path.exists():
            print(f"[ERROR] Local file not found: {local_path}")
            print("  Run: python scripts/generate_all.py --generator wiki_modules")
        else:
            local_text = local_path.read_text(encoding='utf-8')
            wiki_text = get_wiki_text('模块:装备数据', '模块_装备数据_wiki.lua')
            if wiki_text:
                compare_equip_data(local_text, wiki_text, summary_only=args.summary)
            else:
                print("[ERROR] Failed to fetch 模块:装备数据")

    print()


if __name__ == '__main__':
    main()
