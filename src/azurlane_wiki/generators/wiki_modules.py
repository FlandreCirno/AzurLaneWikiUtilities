# -*- coding: utf-8 -*-
"""Wiki module generators for Lua data modules."""
import os
from .base import BaseGenerator
from ..core import parse_data_file
from ..core.name_resolver import parse_name_code, get_name_code


class WikiModulesGenerator(BaseGenerator):
    """Generator for wiki Lua data modules (模块:舰娘数据 and 模块:装备数据)."""

    def generate(self):
        """Generate both ship data and equipment data modules."""
        self.generate_ship_data_module()
        self.generate_equipment_data_module()

    # Ship name corrections: game data name → wiki name (human decision, reason not tracked).
    _SHIP_NAME_CORRECTIONS = {
        '三浦 梓':             '三浦梓',
        '八舞耶俱矢·八舞夕弦': '八舞耶倶矢·八舞夕弦',
        '莲':                 '莲SSSS',
        '貉':                 '貉SSSS',
        '马可波罗':            '马可·波罗',
    }

    def generate_ship_data_module(self):
        """Generate 模块:舰娘数据 (Ship Data Module).

        Only generates the p.ship_data table. Other lookup tables and functions
        should be maintained manually in the wiki.
        """
        # Load required data
        ship_statistics = parse_data_file('ship_data_statistics', config=self.config)
        ship_data_template = parse_data_file('ship_data_template', config=self.config)

        # Load retrofit data to check which ships can transform
        # The keys in ship_data_trans are the group_type IDs that can retrofit
        try:
            ship_data_trans = parse_data_file('ship_data_trans', config=self.config)
            transform_groups = set(ship_data_trans.keys())
        except:
            transform_groups = set()

        # Find the minimum star level for each group_type (base form)
        # Most ships start at star=2, some at star=1, 3, 4, etc.
        # Note: Ships with star=0 and group=0 are breakout stages or special variants
        # and should be excluded by filtering for ships with group_type > 0
        group_min_star = {}
        for template_id, template_info in ship_data_template.items():
            group_type = template_info.get('group_type', 0)
            star = template_info.get('star', 0)

            # Filter out non-base ships (breakout stages, special variants)
            # These have group_type=0 or star=0
            if group_type == 0:
                continue

            if group_type not in group_min_star or star < group_min_star[group_type]['star']:
                group_min_star[group_type] = {
                    'star': star,
                    'id': template_info.get('id', 0)
                }

        # Build ship_data table using the base form (minimum star) for each group
        # First pass: collect all ships and detect duplicates
        ship_data_temp = {}
        name_counts = {}
        for group_type, info in group_min_star.items():
            ship_id = info['id']
            if ship_id == 0:
                continue

            # Get ship stats from statistics (keys are integers)
            ship_info = ship_statistics.get(ship_id, {})
            name = ship_info.get('name', '').strip()
            name = self._SHIP_NAME_CORRECTIONS.get(name, name)
            if not name:
                continue

            entry = {
                'id': ship_id,
                'nationality': ship_info.get('nationality', 0),
                'type': ship_info.get('type', 0),
                'rarity': ship_info.get('rarity', 0),
                'name': name,
                'group_type': group_type
            }

            # Add transform flag if ship's group can retrofit
            if group_type in transform_groups:
                entry['transform'] = True

            # Track duplicate names
            if name not in ship_data_temp:
                ship_data_temp[name] = []
                name_counts[name] = 0
            ship_data_temp[name].append(entry)
            name_counts[name] += 1

        # Second pass: handle specific duplicate cases with custom suffixes
        ship_data = {}

        for name, entries in ship_data_temp.items():
            if name_counts[name] > 1:
                # Handle specific known duplicate cases with hardcoded logic
                # Wiki convention: Keep main variant without suffix, only suffix alternates
                for entry in entries:
                    # Specific case: 加贺 (Kaga)
                    # Main: 加贺 (ID 307021, CV), Alternate: 加贺BB (ID 305071, BB)
                    if name == "加贺":
                        if entry['id'] == 307021:  # CV - main variant
                            unique_name = "加贺"
                        elif entry['id'] == 305071:  # BB - alternate variant
                            unique_name = "加贺BB"
                        else:
                            unique_name = name

                    # Specific case: 天城 (Amagi)
                    # Main: 天城 (ID 304051, BC), Alternate: 天城CV (ID 307151, CV)
                    elif name == "天城":
                        if entry['id'] == 304051:  # BC - main variant
                            unique_name = "天城"
                        elif entry['id'] == 307151:  # CV - alternate variant
                            unique_name = "天城CV"
                        else:
                            unique_name = name

                    # Specific case: 霞 (Kasumi)
                    # Main: 霞 (ID 301811, DD), Alternate: 霞DOA (ID 10600031, CA)
                    elif name == "霞":
                        if entry['id'] == 301811:  # DD - main variant
                            unique_name = "霞"
                        elif entry['id'] == 10600031:  # CA DOA - alternate variant
                            unique_name = "霞DOA"
                        else:
                            unique_name = name

                    # Specific case: 新月 (Crescent/Mikazuki)
                    # Main: 新月 (ID 201091, Royal Navy), Alternate: 新月JP (ID 301561, Sakura)
                    elif name == "新月":
                        if entry['id'] == 201091:  # Royal Navy - main variant
                            unique_name = "新月"
                        elif entry['id'] == 301561:  # Sakura Empire - alternate variant
                            unique_name = "新月JP"
                        else:
                            unique_name = name

                    # Specific case: 约克 (York/Yorck)
                    # Main: 约克 (ID 203071, Royal Navy York), Alternate: 约克DE (ID 403111, Iron Blood Yorck)
                    elif name == "约克":
                        if entry['id'] == 203071:  # Royal Navy York - main variant
                            unique_name = "约克"
                        elif entry['id'] == 403111:  # Iron Blood Yorck - alternate variant
                            unique_name = "约克DE"
                        else:
                            unique_name = name

                    else:
                        # Unknown duplicate - keep original name (shouldn't happen)
                        unique_name = name

                    ship_data[unique_name] = {
                        'id': entry['id'],
                        'nationality': entry['nationality'],
                        'type': entry['type'],
                        'rarity': entry['rarity']
                    }
                    if entry.get('transform'):
                        ship_data[unique_name]['transform'] = True
            else:
                # No duplicate - use original name
                entry = entries[0]
                ship_data[name] = {
                    'id': entry['id'],
                    'nationality': entry['nationality'],
                    'type': entry['type'],
                    'rarity': entry['rarity']
                }
                if entry.get('transform'):
                    ship_data[name]['transform'] = True

        # Generate Lua output - only the ship_data table
        output_path = os.path.join(self.config.output_directory, '模块_舰娘数据.lua')
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write('local p = {}\n\n')
            f.write('p.ship_data = {\n')
            for name, entry in sorted(ship_data.items(), key=lambda x: x[1]['id']):
                f.write(f'\t["{name}"] = {{ ')
                f.write(f'id = {entry["id"]}, ')
                f.write(f'nationality = {entry["nationality"]}, ')
                f.write(f'type = {entry["type"]}, ')
                f.write(f'rarity = {entry["rarity"]}')
                if entry.get('transform'):
                    f.write(', transform = true')
                f.write(' },\n')
            f.write('}\n\n')
            f.write('return p\n')

        print(f"  Generated: {output_path}")

    def _generate_ship_data_module_with_lookups(self):
        """Legacy version with lookup tables - keeping for reference."""
        nation_data = {
            1: '白鹰',
            2: '皇家',
            3: '重樱',
            4: '铁血',
            5: '东煌',
            6: '撒丁帝国',
            7: '北方联合',
            8: '自由鸢尾',
            9: '维希教廷',
            11: '郁金王国',
            10: '其他',
            91: 'μ兵装',
            96: '飓风',
            97: 'META',
            101: '超次元游戏海王星',
            102: '哔哩哔哩',
            103: '传颂之物',
            104: '绊爱',
            106: '死或生沙滩排球',
            107: '偶像大师',
            108: 'SSSS',
            109: '莱莎的炼金工房',
            110: '闪乱神乐',
            111: '出包王女',
            112: '黑岩射手',
            113: '优米雅的炼金工房',
            114: '地城邂逅',
            115: '约会大作战V',
        }

        nation_prints = {
            1: "us",
            2: "en",
            3: "jp",
            4: "de",
            5: "cn",
            6: "it",
            7: "sn",
            8: "ff",
            9: "vf",
            11: "nl",
            10: "cm",
            91: "mu",
            96: "tp",
            97: "ash",
            101: "hdn",
            102: "BILI",
            103: "uwm",
            104: 'kizuna',
            106: "doa",
            107: "imas",
            108: "ssss",
            109: "Ryza",
            110: "senran",
            111: "ToLOVE",
            112: "BRS",
            113: "Yumia",
            114: "DanMachi",
            115: "DateALiveV",
        }

        type_data = {
            1: "驱逐",
            2: "轻巡",
            3: "重巡",
            4: "战巡",
            5: "战列",
            6: "轻航",
            7: "航母",
            8: "潜艇",
            9: "航巡",
            10: "航战",
            11: "雷巡",
            12: "维修",
            13: "重炮",
            17: "潜母",
            18: "超巡",
            19: "运输",
            20: "导驱",
            22: "风帆S",
            23: "风帆V",
            24: "风帆M",
            201: "第一期",
            202: "第二期",
            203: "第三期",
            301: "META",
        }

        type_sort = {
            1: 1, 2: 2, 3: 3, 4: 18, 5: 4, 6: 5, 7: 10,
            8: 6, 9: 7, 10: 8, 11: 17, 12: 9, 13: 11,
            14: 12, 15: 13, 16: 19, 17: 22, 18: 23,
            19: 24, 20: 201, 21: 202, 22: 203, 23: 301,
        }

        nation_sort = {
            1: 1, 2: 2, 3: 3, 4: 4, 5: 5, 6: 6, 7: 7,
            8: 8, 9: 9, 10: 11, 11: 10, 12: 91, 13: 96,
            14: 97, 15: 101, 16: 102, 17: 103, 18: 104,
            19: 106, 20: 107, 21: 108, 22: 109, 23: 113,
            24: 110, 25: 111, 26: 112, 27: 114, 28: 115,
        }


    def generate_equipment_data_module(self):
        """Generate 模块:装备数据 (Equipment Data Module).

        Only generates the p.equip_data table. Filters out:
        1. Equipment not in equip_data_template (story/test equipment)
           - Equipment that exists in equip_data_statistics but not in equip_data_template
             are story-only or test items that players cannot obtain

        Other lookup tables and functions should be maintained manually in the wiki.
        """
        # Load required data
        equip_statistics = parse_data_file('equip_data_statistics', config=self.config)
        equip_template = parse_data_file('equip_data_template', config=self.config)

        # Load special weapons (augment modules / 设备)
        try:
            spweapon_statistics = parse_data_file('spweapon_data_statistics', config=self.config)
        except:
            spweapon_statistics = {}

        # First pass: collect all equipment and group by base name + nationality
        equip_temp = {}  # Key: (base_name, nationality)
        base_name_nations = {}  # Track nations for each base name
        filtered_count = 0

        for equip_id, equip_info in equip_statistics.items():
            name = equip_info.get('name', '').strip()  # Trim spaces
            if not name:
                continue

            # Filter: Equipment not in template (story/test equipment)
            template_info = equip_template.get(equip_id, None)
            if template_info is None:
                filtered_count += 1
                continue

            # Get equipment properties
            base_id = template_info.get('base', 0)
            if base_id == 0:
                base_id = int(equip_id)

            tech_level = equip_info.get('tech', 0)
            nationality = equip_info.get('nationality', 0)
            equip_type = equip_info.get('type', 0)
            rarity = equip_info.get('rarity', 0)

            # Strip tech suffix from name
            base_name = name
            for suffix in ['T3', 'T2', 'T1', 'T0']:
                if name.endswith(suffix):
                    base_name = name[:-2]
                    break

            # Track nations for this base name
            if base_name not in base_name_nations:
                base_name_nations[base_name] = set()
            base_name_nations[base_name].add(nationality)

            # Group by base name + nationality
            key = (base_name, nationality)
            if key not in equip_temp:
                equip_temp[key] = {
                    'id': base_id,
                    'name': base_name,
                    'type': equip_type,
                    'nationality': nationality,
                    'sub_equips': []
                }

            equip_temp[key]['sub_equips'].append({
                'tech': tech_level,
                'rarity': rarity,
                'id': int(equip_id)
            })

        # Second pass: add nation suffix for equipment with multiple regional variants
        equip_data_map = {}
        nation_suffix_map = {
            1: '白鹰', 2: '皇家', 3: '重樱', 4: '铁血', 5: '东煌',
            6: '撒丁', 7: '北联', 8: '自由鸢尾', 9: '维希', 10: '其他',
            11: '郁金香', 91: 'μ兵装', 96: '飓风', 97: 'META',
            101: '海王星', 102: '哔哩', 103: '传颂', 104: '绊爱',
            106: 'DOA', 107: '偶像', 108: 'SSSS', 109: '莱莎',
            110: '闪乱', 111: '出包', 112: '黑岩', 113: '优米雅',
            114: '地错', 115: '狂三',
        }

        for (base_name, nationality), equip_data in equip_temp.items():
            # Check if this equipment has multiple national variants
            if len(base_name_nations[base_name]) > 1:
                # Add nation suffix for regional variants
                nation_suffix = nation_suffix_map.get(nationality, f"N{nationality}")
                final_name = f"{base_name}({nation_suffix})"
            else:
                # No regional variants - use base name
                final_name = base_name

            # Update the name in equip_data
            equip_data['name'] = final_name
            equip_data_map[final_name] = equip_data

        # Sort sub_equips by tech level
        for equip in equip_data_map.values():
            equip['sub_equips'].sort(key=lambda x: x['tech'])

        # Third pass: add augment modules (special weapons / 设备)
        augment_count = 0
        name_code = get_name_code(config=self.config)  # Load name code dictionary once

        for weapon_id, weapon_info in spweapon_statistics.items():
            name = weapon_info.get('name', '').strip()
            if not name:
                continue

            # Parse name codes (e.g., {namecode:33} -> ship name)
            name = parse_name_code(name, name_code)

            weapon_type = weapon_info.get('type', 0)
            rarity = weapon_info.get('rarity', 5)  # Default to gold rarity

            # Add as equipment with single tech level (augments don't have T1/T2/T3)
            equip_data_map[name] = {
                'id': int(weapon_id),
                'name': name,
                'type': weapon_type,
                'nationality': 0,  # Augments don't have nationality
                'sub_equips': [{
                    'tech': 0,  # Augments don't have tech levels
                    'rarity': rarity,
                    'id': int(weapon_id)
                }]
            }
            augment_count += 1

        # Fourth pass: Apply name mapping to match wiki conventions
        equipment_name_mapping = {
            # Formatting fixes (parentheses, capitalization, spacing)
            '20mm厄利孔高射炮MkII': '20mm厄利孔高射炮Mark II',
            '533mm磁性鱼雷（水面舰艇用）': '533mm磁性鱼雷',
            '533mm鱼雷Mark35（4连发射）': '533mm鱼雷Mk35(4连发射)',
            '<封解主（Michael）>': '封解主（Michael）',
            'B-37 三联装406mm主炮Mk-1': 'B-37 三联装406mm主炮MK-1',
            'B-38 三联装152mm主炮Mk5': 'B-38 三联装152mm主炮MK-5',
            'B-50 三联装305mm主炮Mk-15': 'B-50 三联装305mm主炮MK-15',
            'F4U（VF-17“海盗”中队）': 'F4U(VF-17“海盗”中队)',
            'F6F地狱猫（HVAR搭载型）': 'F6F地狱猫(HVAR搭载型)',
            'tunken der Liebe': 'Tunken der Liebe',
            '三五式“柚”对舰强击械装': '三五式“绫波”对舰强击械装',
            '兵装补给（中小口径武器）': '兵装补给(中小口径武器)',
            '兵装补给（航空）': '兵装补给(航空)',
            '兵装补给（鱼雷）': '兵装补给(鱼雷)',
            '双管20mm厄利孔高射炮Mk.V': '双管20mm厄利孔高射炮Mark V',
            '双联装57mm/L60博福斯对空机炮Mle1951': '双联装57mmL/60博福斯对空机炮Mle1951',
            '女王的日程表（绝密）': '女王的日程表(绝密)',
            '试作型VIT-2 (VK-107)': '试作型VIT-2(VK-107)',
            '试作型三联装305mmSKC39主炮（超巡用）': '试作型三联装305mmSKC39主炮(超巡用)',
            '试作型双联装457mm主炮Mk A': '试作型双联装457mm主炮MkA',
            '试作型四联装330mm主炮Mle1931（超巡用）': '试作型四联装330mm主炮Mle1931(超巡用)',
            '试作型彩云（舰攻型）': '试作型彩云(舰攻型)',
            '试作型舰载FW-190 A-5': '试作舰载型FW-190 A-5',
            # Fix mismatched quotes (data has two left quotes, wiki has left+right)
            '“个性“装备': '“个性”装备',
        }

        # Apply name mapping
        equip_data_map_renamed = {}

        # Aircraft that need displayname field (base name) in addition to suffixed name
        aircraft_suffix_map = {
            '飞龙': '飞龙(鱼雷机)',
            '萤火虫': '萤火虫(轰炸机)',
            '彗星': '彗星(轰炸机)',
        }

        for old_name, equip_data in equip_data_map.items():
            # Check if this is an aircraft that needs displayname
            if old_name in aircraft_suffix_map:
                suffix_name = aircraft_suffix_map[old_name]
                equip_data['name'] = suffix_name
                equip_data['displayname'] = old_name  # Base name for display
                equip_data_map_renamed[suffix_name] = equip_data
                continue

            # Apply regular name mapping
            new_name = equipment_name_mapping.get(old_name, old_name)
            equip_data['name'] = new_name
            equip_data_map_renamed[new_name] = equip_data

        equip_data_map = equip_data_map_renamed

        # Generate Lua output - only the equip_data table
        output_path = os.path.join(self.config.output_directory, '模块_装备数据.lua')
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write('local p = {}\n\n')
            f.write('p.equip_data = {\n')
            for equip in sorted(equip_data_map.values(), key=lambda x: x['id']):
                f.write('{\n')
                f.write(f'\tid = {equip["id"]},\n')
                f.write(f'\tname = "{equip["name"]}",\n')
                # Add displayname if present (for aircraft with ship name conflicts)
                if 'displayname' in equip:
                    f.write(f'\tdisplayname= "{equip["displayname"]}",\n')
                f.write(f'\ttype = {equip["type"]},\n')
                f.write(f'\tnationality = {equip["nationality"]},\n')
                f.write('\tsub_equips = {\n')
                for sub in equip['sub_equips']:
                    f.write(f'\t\t{{\ttech = {sub["tech"]}, rarity = {sub["rarity"]}, id = {sub["id"]}\t}};\n')
                f.write('\t}\n')
                f.write('};\n')
            f.write('}\n\n')
            f.write('return p\n')

        print(f"  Generated: {output_path}")
        print(f"  Regular equipment: {len(equip_data_map) - augment_count}")
        print(f"  Augment modules: {augment_count}")
        print(f"  Total equipment: {len(equip_data_map)}")
        print(f"  Story/test filtered: {filtered_count}")
