# -*- coding: utf-8 -*-
"""Azur Lane Wiki Utilities - Tools for maintaining Azur Lane CN Wiki."""

__version__ = '2.0.0'

from .config import Config, get_config
from .generators import (
    MemoryGenerator,
    ShipStatsGenerator,
    ChapterAwardsGenerator,
    ShipIndexGenerator,
    JuusNamesGenerator,
)

__all__ = [
    'Config',
    'get_config',
    'MemoryGenerator',
    'ShipStatsGenerator',
    'ChapterAwardsGenerator',
    'ShipIndexGenerator',
    'JuusNamesGenerator',
]
