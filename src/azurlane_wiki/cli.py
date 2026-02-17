# -*- coding: utf-8 -*-
"""Command-line interface for Azur Lane Wiki Utilities."""
import argparse
import sys
import os

# Fix Windows console encoding for Unicode characters
if sys.platform == 'win32':
    import codecs
    if sys.stdout.encoding != 'utf-8':
        sys.stdout = codecs.getwriter('utf-8')(sys.stdout.buffer, 'strict')
    if sys.stderr.encoding != 'utf-8':
        sys.stderr = codecs.getwriter('utf-8')(sys.stderr.buffer, 'strict')

from .config import Config
from .generators import (
    MemoryGenerator,
    ShipStatsGenerator,
    ChapterAwardsGenerator,
    ShipIndexGenerator,
    JuusNamesGenerator,
    CharacterPageGenerator,
)


def main():
    """Main CLI entry point."""
    parser = argparse.ArgumentParser(
        description='Azur Lane Wiki Utilities - Generate wiki content from game data'
    )

    parser.add_argument(
        '--region',
        choices=['CN', 'JP', 'EN', 'KR', 'TW'],
        default='CN',
        help='Game region (default: CN)'
    )

    parser.add_argument(
        '--generator',
        choices=['all', 'memory', 'stats', 'chapters', 'index', 'juus', 'character'],
        default='all',
        help='Which generator to run (default: all)'
    )

    args = parser.parse_args()

    # Create config
    config = Config(region=args.region)

    print(f"=== Azur Lane Wiki Utilities ===")
    print(f"Region: {args.region}")
    print(f"Output directory: {config.output_directory}")
    print()

    try:
        if args.generator in ['all', 'memory']:
            print("Generating memories...")
            generator = MemoryGenerator(config)
            # Generate for all regions if 'all'
            if args.generator == 'all':
                for region in ['CN', 'JP', 'EN', 'KR', 'TW']:
                    try:
                        print(f"  - {region}")
                        generator.generate(region=region)
                    except Exception as e:
                        print(f"    [ERROR] Error in {region}: {e}")
                        continue
            else:
                generator.generate()
            print("  [OK] Memories generated")

        if args.generator in ['all', 'stats']:
            print("Generating ship statistics...")
            generator = ShipStatsGenerator(config)
            generator.generate()
            print("  [OK] Ship statistics generated")

        if args.generator in ['all', 'chapters']:
            print("Generating chapter awards...")
            generator = ChapterAwardsGenerator(config)
            generator.generate()
            print("  [OK] Chapter awards generated")

        if args.generator in ['all', 'index']:
            print("Generating ship index...")
            generator = ShipIndexGenerator(config)
            generator.generate()
            print("  [OK] Ship index generated")

        if args.generator in ['all', 'juus']:
            print("Generating Juus names...")
            generator = JuusNamesGenerator(config)
            generator.generate()
            print("  [OK] Juus names generated")

        if args.generator in ['all', 'character']:
            print("Generating character pages...")
            generator = CharacterPageGenerator(config)
            generator.generate()
            print("  [OK] Character pages generated")

        print()
        print("[SUCCESS] Generation complete!")
        return 0

    except Exception as e:
        print(f"\n[ERROR] Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        return 1


if __name__ == '__main__':
    sys.exit(main())
