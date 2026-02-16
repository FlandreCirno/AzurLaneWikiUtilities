# -*- coding: utf-8 -*-
"""Clean output directory before generation."""
import os
import sys
from pathlib import Path

# Add src to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from azurlane_wiki.config import get_config


def clean_output():
    """Clean Wiki output directories."""
    config = get_config()
    output_dir = Path(config.output_directory)  # Points to Wiki/

    paths_to_clean = [
        output_dir / 'memories',
        output_dir / 'chapterAwards' / '普通主线',
        output_dir / 'chapterAwards' / '困难主线',
        output_dir / 'chapterAwards' / '限时活动',
        output_dir / 'chapterAwards' / '复刻活动',
        output_dir / 'chapterAwards' / '作战档案',
    ]

    files_to_remove = []

    print(f"Cleaning Wiki directories at {output_dir}...")

    for path in paths_to_clean:
        if path.exists() and path.is_dir():
            files = list(path.glob('*.txt'))
            for file in files:
                file.unlink()
                print(f"  Removed: {file.relative_to(output_dir)}")
        else:
            path.mkdir(parents=True, exist_ok=True)
            print(f"  Created: {path.relative_to(output_dir)}")

    # Remove individual files if specified
    for file_path in files_to_remove:
        full_path = output_dir / file_path
        if full_path.exists():
            full_path.unlink()
            print(f"  Removed: {file_path}")

    print("✓ Wiki directories cleaned")


if __name__ == "__main__":
    clean_output()
