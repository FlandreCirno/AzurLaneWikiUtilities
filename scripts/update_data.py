# -*- coding: utf-8 -*-
"""Update AzurLaneData submodule."""
import subprocess
import sys
import os


def update_submodule():
    """Update the AzurLaneData git submodule."""
    print("Updating AzurLaneData submodule...")

    try:
        # Update submodule
        result = subprocess.run(
            ['git', 'submodule', 'update', '--remote', 'AzurLaneData'],
            capture_output=True,
            text=True,
            check=True
        )

        print(result.stdout)

        # Show latest commit
        result = subprocess.run(
            ['git', '-C', 'AzurLaneData', 'log', '-1', '--oneline'],
            capture_output=True,
            text=True,
            check=True
        )

        print(f"✓ Submodule updated to: {result.stdout.strip()}")
        return 0

    except subprocess.CalledProcessError as e:
        print(f"✗ Error updating submodule: {e}", file=sys.stderr)
        if e.stderr:
            print(e.stderr, file=sys.stderr)
        return 1


if __name__ == '__main__':
    sys.exit(update_submodule())
