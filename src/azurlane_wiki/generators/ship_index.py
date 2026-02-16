# -*- coding: utf-8 -*-
"""Ship index generator."""
import os
from .base import BaseGenerator
from ..core import parse_data_file


class ShipIndexGenerator(BaseGenerator):
    """Generator for ship name index."""

    def generate(self):
        """Generate ship name index file."""
        ship_group = parse_data_file('ship_data_group', config=self.config)
        ship_statistics = parse_data_file('ship_data_statistics', config=self.config)
        ship_template = parse_data_file('ship_data_template', config=self.config)

        ship_collection = {}
        for k, v in ship_group.items():
            ship_collection[v['code']] = v['group_type']

        filepath = os.path.join(self.config.output_directory, 'nameIndex.txt')
        with open(filepath, 'w+', encoding='utf-8') as f:
            for k, v in ship_collection.items():
                name = self._get_ship_name(v, ship_statistics, ship_template)
                f.write(name + ', ' + str(k) + ', ' + str(v) + '\n')

    def _get_ship_name(self, group_id, ship_statistics, ship_template):
        """Get ship name from group ID."""
        for k, v in ship_template.items():
            if v['group_type'] == group_id:
                for i, j in ship_statistics.items():
                    if j['id'] == v['id']:
                        return j['name']
        return ''
