# -*- coding: utf-8 -*-
"""Juus names generator."""
import os
from .base import BaseGenerator
from ..core import parse_data_file


class JuusNamesGenerator(BaseGenerator):
    """Generator for Juus social media names."""

    def generate(self):
        """Generate Juus names file."""
        juus_name_template = parse_data_file('activity_ins_ship_group_template', config=self.config)
        ship_statistics = parse_data_file('ship_data_statistics', config=self.config)
        ship_template = parse_data_file('ship_data_template', config=self.config)

        filepath = os.path.join(self.config.output_directory, 'JuusNames.txt')
        with open(filepath, 'w+', encoding='utf-8') as f:
            for k, v in juus_name_template.items():
                name = self._get_ship_name(v['ship_group'], ship_statistics, ship_template)
                if name:
                    f.write(name + ' ' + v['name'] + '\n')

    def _get_ship_name(self, group_id, ship_statistics, ship_template):
        """Get ship name from group ID."""
        for k, v in ship_template.items():
            if v['group_type'] == group_id:
                for i, j in ship_statistics.items():
                    if j['id'] == v['id']:
                        return j['name']
        return None
