# -*- coding: utf-8 -*-
"""Base generator class."""
from abc import ABC, abstractmethod
from ..config import Config, get_config


class BaseGenerator(ABC):
    """Base class for all content generators."""

    def __init__(self, config=None):
        """Initialize generator.

        Args:
            config: Config instance (creates default if None)
        """
        if config is None:
            config = get_config()
        self.config = config

    @abstractmethod
    def generate(self):
        """Generate content. Must be implemented by subclasses."""
        pass

    def set_region(self, region):
        """Change the active region.

        Args:
            region: Game region (CN, JP, EN, KR, TW)
        """
        self.config.set_region(region)
