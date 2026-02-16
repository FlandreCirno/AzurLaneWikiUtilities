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
        expedition_template = parse_data_file('expedition_data_template', config=self.config)
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
                output = self._format_map(m, ship_skin, ship_template, ship_statistics,
                                         expedition_template, item_statistics, item_virtual_statistics)
                output = parse_name_code(output, name_code)
                f.write(output)

    def _get_name_code(self):
        """Get name code dictionary (CN only)."""
        if self.config.region == 'CN':
            from ..core import get_name_code
            return get_name_code(self.config)
        return {}

    def _format_map(self, map_data, ship_skin, ship_template, ship_statistics,
                    expedition_template, item_statistics, item_virtual_statistics):
        """Format map data as wiki text."""
        output = map_data['name'] + '\n'
        for k in sorted(map_data['chapters'].keys()):
            output += self._format_chapter(
                map_data['chapters'][k],
                ship_skin,
                ship_template,
                ship_statistics,
                expedition_template,
                item_statistics,
                item_virtual_statistics
            )
        return output

    def _format_chapter(self, chapter_data, ship_skin, ship_template, ship_statistics,
                        expedition_template, item_statistics, item_virtual_statistics):
        """Format chapter data as wiki text with full template."""
        output = '{{关卡图鉴\n'

        # Basic information
        output += f'|地图编号={chapter_data["chapter_name"]}\n'
        output += f'|地图名={chapter_data["name"]}\n'
        output += f'|地图介绍={chapter_data.get("profiles", "")}\n'

        # Completion rewards
        output += '|通关奖励='
        output += self._format_rewards(chapter_data.get('awards', []), item_statistics, item_virtual_statistics)
        output += ' \n'

        # Three-star conditions (no actual text data available, only localization keys)
        output += '|三星条件=\n'

        # Three-star rewards (no actual data available)
        output += '|三星奖励=\n'

        # Air superiority
        output += f'|敌方原始制空值={chapter_data.get("air_dominance", "")}\n'
        output += f'|我方推荐制空值={chapter_data.get("best_air_dominance", "")}\n'

        # Repeat mode air superiority (leave blank for now)
        output += '|周回模式敌方原始制空值=\n'
        output += '|周回模式我方推荐制空值=\n'

        # Ship and attribute requirements
        output += '|舰船限定=\n'
        output += '|属性要求=\n'

        # Enemy fleet information
        enemy_levels = self._get_enemy_levels(chapter_data, expedition_template)
        output += f'|敌舰等级={enemy_levels}\n'

        # Fleet experience
        exp_data = self._get_fleet_experience(chapter_data, expedition_template)
        output += f'|小型舰队经验={exp_data.get("small", "")}\n'
        output += f'|中型舰队经验={exp_data.get("medium", "")}\n'
        output += f'|大型舰队经验={exp_data.get("large", "")}\n'
        output += f'|精英舰队经验={exp_data.get("elite", "")}\n'
        output += f'|BOSS舰队经验={exp_data.get("boss", "")}\n'

        # Boss information
        boss_level = self._get_boss_level(chapter_data, expedition_template)
        output += f'|BOSS等级={boss_level}\n'
        output += '|BOSS位置=\n'  # Complex to calculate
        output += '|BOSS阵容=\n'  # Complex to calculate

        # Requirements
        output += '|要求指挥官等级=\n'
        output += '|要求最低信号强度=\n'

        # Danger level and boss refresh
        danger_level = self._get_danger_level(chapter_data)
        output += f'|危险等级={danger_level}\n'
        output += f'|旗舰几战刷新={chapter_data.get("boss_refresh", "")}\n'

        # Oil costs (repeat mode - complex to calculate)
        output += '|周回道中油耗=\n'
        output += '|周回旗舰油耗=\n'
        output += '|周回潜艇油耗=\n'

        # Submarine start position (complex to calculate)
        output += '|潜艇起点=\n'

        # Map drops (no actual descriptive data available, only box IDs)
        output += '|地图掉落=\n'

        # Video and notes
        output += '|推图视频=\n'
        output += '|备注=\n'

        # Ship drops
        character_list = {t: [] for t in self.SHIP_AWARD_LIST}
        for award in chapter_data.get('characterAward', []):
            ship_type = get_ship_type(award, ship_template, award // 10)
            if self.SHIP_TYPE[ship_type - 1] in character_list.keys():
                ship_name = get_ship_name(award, ship_skin, ship_statistics)
                character_list[self.SHIP_TYPE[ship_type - 1]].append(ship_name)

        for k, v in character_list.items():
            output += '|掉落' + k + '='
            for s in v:
                output += s + '、'
            output = output[:-1] + '\n'

        # Equipment drops (leave blank for now)
        output += '|掉落设计图=\n'
        output += '|掉落改造图纸=\n'

        output += '}}\n\n'
        return output

    def _format_rewards(self, awards, item_statistics, item_virtual_statistics):
        """Format rewards as wiki text."""
        if not awards:
            return ''

        output = ''
        for award in awards:
            if len(award) < 2:
                continue
            award_type = award[0]
            award_id = award[1]

            # Type 2 = items
            if award_type == 2:
                item_name = ''
                item_count = ''

                # Look up in item_statistics
                if award_id in item_statistics:
                    item_name = item_statistics[award_id].get('name', '')
                # Look up in item_virtual_statistics
                elif award_id in item_virtual_statistics:
                    item_name = item_virtual_statistics[award_id].get('name', '')

                # Get count if provided
                if len(award) >= 3:
                    item_count = award[2]

                if item_name:
                    if item_count:
                        output += f'{{{{道具|{item_name}|{item_count}}}}} '
                    else:
                        output += f'{{{{道具|{item_name}}}}} '

        return output.strip()


    def _get_enemy_levels(self, chapter_data, expedition_template):
        """Get enemy fleet levels from expedition configs."""
        levels = set()

        # Get levels from all expedition configs
        expedition_list = chapter_data.get('expedition_id_weight_list', [])
        for exp in expedition_list:
            if len(exp) > 0 and exp[0] in expedition_template:
                level = expedition_template[exp[0]].get('level', 0)
                if level:
                    levels.add(level)

        # Add elite levels
        elite_list = chapter_data.get('elite_expedition_list', [])
        for elite_id in elite_list:
            if elite_id in expedition_template:
                level = expedition_template[elite_id].get('level', 0)
                if level:
                    levels.add(level)

        # Add boss level
        boss_list = chapter_data.get('boss_expedition_id', [])
        for boss_id in boss_list:
            if boss_id in expedition_template:
                level = expedition_template[boss_id].get('level', 0)
                if level:
                    levels.add(level)

        if levels:
            sorted_levels = sorted(list(levels))
            return '/'.join(map(str, sorted_levels))
        return ''

    def _get_fleet_experience(self, chapter_data, expedition_template):
        """Get experience for different fleet types from expedition configs."""
        exp_data = {
            'small': '',
            'medium': '',
            'large': '',
            'elite': '',
            'boss': ''
        }

        # No clear mapping for small/medium/large in the data structure
        # Only elite and boss have explicit mappings

        # Get elite fleet experience
        elite_list = chapter_data.get('elite_expedition_list', [])
        if elite_list and len(elite_list) > 0 and elite_list[0] in expedition_template:
            exp_val = expedition_template[elite_list[0]].get('exp', 0)
            if exp_val:
                exp_data['elite'] = str(exp_val)

        # Get boss fleet experience
        boss_list = chapter_data.get('boss_expedition_id', [])
        if boss_list and len(boss_list) > 0 and boss_list[0] in expedition_template:
            exp_val = expedition_template[boss_list[0]].get('exp', 0)
            if exp_val:
                exp_data['boss'] = str(exp_val)

        return exp_data

    def _get_boss_level(self, chapter_data, expedition_template):
        """Get boss level."""
        boss_list = chapter_data.get('boss_expedition_id', [])
        if boss_list and boss_list[0] in expedition_template:
            return str(expedition_template[boss_list[0]].get('level', ''))
        return ''

    def _get_danger_level(self, chapter_data):
        """Get danger level from risk_levels."""
        risk_levels = chapter_data.get('risk_levels', [])
        if risk_levels and len(risk_levels) > 0 and len(risk_levels[0]) > 0:
            return str(risk_levels[0][0])
        return ''

