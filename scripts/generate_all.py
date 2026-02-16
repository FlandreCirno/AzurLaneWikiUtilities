# -*- coding: utf-8 -*-
"""Generate all wiki content."""
import sys
import os

# Add src to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from azurlane_wiki.cli import main

if __name__ == '__main__':
    sys.exit(main())
