# -*- coding: utf-8 -*-
"""Content generators for Azur Lane Wiki."""

from .memory import MemoryGenerator
from .ship_stats import ShipStatsGenerator
from .chapter_awards import ChapterAwardsGenerator
from .ship_index import ShipIndexGenerator
from .juus_names import JuusNamesGenerator
from .character_page import CharacterPageGenerator

__all__ = [
    'MemoryGenerator',
    'ShipStatsGenerator',
    'ChapterAwardsGenerator',
    'ShipIndexGenerator',
    'JuusNamesGenerator',
    'CharacterPageGenerator',
]
