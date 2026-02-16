# -*- coding: utf-8 -*-
"""Configuration management for Azur Lane Wiki Utilities."""
import os
from pathlib import Path


class Config:
    """Configuration class for managing paths and settings."""

    def __init__(self, region='CN'):
        """Initialize configuration.

        Args:
            region: Game region (CN, JP, EN, KR, TW)
        """
        self.region = region
        self.project_root = Path(__file__).parent.parent.parent

        # Data directories
        self.data_dir = self.project_root / 'AzurLaneData' / region
        self.json_dir = self.project_root / 'AzurLaneData' / region

        # Output directory (Wiki/ for git tracking and CI/CD)
        self.output_dir = self.project_root / 'Wiki'

        # Force ShareCfg for certain files
        self.force_sharecfg = [
            'ship_skin_template',
            'activity_ins_npc_template',
        ]

        # GameCfg file list
        self.gamecfg_list = ['dungeon', 'story', 'storyjp']

    @property
    def data_directory(self):
        """Get data directory path as string."""
        return str(self.data_dir)

    @property
    def json_directory(self):
        """Get JSON directory path as string."""
        return str(self.json_dir)

    @property
    def output_directory(self):
        """Get output directory path as string."""
        return str(self.output_dir)

    def set_region(self, region):
        """Change the active region.

        Args:
            region: Game region (CN, JP, EN, KR, TW)
        """
        self.region = region
        self.data_dir = self.project_root / 'AzurLaneData' / region
        self.json_dir = self.project_root / 'AzurLaneData' / region


# Global default config instance
_default_config = Config()


def get_config():
    """Get the default configuration instance."""
    return _default_config
