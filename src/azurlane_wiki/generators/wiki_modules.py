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

    # μ兵装 trailing-space entries: hardcoded mapping of (ship_id, mu_period)
    # These entries reference the base μ兵装 ship ID and use nationality=91 with
    # type = period (201=第一期, 202=第二期, 203=第三期)
    _MU_WEAPON_ENTRIES = [
        # 第一期 (type=201)
        (905031, 201),  # 加斯科涅(μ兵装)
        (307101, 201),  # 赤城(μ兵装)
        (403071, 201),  # 希佩尔海军上将(μ兵装)
        (102241, 201),  # 克利夫兰(μ兵装)
        (202251, 201),  # 谢菲尔德(μ兵装)
        # 第二期 (type=202)
        (701051, 202),  # 塔什干(μ兵装)
        (901121, 202),  # 恶毒(μ兵装)
        (202281, 202),  # 黛朵(μ兵装)
        (103251, 202),  # 巴尔的摩(μ兵装)
        (403081, 202),  # 罗恩(μ兵装)
        (207111, 202),  # 光辉(μ兵装)
        (307111, 202),  # 大凤(μ兵装)
        (108051, 202),  # 大青花鱼(μ兵装)
        # 第三期 (type=203)
        (207141, 203),  # 可畏(μ兵装)
        (403151, 203),  # 欧根亲王(μ兵装)
        (302241, 203),  # 能代(μ兵装)
        (304081, 203),  # 金刚(μ兵装)
        (801091, 203),  # 鲁莽(μ兵装)
        (102321, 203),  # 博伊西(μ兵装)
    ]

    def generate_ship_data_module(self):
        """Generate 模块:舰娘数据 (Ship Data Module).

        Only generates the p.ship_data table. Other lookup tables and functions
        should be maintained manually in the wiki.
        """
        # Load required data
        ship_statistics = parse_data_file('ship_data_statistics', config=self.config)
        ship_data_template = parse_data_file('ship_data_template', config=self.config)
        ship_data_group = parse_data_file('ship_data_group', config=self.config)

        # Build group_type → handbook_type map from ship_data_group
        # handbook_type: 0=normal, 1=collab, 2=PR/research, 3=META
        group_type_handbook = {}
        for entry in ship_data_group.values():
            if isinstance(entry, dict):
                gt = entry.get('group_type')
                ht = entry.get('handbook_type', 0)
                if gt is not None:
                    group_type_handbook[gt] = ht

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

            nationality = ship_info.get('nationality', 0)
            ship_type = ship_info.get('type', 0)
            rarity = ship_info.get('rarity', 0)

            # Get handbook_type for this group to apply corrections
            handbook_type = group_type_handbook.get(group_type, 0)

            # Override nationality for 布里 ships (game uses 98, wiki uses 10=其他)
            if nationality == 98:
                nationality = 10

            # Override ship type for META ships to use the wiki's META type (301)
            if handbook_type == 3:  # META
                ship_type = 301

            # Add rarity offset for PR/research ships
            if handbook_type == 2:  # PR
                rarity += 10

            entry = {
                'id': ship_id,
                'nationality': nationality,
                'type': ship_type,
                'rarity': rarity,
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

        # Third pass: build μ兵装 trailing-space entries (hardcoded, nationality=91)
        # Stored separately so they appear at the end of ship_data with a comment block,
        # following the wiki's convention of placing them after all regular ships.
        mu_ship_data = []
        for ship_id, mu_period in self._MU_WEAPON_ENTRIES:
            ship_info = ship_statistics.get(ship_id, {})
            ship_name = ship_info.get('name', '')  # e.g. '加斯科涅(μ兵装)'
            if not ship_name:
                continue
            wiki_name = ship_name + ' '  # trailing space is intentional per wiki convention
            rarity = ship_info.get('rarity', 5)
            mu_ship_data.append((wiki_name, {
                'id': ship_id,
                'nationality': 91,   # μ兵装 faction
                'type': mu_period,   # 201/202/203 = 第一期/第二期/第三期
                'rarity': rarity,
            }))

        # Generate Lua output - only the ship_data table
        output_path = os.path.join(self.config.output_directory, '模块_舰娘数据.lua')
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write('local p = {}\n\n')
            f.write('p.ship_data = {\n')
            # Regular ships sorted by ID
            for name, entry in sorted(ship_data.items(), key=lambda x: x[1]['id']):
                f.write(f'\t["{name}"] = {{ ')
                f.write(f'id = {entry["id"]}, ')
                f.write(f'nationality = {entry["nationality"]}, ')
                f.write(f'type = {entry["type"]}, ')
                f.write(f'rarity = {entry["rarity"]}')
                if entry.get('transform'):
                    f.write(', transform = true')
                f.write(' },\n')
            # μ兵装 entries at the end with comment block (wiki convention)
            f.write('--\t以下为μ兵装角色新增栏目（μ兵装括号后面注意增加一个空格）\n')
            f.write('--\t["角色名(μ兵装) "] = { id = ?, nationality = 91, type = ?, rarity = ? },\n')
            for wiki_name, entry in mu_ship_data:
                f.write(f'\t["{wiki_name}"] = {{ ')
                f.write(f'id = {entry["id"]}, ')
                f.write(f'nationality = {entry["nationality"]}, ')
                f.write(f'type = {entry["type"]}, ')
                f.write(f'rarity = {entry["rarity"]}')
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

        # First pass: collect all equipment and group by (base_name, nationality, equip_type).
        # Including equip_type in the key ensures same-name equipment of different types
        # (e.g. 双联装134mm高炮 as type=1 main gun vs type=6 AA gun) remain separate entries.
        equip_temp = {}  # Key: (base_name, nationality, equip_type)
        base_name_nations = {}  # Track nations for each (base_name, equip_type)
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

            # Correct nationality for FFNF (Free French) equipment mislabeled as 其他 (10).
            # All FFNF-labeled equipment belongs to 自由鸢尾 (8); game data errors for two items.
            labels = equip_info.get('label', [])
            if 'FFNF' in labels and nationality == 10:
                nationality = 8

            # Strip tech suffix from name
            base_name = name
            for suffix in ['T3', 'T2', 'T1', 'T0']:
                if name.endswith(suffix):
                    base_name = name[:-2]
                    break

            # Track nations per (base_name, equip_type) for nation suffix detection
            bn_type_key = (base_name, equip_type)
            if bn_type_key not in base_name_nations:
                base_name_nations[bn_type_key] = set()
            base_name_nations[bn_type_key].add(nationality)

            # Group by (base_name, nationality, equip_type)
            key = (base_name, nationality, equip_type)
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

        # Second pass: add nation suffix for equipment with multiple regional variants.
        # Nation suffix is added when the same (base_name, equip_type) exists across
        # multiple nationalities (e.g. 120mm单装炮 for 皇家 and 重樱).
        # equip_data_map is keyed by id to avoid collisions when same name has different types.
        equip_data_map = {}  # Key: id
        # Nation suffix abbreviations used in equipment names when regional variants exist.
        # Verified against wiki's p.nation_data and actual equipment suffixes in 模块:装备数据.
        # France has 3 factions: 自由鸢尾(8), 维希教廷(9), 郁金王国(11).
        nation_suffix_map = {
            1: '白鹰', 2: '皇家', 3: '重樱', 4: '铁血', 5: '东煌',
            6: '撒丁', 7: '北联', 8: '自由鸢尾', 9: '维希教廷', 10: '其他',
            11: '郁金王国', 91: 'μ兵装', 96: '飓风', 97: 'META',
            101: '海王星', 102: '哔哩', 103: '传颂', 104: '绊爱',
            106: 'DOA', 107: '偶像', 108: 'SSSS', 109: '莱莎',
            110: '闪乱', 111: '出包', 112: '黑岩', 113: '优米雅',
            114: '地城', 115: '狂三',
        }

        for (base_name, nationality, equip_type), equip_data in equip_temp.items():
            # Check if this (name, type) combination has multiple national variants
            if len(base_name_nations[(base_name, equip_type)]) > 1:
                # Add nation suffix for regional variants
                nation_suffix = nation_suffix_map.get(nationality, f"N{nationality}")
                final_name = f"{base_name}({nation_suffix})"
            else:
                # No regional variants - use base name
                final_name = base_name

            # Sort sub_equips by tech level
            equip_data['sub_equips'].sort(key=lambda x: x['tech'])
            equip_data['name'] = final_name
            equip_data_map[equip_data['id']] = equip_data

        # Third pass: add augment modules and RPG weapons (special weapons / 设备)
        augment_count = 0
        rpg_count = 0
        name_code = get_name_code(config=self.config)  # Load name code dictionary once

        # RPG weapon grouping: name → {tech: (id, rarity)}
        rpg_weapons = {}

        for weapon_id, weapon_info in spweapon_statistics.items():
            name = weapon_info.get('name', '').strip()
            if not name:
                continue

            # Parse name codes (e.g., {namecode:33} -> ship name)
            name = parse_name_code(name, name_code)

            weapon_type = weapon_info.get('type', 0)
            rarity = weapon_info.get('rarity', 5)
            tech = weapon_info.get('tech', 0)
            wid = int(weapon_id)

            if wid >= 1_000_000:
                # RPG weapon: group by name, collect T1 and T2 base forms
                if name not in rpg_weapons:
                    rpg_weapons[name] = {}
                if tech not in rpg_weapons[name]:
                    rpg_weapons[name][tech] = (wid, rarity)
                else:
                    # Keep lowest ID per tech level (base form)
                    existing_id, _ = rpg_weapons[name][tech]
                    if wid < existing_id:
                        rpg_weapons[name][tech] = (wid, rarity)
            else:
                # Augment module (特殊兵装): fixed type=102, ship_type=game_type, nationality=999
                equip_data_map[wid] = {
                    'id': wid,
                    'name': name,
                    'type': 102,
                    'ship_type': weapon_type,
                    'nationality': 999,
                    'sub_equips': [{'tech': 0, 'rarity': rarity, 'id': wid}]
                }
                augment_count += 1

        # Add RPG weapons as grouped entries
        for name, tech_entries in rpg_weapons.items():
            tech_list = sorted(tech_entries.items())  # Sort by tech level (1 first, 2 second)
            base_id = tech_list[0][1][0]  # T1 base form ID (lowest tech, lowest ID)
            sub_equips = [{'tech': t, 'rarity': r, 'id': wid} for t, (wid, r) in tech_list]
            equip_data_map[base_id] = {
                'id': base_id,
                'name': name,
                'type': 101,
                'nationality': 999,
                'sub_equips': sub_equips
            }
            rpg_count += 1

        # Fourth pass: Apply name mapping and aircraft displayname corrections in-place.
        # Keys use exact game data strings (including curly quotes U+201C/U+201D where present).
        equipment_name_mapping = {
            # Formatting fixes (parentheses, capitalization, spacing)
            '20mm厄利孔高射炮MkII': '20mm厄利孔高射炮Mark II',
            '533mm磁性鱼雷（水面舰艇用）': '533mm磁性鱼雷',
            '533mm鱼雷Mark35（4连发射）': '533mm鱼雷Mk35(4连发射)',
            '<封解主（Michael）>': '封解主（Michael）',
            'B-37 三联装406mm主炮Mk-1': 'B-37 三联装406mm主炮MK-1',
            'B-38 三联装152mm主炮Mk5': 'B-38 三联装152mm主炮MK-5',
            'B-50 三联装305mm主炮Mk-15': 'B-50 三联装305mm主炮MK-15',
            # Curly quote (U+201C/U+201D) → straight quote or other fix
            'F4U（VF-17\u201c海盗\u201d中队）': 'F4U(VF-17"海盗"中队)',
            'F6F地狱猫（HVAR搭载型）': 'F6F地狱猫(HVAR搭载型)',
            'tunken der Liebe': 'Tunken der Liebe',
            # Augment name correction: game calls it 柚, wiki calls it 绫波
            '三五式\u201c柚\u201d对舰强击械装': '三五式"绫波"对舰强击械装',
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
            # Augment: data has curly quotes, wiki uses Japanese corner brackets
            '\u201c个性\u201d装备': '「个性」装备',
        }

        # Aircraft that need a type suffix in name (to avoid conflicts with ship names)
        # plus a displayname field showing the plain name
        aircraft_suffix_map = {
            '飞龙': '飞龙(鱼雷机)',
            '萤火虫': '萤火虫(轰炸机)',
            '彗星': '彗星(轰炸机)',
        }

        for equip in equip_data_map.values():
            old_name = equip['name']
            if old_name in aircraft_suffix_map:
                suffix_name = aircraft_suffix_map[old_name]
                equip['displayname'] = old_name  # Base name for display
                equip['name'] = suffix_name
                continue
            new_name = equipment_name_mapping.get(old_name, old_name)
            equip['name'] = new_name

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
                    f.write(f'\tdisplayname = "{equip["displayname"]}",\n')
                f.write(f'\ttype = {equip["type"]},\n')
                # Add ship_type for augment modules (original game type)
                if 'ship_type' in equip:
                    f.write(f'\tship_type = {equip["ship_type"]},\n')
                f.write(f'\tnationality = {equip["nationality"]},\n')
                f.write('\tsub_equips = {\n')
                for sub in equip['sub_equips']:
                    f.write(f'\t\t{{\ttech = {sub["tech"]}, rarity = {sub["rarity"]}, id = {sub["id"]}\t}};\n')
                f.write('\t}\n')
                f.write('};\n')
            f.write('}\n\n')
            f.write('return p\n')

        print(f"  Generated: {output_path}")
        print(f"  Regular equipment: {len(equip_data_map) - augment_count - rpg_count}")
        print(f"  Augment modules: {augment_count}")
        print(f"  RPG weapons: {rpg_count}")
        print(f"  Total equipment: {len(equip_data_map)}")
        print(f"  Story/test filtered: {filtered_count}")
