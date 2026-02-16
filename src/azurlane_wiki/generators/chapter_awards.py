# -*- coding: utf-8 -*-
"""Chapter awards generator."""
import os
import re
from .base import BaseGenerator
from ..core import parse_data_file, get_chapter_template, get_ship_name, get_ship_type, parse_name_code, sanitize_filename


class ChapterAwardsGenerator(BaseGenerator):
    """Generator for chapter award/drop information."""

    SHIP_TYPE = [
        '驱逐', '轻巡', '重巡', '战巡', '战列', '轻母', '航母', '潜艇',
        '航巡', '航战', '雷巡', '维修', '重炮', '占位', '占位', '占位',
        '潜母', '超巡', '运输', '导驱', '导驱', '风帆', '风帆', '风帆'
    ]

    SHIP_AWARD_LIST = [
        '驱逐', '轻巡', '重巡', '战巡', '战列', '航母', '轻母',
        '重炮', '维修', '潜艇', '风帆'
    ]

    def generate(self):
        """Generate chapter award files."""
        ship_template = parse_data_file('ship_data_template', config=self.config)
        ship_statistics = parse_data_file('ship_data_statistics', config=self.config)
        ship_skin = parse_data_file(
            'ship_skin_template',
            file_path=os.path.join('sharecfg', 'ship_skin_template_sublist'),
            mode=1,
            config=self.config
        )
        map_data = parse_data_file('expedition_data_by_map', config=self.config)
        chapter_template = get_chapter_template(config=self.config)
        item_statistics = parse_data_file('item_data_statistics', config=self.config)
        item_virtual_statistics = parse_data_file('item_virtual_data_statistics', config=self.config)
        name_code = self._get_name_code()

        # Process chapter awards
        for c in chapter_template.values():
            c['characterAward'] = []
            c['equipmentAward'] = []
            for award in c['awards']:
                if award[0] == 2:
                    if award[1] in item_statistics:
                        for a in item_statistics[award[1]]['display_icon']:
                            if a[0] == 4:
                                c['characterAward'].append(a[1])
                    elif award[1] in item_virtual_statistics:
                        for a in item_virtual_statistics[award[1]]['display_icon']:
                            if a[0] == 4:
                                c['characterAward'].append(a[1])

        # Organize maps
        map_name = {}
        for m in map_data.values():
            m['chapters'] = {}
            for c in chapter_template.values():
                if c['map'] == m['map']:
                    m['chapters'][c['id']] = c
            if m['name'] in map_name.keys():
                map_name[m['name']][m['map']] = m
            else:
                map_name[m['name']] = {m['map']: m}

        # Categorize maps
        for m in map_name.values():
            for m2 in m.values():
                if m2['type'] == 1:
                    m2['category'] = '普通主线'
                elif m2['type'] == 2:
                    m2['category'] = '困难主线'
                else:
                    if m2['on_activity'] == 0:
                        m2['category'] = '作战档案'
                    else:
                        on_activity = m2['on_activity']
                        for m3 in m.values():
                            if m3['on_activity'] != 0 and m3['on_activity'] < on_activity:
                                on_activity = m3['on_activity']
                        if on_activity != m2['on_activity']:
                            m2['category'] = '复刻活动'
                        else:
                            m2['category'] = '限时活动'

        # Write output files
        for m in map_data.values():
            filename = re.match(r'[^|]*', m['name'])[0]
            if m['type'] == 4:
                filename += '普通'
            elif m['type'] == 5:
                filename += '困难'
            filename = sanitize_filename(filename) + '.txt'

            file_path = os.path.join(
                self.config.output_directory,
                'chapterAwards',
                m['category'],
                filename
            )

            os.makedirs(os.path.dirname(file_path), exist_ok=True)

            if os.path.isfile(file_path):
                raise Exception(f'File: {filename} already exists!')

            with open(file_path, 'w', encoding='utf-8') as f:
                output = self._format_map(m, ship_skin, ship_template, ship_statistics)
                output = parse_name_code(output, name_code)
                f.write(output)

    def _get_name_code(self):
        """Get name code dictionary (CN only)."""
        if self.config.region == 'CN':
            from ..core import get_name_code
            return get_name_code(self.config)
        return {}

    def _format_map(self, map_data, ship_skin, ship_template, ship_statistics):
        """Format map data as wiki text."""
        output = map_data['name'] + '\n'
        for k in sorted(map_data['chapters'].keys()):
            output += self._format_chapter(
                map_data['chapters'][k],
                ship_skin,
                ship_template,
                ship_statistics
            )
        return output

    def _format_chapter(self, chapter_data, ship_skin, ship_template, ship_statistics):
        """Format chapter data as wiki text."""
        output = chapter_data['chapter_name'] + '-' + chapter_data['name'] + '\n'

        character_list = {t: [] for t in self.SHIP_AWARD_LIST}

        for award in chapter_data['characterAward']:
            ship_type = get_ship_type(award, ship_template, award // 10)
            if self.SHIP_TYPE[ship_type - 1] in character_list.keys():
                ship_name = get_ship_name(award, ship_skin, ship_statistics)
                character_list[self.SHIP_TYPE[ship_type - 1]].append(ship_name)

        for k, v in character_list.items():
            output += '|掉落' + k + '='
            for s in v:
                output += s + '、'
            output = output[:-1] + '\n'

        return output
