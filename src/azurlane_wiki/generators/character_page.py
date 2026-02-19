# -*- coding: utf-8 -*-
"""Character page stub generator."""
import os
from collections import defaultdict
from .base import BaseGenerator
from ..core import parse_data_file, get_ship_name, parse_name_code, get_name_code, ShipStatsCalculator


class CharacterPageGenerator(BaseGenerator):
    """Generator for character page stubs."""

    # Ship type mapping — game type ID → wiki type name
    # Note: game uses "正航" for type 6, wiki uses "航母"
    SHIP_TYPE_MAP = {
        1: '驱逐',
        2: '轻巡',
        3: '重巡',
        4: '战列',
        5: '轻航',
        6: '航母',   # game: 正航
        7: '潜艇',
        8: '重炮',
        9: '重巡',
        10: '航战',
        12: '维修',
        13: '潜母',
        17: '运输',
        18: '超巡',
        19: '近卫',
        20: '导驱',
        21: '导战',
        22: '风帆',
        23: '风帆',
        24: '风帆',
    }

    # Rarity mapping
    RARITY_MAP = {
        2: '普通',
        3: '稀有',
        4: '精锐',
        5: '超稀有',
        6: '海上传奇',
        'plan': '决战方案',
        'meta': '超稀有',  # META ships
    }

    # Nationality mapping
    NATIONALITY_MAP = {
        0: '通用',
        1: '白鹰',
        2: '皇家',
        3: '重樱',
        4: '铁血',
        5: '东煌',
        6: '撒丁帝国',
        7: '北方联合',
        8: '自由鸢尾',
        9: '维希教廷',
        10: '其他',
        11: '郁金王国',
        91: 'μ兵装',
        96: '飓风',
        97: 'META',
        98: '研发',
        99: '试作型',
        101: '超次元游戏海王星',
        102: '哔哩哔哩',
        103: '传颂之物',
        104: '绊爱',
        105: 'META',
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

    # Armor type mapping
    ARMOR_TYPE_MAP = {
        1: '轻型',
        2: '中型',
        3: '重型',
    }

    # Stat letter grades
    GRADE_THRESHOLDS = {
        'S': 400,
        'A': 300,
        'B': 200,
        'C': 100,
        'D': 50,
        'E': 0,
    }

    # Equipment slot type mapping
    # Maps equipment type IDs to Chinese equipment type names
    # These are fallback values; _load_equipment_type_map() overrides them from game data.
    EQUIPMENT_TYPE_MAP = {
        1: '驱逐炮',
        2: '轻巡炮',
        3: '重巡炮',
        4: '战列炮',
        5: '水面鱼雷',
        6: '防空炮',
        7: '战斗机',
        8: '鱼雷机',
        9: '轰炸机',
        10: '设备',
        11: '副炮',
        12: '水上机',
        13: '潜艇鱼雷',
        14: '设备',
        15: '反潜机',
        17: '直升机',
        18: '货物',
        20: '导弹',
        21: '防空炮',
    }

    def __init__(self, config=None):
        super().__init__(config)
        # Load ship type mapping from game data
        self._load_ship_type_map()
        # Load equipment type mapping from game data
        self._load_equipment_type_map()

    def _load_ship_type_map(self):
        """Load ship type names from ship_data_by_type.json and apply wiki terminology."""
        ship_by_type = parse_data_file('ship_data_by_type', config=self.config)

        # Mapping from game terminology to wiki terminology
        game_to_wiki = {
            '正航': '航母',  # Fleet Carrier -> Aircraft Carrier (wiki prefers this term)
        }

        for type_id, data in ship_by_type.items():
            if isinstance(data, dict) and 'type_name' in data:
                game_name = data['type_name']
                # Use wiki terminology if available, otherwise use game name
                wiki_name = game_to_wiki.get(game_name, game_name)
                self.SHIP_TYPE_MAP[type_id] = wiki_name

        # Apply wiki-specific overrides for sail ship subtypes.
        # The game uses a single name "风帆" for all three sail types, but the wiki
        # distinguishes them by hull role: S (sloop/vanguard small), V (vanguard),
        # M (main fleet).
        self.SHIP_TYPE_MAP[22] = '风帆S'
        self.SHIP_TYPE_MAP[23] = '风帆V'
        self.SHIP_TYPE_MAP[24] = '风帆M'

    def _load_equipment_type_map(self):
        """Load equipment type names from equip_data_by_type.json.

        The game data provides type_name2 with format like "舰炮(驱逐)", "舰炮(轻巡)", etc.
        We convert these to wiki terminology: "驱逐炮", "轻巡炮", etc.

        Note: Some equipment type IDs have context-dependent names (e.g., type 11
        is '副炮' for battleships but '大口径重巡炮' for super cruisers). The base
        mapping is loaded here, and context-specific overrides are applied in
        _get_equipment_info().
        """
        try:
            equip_by_type = parse_data_file('equip_data_by_type', config=self.config)

            # Mapping from game equipment category to wiki terminology
            # These are NAME MAPPINGS (terminology conversions), which are fine to hardcode
            game_to_wiki_equip = {
                '舰炮(驱逐)': '驱逐炮',
                '舰炮(轻巡)': '轻巡炮',
                '舰炮(重巡)': '重巡炮',
                '舰炮(战列)': '战列炮',
                '舰炮(大口径重巡)': '副炮',  # Type 11; super cruiser slot 1 overrides this in _get_equipment_info()
                '鱼雷': '水面鱼雷',
                '鱼雷(潜艇)': '潜艇鱼雷',
                '防空炮': '防空炮',
                '战斗机': '战斗机',
                '鱼雷机': '鱼雷机',
                '轰炸机': '轰炸机',
                '设备': '设备',
                '水上机': '水上机',
                '导弹': '导弹',
                '货物': '货物',
                '直升机': '直升机',
                '反潜机': '反潜机',
            }

            for type_id, data in equip_by_type.items():
                if isinstance(data, dict):
                    # Use type_name2 (detailed name with category)
                    type_name2 = data.get('type_name2', '')
                    type_name = data.get('type_name', '')

                    # Convert to wiki terminology
                    wiki_name = game_to_wiki_equip.get(type_name2, type_name2)
                    # If no match in type_name2, try type_name
                    if wiki_name == type_name2 and type_name:
                        wiki_name = game_to_wiki_equip.get(type_name, type_name)

                    if wiki_name:
                        # Convert string key to int
                        type_id_int = int(type_id) if isinstance(type_id, str) else type_id
                        self.EQUIPMENT_TYPE_MAP[type_id_int] = wiki_name

            # Type 6 (short-range AA) and type 21 (long-range AA) are two distinct equipment
            # categories, but wiki character pages display both as just '防空炮' to avoid
            # confusion. The game data gives both type_name='防空炮', so this is already
            # handled by the loop above, but we set it explicitly to document the intent.
            self.EQUIPMENT_TYPE_MAP[6] = '防空炮'
            self.EQUIPMENT_TYPE_MAP[21] = '防空炮'
        except Exception as e:
            # If loading fails, keep the hardcoded defaults
            print(f"Warning: Failed to load equipment types from game data: {e}")
            print("Using hardcoded EQUIPMENT_TYPE_MAP as fallback")

    def generate(self):
        """Generate character page stubs."""
        # Create output directories
        self._create_output_directories()

        # Load all required data
        print("Loading data...")
        group = self._get_ship_group()
        statistics = self._get_ship_statistics()
        template = self._get_ship_template()
        skin_template = self._get_ship_skin_template()
        strengthen = self._get_ship_strengthen()
        ship_trans = self._get_ship_trans()
        transform_template = self._get_transform_template()
        blueprint_data = self._get_ship_data_blueprint()
        blueprint_strengthen = self._get_ship_strengthen_blueprint()
        meta_strengthen = self._get_ship_strengthen_meta()
        meta_repair = self._get_ship_meta_repair()
        meta_repair_effect = self._get_ship_meta_repair_effect()
        skill_display = self._get_skill_display()
        skill_template = self._get_skill_template()
        ship_skin_words = self._get_ship_skin_words()
        fleet_tech = self._get_fleet_tech_ship_template()

        # Track ship names for duplicates
        name_counts = defaultdict(int)
        ships_by_name = defaultdict(list)

        # Process each ship group
        print("Processing ships...")
        for group_id, group_data in group.items():
            if isinstance(group_data, dict):
                code = group_data.get('code', 0)
                if code == 0 or code >= 40000:
                    continue

                # Determine ship category
                category = self._get_ship_category(code)
                if not category:
                    continue

                # Get ship info
                ship_info = self._get_ship_info(
                    code, group_id, group_data, statistics, template,
                    skin_template, strengthen, ship_trans, transform_template,
                    blueprint_data, blueprint_strengthen, meta_strengthen, meta_repair, meta_repair_effect,
                    skill_display, skill_template, ship_skin_words, fleet_tech
                )

                if ship_info:
                    name = ship_info['name']
                    name_counts[name] += 1
                    ships_by_name[name].append(ship_info)

        # Generate pages with duplicate handling
        print("Generating pages...")
        generated_count = 0
        for name, ships in ships_by_name.items():
            # Clean filename (remove retrofit indicators like .改)
            clean_name = self._clean_filename(name)

            if name_counts[name] > 1:
                # Handle duplicates - add nation suffix
                for ship_info in ships:
                    output_name = f"{clean_name}_{self._get_nation_suffix(ship_info['nationality'])}"
                    self._generate_page(ship_info, output_name)
                    generated_count += 1
            else:
                # No duplicate
                self._generate_page(ships[0], clean_name)
                generated_count += 1

        print(f"Generated {generated_count} character pages.")

    def _create_output_directories(self):
        """Create output directory structure."""
        base_dir = os.path.join(self.config.output_directory, 'character')
        os.makedirs(base_dir, exist_ok=True)
        os.makedirs(os.path.join(base_dir, '建造'), exist_ok=True)
        os.makedirs(os.path.join(base_dir, '科研'), exist_ok=True)
        os.makedirs(os.path.join(base_dir, 'Meta'), exist_ok=True)

    def _get_wiki_id(self, ship_id):
        """Get wiki ID from ship ID."""
        wiki_id = '%03d' % (ship_id % 10000)
        if ship_id < 10000:
            return wiki_id
        elif ship_id < 20000:
            return 'Collab' + wiki_id
        elif ship_id < 30000:
            return 'Plan' + wiki_id
        elif ship_id < 40000:
            return 'META' + wiki_id

    def _get_ship_category(self, code):
        """Determine ship category based on code."""
        if code < 10000:
            return '建造'
        elif 10000 <= code < 20000:
            return '建造'  # Collab ships
        elif 20000 <= code < 30000:
            return '科研'  # PR/DR ships
        elif 30000 <= code < 40000:
            return 'Meta'  # META ships
        return None

    def _get_nation_suffix(self, nationality):
        """Get nation suffix for duplicate names."""
        nation = self.NATIONALITY_MAP.get(nationality, '未知')
        suffix_map = {
            '白鹰': 'USS',
            '皇家': 'HMS',
            '重樱': 'IJN',
            '铁血': 'KMS',
            '东煌': 'ROC',
            '撒丁帝国': 'RN',
            '北方联合': 'SN',
            '自由鸢尾': 'FFNF',
            '维希教廷': 'MNF',
            '郁金王国': 'NL',
            '飓风': 'TP',
        }
        return suffix_map.get(nation, nation)

    def _clean_filename(self, name):
        """Clean ship name for use as filename.

        Removes retrofit indicators that should not be in filename.
        The full name with retrofit indicator is kept in the page content.
        """
        # Remove retrofit suffix (.改)
        if name.endswith('.改'):
            return name[:-2]
        return name

    def _get_ship_info(self, code, group_id, group_data, statistics, template,
                       skin_template, strengthen, ship_trans, transform_template,
                       blueprint_data, blueprint_strengthen, meta_strengthen, meta_repair, meta_repair_effect,
                       skill_display, skill_template, ship_skin_words, fleet_tech):
        """Extract comprehensive ship information."""
        # Load name code dictionary for parsing {namecode:123} placeholders
        name_code = get_name_code(self.config)

        # Get all breakout ship IDs
        # Filter like ship_stats.py does: temp_id // 10 == group_type
        # This ensures we only get the 4 breakout stages (0-3) for each ship
        # IMPORTANT: Do NOT use 900xxx templates! These are "simulation" templates for the
        # test drive feature and contain incorrect data (e.g., wrong equipment proficiency,
        # extra slots, etc.). Always use regular templates (e.g., 399044) and calculate
        # bonuses separately.
        ship_ids = []
        group_type = group_data['group_type']
        for temp_id, temp in template.items():
            if isinstance(temp, dict) and temp.get('group_type') == group_type:
                # Include only regular breakout templates (e.g., 399044)
                # Exclude 900xxx simulation templates
                if temp_id // 10 == group_type:
                    ship_ids.append((temp_id, temp.get('star', 0), temp.get('star_max', 0)))

        if not ship_ids:
            return None

        # Sort by star level, then by template ID to get max development template last
        ship_ids.sort(key=lambda x: (x[1], x[0]))
        initial_id = ship_ids[0][0]  # Lowest star (initial)
        max_id = ship_ids[-1][0]     # Highest star (max breakout + max development)

        # Get statistics for both initial and max
        initial_stat_key = str(initial_id) if str(initial_id) in statistics else initial_id
        max_stat_key = str(max_id) if str(max_id) in statistics else max_id

        if initial_stat_key not in statistics or max_stat_key not in statistics:
            return None

        initial_stat = statistics[initial_stat_key]
        max_stat = statistics[max_stat_key]

        initial_temp = template[initial_id] if initial_id in template else template[str(initial_id)]
        max_temp = template[max_id] if max_id in template else template[str(max_id)]

        # Get ship name (pass None to let function auto-detect group from skin)
        name = get_ship_name(max_stat.get('skin_id', max_id), skin_template, statistics, group_id=None)
        if not name:
            name = max_stat.get('name', '未知')

        # Parse namecode in ship name (for ships like "{namecode:198}")
        name = parse_name_code(name, name_code, af=False)

        # Calculate stats
        wiki_id = self._get_wiki_id(code)
        category = self._get_ship_category(code)

        # Get initial stats (level 1, initial breakout)
        initial_attrs = initial_stat.get('attrs', [0] * 12)
        initial_stats = initial_attrs[:12]

        # Get max stats using full calculation (level 125, max breakout, with bonuses)
        # Note: blueprint_data is indexed by group_type, not group_id
        group_type = group_data.get('group_type', group_id)
        max_stats = self._calculate_max_level_stats(
            max_stat, max_temp, strengthen, category, code, group_type,
            blueprint_data, blueprint_strengthen, meta_strengthen, meta_repair, meta_repair_effect
        )

        # Get skills (with namecode parsing)
        skills = self._get_ship_skills(max_temp, skill_template, name_code)

        # Get ship type (hull type) for special equipment handling
        ship_hull_type = max_stat.get('type', 0)

        # Calculate PR equipment proficiency bonuses for PR/DR ships
        pr_prof_bonuses = None
        if category == '科研':  # PR/DR ships
            # Get equipment types for each slot (not actually used by the bonus calculation,
            # but kept for API compatibility)
            equip_types = []
            for i in range(1, 4):
                equip_field = f'equip_{i}'
                equip_types.append(max_temp.get(equip_field, []))

            # Calculate development bonuses
            pr_prof_bonuses = ShipStatsCalculator.get_pr_equipment_proficiency_bonus(
                group_type, blueprint_data, blueprint_strengthen, equip_types, max_dev_level=30
            )

        # Get equipment info
        equipment = self._get_equipment_info(initial_temp, initial_stat, max_temp, max_stat, pr_prof_bonuses, ship_hull_type)

        # Get enhancement/strengthen info
        enhancement = self._get_enhancement_info(max_temp, strengthen)

        # Get oil consumption
        oil_consumption = self._get_oil_consumption(initial_temp, max_temp)

        # Get dialogues (with namecode parsing)
        dialogues = self._get_ship_dialogues(max_stat, ship_skin_words, name_code)

        # Get all skin dialogues (换装台词)
        # Use group_type (e.g., 10117) not group_id (e.g., 1) - skins use group_type as ship_group
        ship_group = group_data.get('group_type', group_id)
        skin_dialogues = self._get_all_skin_dialogues(ship_group, skin_template, ship_skin_words, name_code)

        # Get easter egg dialogues (彩蛋台词)
        easter_eggs = self._get_easter_egg_dialogues(max_stat, ship_skin_words, name_code)

        # Determine if has retrofit
        has_retrofit = group_id in ship_trans and ship_trans[group_id].get('transform_list')

        # Get META repair bonuses for META ships
        meta_bonuses = None
        if category == 'Meta':
            strengthen_id = max_temp.get('strengthen_id', 0)
            meta_bonuses = self._get_meta_repair_bonuses(
                strengthen_id, meta_strengthen, meta_repair, meta_repair_effect
            )

        # Get PR max luck for PR/DR ships
        pr_max_luck = None
        if category == '科研':  # PR/DR ships
            pr_max_luck = ShipStatsCalculator.get_pr_max_luck(
                group_type, blueprint_data, blueprint_strengthen
            )

        # Convert property_hexagon from game order to wiki order
        # Game order: [炮击, 雷击, 航空, 机动, 防空, 耐久]
        # Wiki order: [耐久, 防空, 机动, 航空, 雷击, 炮击]
        game_hexagon = group_data.get('property_hexagon', ['E'] * 6)
        wiki_hexagon = [
            game_hexagon[5] if len(game_hexagon) > 5 else 'E',  # 耐久
            game_hexagon[4] if len(game_hexagon) > 4 else 'E',  # 防空
            game_hexagon[3] if len(game_hexagon) > 3 else 'E',  # 机动
            game_hexagon[2] if len(game_hexagon) > 2 else 'E',  # 航空
            game_hexagon[1] if len(game_hexagon) > 1 else 'E',  # 雷击
            game_hexagon[0] if len(game_hexagon) > 0 else 'E',  # 炮击
        ]

        # Get tech points from fleet_tech_ship_template
        # Tech points are indexed by group_type
        tech_points = {'get': 0, 'upgrade': 0, 'level': 0}
        if group_type in fleet_tech or str(group_type) in fleet_tech:
            tech_key = group_type if group_type in fleet_tech else str(group_type)
            tech_data = fleet_tech[tech_key]
            tech_points = {
                'get': tech_data.get('pt_get', 0),
                'upgrade': tech_data.get('pt_upgrage', 0),  # Note: game data has typo "upgrage"
                'level': tech_data.get('pt_level', 0)
            }

        return {
            'code': code,
            'wiki_id': wiki_id,
            'name': name,
            'english_name': max_stat.get('english_name', ''),
            'category': category,
            'ship_type': self._get_ship_type(group_data),
            'rarity': self._get_rarity(category, max_stat, blueprint_data, group_id),
            'nationality': group_data.get('nationality', 0),
            'armor_type': self.ARMOR_TYPE_MAP.get(max_stat.get('armor_type', 1), '未知'),
            'initial_stats': initial_stats,
            'max_stats': max_stats,
            'property_hexagon': wiki_hexagon,
            'skills': skills,
            'equipment': equipment,
            'enhancement': enhancement,
            'meta_bonuses': meta_bonuses,  # META repair bonuses (None for non-META ships)
            'pr_max_luck': pr_max_luck,  # PR max luck bonus (None for non-PR ships)
            'oil_consumption': oil_consumption,
            'dialogues': dialogues,
            'skin_dialogues': skin_dialogues,
            'easter_eggs': easter_eggs,
            'has_retrofit': has_retrofit,
            'star_max': max_temp.get('star_max', 0),
            'tech_points': tech_points,  # Tech points from fleet_tech_ship_template
        }

    def _get_ship_type(self, group_data):
        """Get ship type from ship_data_by_type mapping.

        The correct ship type names are loaded from ship_data_by_type.json
        which provides the canonical type names for all ship types.
        """
        ship_type = group_data.get('type', 0)
        return self.SHIP_TYPE_MAP.get(ship_type, '未知')

    def _get_rarity(self, category, stat, blueprint_data, group_id):
        """Get ship rarity."""
        if category == '科研':
            return '决战方案'
        elif category == 'Meta':
            return '超稀有'
        else:
            # Get rarity from statistics data
            rarity = stat.get('rarity', 2)
            return self.RARITY_MAP.get(rarity, '普通')

    def _calculate_max_level_stats(self, stat, template, strengthen, category, code, group_id,
                                   blueprint_data, blueprint_strengthen, meta_strengthen, meta_repair, meta_repair_effect):
        """Calculate max level stats (level 125, with bonuses).

        Uses the same logic as ship_stats.py to apply development/repair bonuses.

        Note: For PR ships using 900xxx template IDs, the development bonuses are already
        baked into the template stats, so we should NOT apply them again.
        """
        # Build base PN array from statistics
        attrs = stat.get('attrs', [0] * 12)
        attrs_growth = stat.get('attrs_growth', [0] * 12)
        attrs_growth_extra = stat.get('attrs_growth_extra', [0] * 12)

        # Get strengthen values
        strengthen_id = template.get('strengthen_id', 0)
        strengthen_values = None
        if strengthen_id in strengthen:
            strengthen_values = strengthen[strengthen_id].get('durability', [0] * 5)

        # Build PN array using calculator
        pn = ShipStatsCalculator.build_pn_array(
            attrs, attrs_growth, attrs_growth_extra,
            strengthen_values=strengthen_values,
            oil_at_start=template.get('oil_at_start', 0),
            oil_at_end=template.get('oil_at_end', 0)
        )

        # Determine ship category
        is_pr = 20000 <= code < 30000
        is_meta = 30000 <= code < 40000

        # Apply category-specific bonuses
        if is_pr:
            # PR/DR ships: Apply development bonuses
            pn = ShipStatsCalculator.apply_pr_development_bonus(
                pn, group_id, blueprint_data, blueprint_strengthen, breakout=3
            )
            # Calculate with strengthen=False since development bonuses replace it
            stats = ShipStatsCalculator.calculate_stats(
                pn, strengthen=False, level=125, intimacy=1.06, remould=False, is_meta=False
            )
        elif is_meta:
            # META ships: Apply repair bonuses
            pn = ShipStatsCalculator.apply_meta_repair_bonus(
                pn, strengthen_id, meta_strengthen, meta_repair, meta_repair_effect
            )
            # Calculate with strengthen=True and is_meta=True
            stats = ShipStatsCalculator.calculate_stats(
                pn, strengthen=True, level=125, intimacy=1.06, remould=False, is_meta=True
            )
        else:
            # Normal ships: Use regular strengthening
            stats = ShipStatsCalculator.calculate_stats(
                pn, strengthen=True, level=125, intimacy=1.06, remould=False, is_meta=False
            )

        # Return first 12 stats (durability through antisub)
        # Use int() for truncation to match wiki calculations
        return [int(s) for s in stats[:12]]

    def _get_ship_skills(self, template, skill_template, name_code):
        """Get ship skill information.

        Returns list of dicts with:
        - name: Skill name (extracted from skill_data_template, namecodes parsed to {{AF|name}})
        - desc: Skill description (extracted from skill_data_template, namecodes parsed to {{AF|name}})

        For barrage skills (全弹发射/专属弹幕), merges level I and II into wiki format:
        - Name: "全弹发射" (without level suffix)
        - Desc: "主炮每进行15（10）次攻击，触发全弹发射-XXI（II）"
        """
        # Get skill IDs from buff_list_display
        buff_list_display = template.get('buff_list_display', [])

        skills = []
        for skill_id in buff_list_display:
            # Look up skill in skill_data_template (use integer key)
            if skill_id in skill_template:
                skill_info = skill_template[skill_id]
                skill_name = skill_info.get('name', '')
                skill_desc = skill_info.get('desc', '')

                # Replace skill parameter placeholders ($1, $2, etc.) with actual values
                skill_desc = self._replace_skill_parameters(skill_desc, skill_info)

                # Check if this is a barrage skill ending with Roman numeral (I, II, III, etc.)
                if skill_name.endswith('II') or skill_name.endswith('I'):
                    # Try to merge with level I version for wiki format
                    merged_name, merged_desc = self._merge_barrage_skill_levels(
                        skill_id, skill_name, skill_desc, skill_template
                    )
                    skill_name = merged_name
                    skill_desc = merged_desc

                # Parse namecodes in skill name and description to {{AF|name}} format
                skill_name = parse_name_code(skill_name, name_code, af=True)
                skill_desc = parse_name_code(skill_desc, name_code, af=True)

                skills.append({
                    'name': skill_name,
                    'desc': skill_desc,
                })
            else:
                # Skill not found, add placeholder
                skills.append({
                    'name': '',
                    'desc': '',
                })

        return skills

    def _replace_skill_parameters(self, skill_desc, skill_info):
        """Replace skill parameter placeholders ($1, $2, etc.) with actual values.

        Args:
            skill_desc: Skill description with placeholders (e.g., "炮击有5%概率发动,8秒内自身机动提升$1")
            skill_info: Full skill data from skill_data_template

        Returns:
            Skill description with parameters replaced in wiki format (e.g., "...提升15.0%(30.0%)")
        """
        # Get parameter values from desc_get_add (preferred) or desc_add
        desc_get_add = skill_info.get('desc_get_add', [])

        if not desc_get_add:
            # Fall back to desc_add if desc_get_add is empty
            desc_get_add = skill_info.get('desc_add', [])

        if not desc_get_add:
            # No parameters to replace
            return skill_desc

        # Replace each $N placeholder with the corresponding parameter value
        for param_index, param_values in enumerate(desc_get_add):
            placeholder = f'${param_index + 1}'

            if placeholder in skill_desc and param_values:
                # Ensure param_values is a list
                if not isinstance(param_values, list):
                    param_values = [param_values]

                # Handle nested arrays (desc_add format): extract first element from each sub-array
                if len(param_values) > 0 and isinstance(param_values[0], list):
                    # desc_add format: [[base1, increment], [base2, increment], ...]
                    # Extract the first element (base value) from the first and last arrays
                    min_val = str(param_values[0][0]) if len(param_values[0]) > 0 else ''
                    max_val = str(param_values[-1][0]) if len(param_values[-1]) > 0 else min_val
                else:
                    # desc_get_add format: ['15.0%', '30.0%'] for [level 1, level 10]
                    if len(param_values) >= 2:
                        min_val = str(param_values[0])
                        max_val = str(param_values[1])
                    elif len(param_values) == 1:
                        min_val = max_val = str(param_values[0])
                    else:
                        # Empty parameter, skip replacement
                        continue

                # Format: min_value(max_value) for wiki display
                # Wiki format: "15.0%(30.0%)" or just "30.0%" if same
                if min_val == max_val:
                    replacement = max_val
                else:
                    replacement = f'{min_val}({max_val})'

                # Replace the placeholder
                skill_desc = skill_desc.replace(placeholder, replacement)

        return skill_desc

    def _merge_barrage_skill_levels(self, skill_id, name_max, desc_max, skill_template):
        """Merge barrage skill level I and II into wiki format.

        Args:
            skill_id: Skill ID (assumed to be max level)
            name_max: Skill name at max level (e.g., "全弹发射II" or "专属弹幕-Z1II")
            desc_max: Skill description at max level
            skill_template: Full skill template data

        Returns:
            tuple: (merged_name, merged_desc) in wiki format
        """
        import re

        # Extract level suffix (I, II, III, etc.) at the end
        level_match = re.search(r'([IVX]+)$', name_max)
        if not level_match:
            return name_max, desc_max

        level_suffix = level_match.group(1)
        base_name = name_max[:-len(level_suffix)]  # Remove level suffix

        # Only process barrage skills (全弹发射 or 专属弹幕)
        if not (base_name == '全弹发射' or base_name.startswith('专属弹幕')):
            return name_max, desc_max

        # Try to find level I version (usually skill_id - 1)
        skill_id_min = skill_id - 1
        if skill_id_min not in skill_template:
            # No level I found, return as-is
            return name_max, desc_max

        skill_info_min = skill_template[skill_id_min]
        name_min = skill_info_min.get('name', '')
        desc_min = skill_info_min.get('desc', '')

        # Verify it's the level I version
        if not name_min.endswith('I') or not name_min.startswith(base_name):
            return name_max, desc_max

        # Merge the descriptions
        # Pattern: "主炮每进行15次攻击" (level I) + "主炮每进行10次攻击" (level II)
        # Result: "主炮每进行15（10）次攻击"

        # Extract trigger count from descriptions
        count_match_min = re.search(r'(\d+)次攻击', desc_min)
        count_match_max = re.search(r'(\d+)次攻击', desc_max)

        if count_match_min and count_match_max:
            count_min = count_match_min.group(1)
            count_max = count_match_max.group(1)
            # Replace max level count with combined format
            merged_desc = desc_max.replace(
                f'{count_max}次攻击',
                f'{count_min}（{count_max}）次攻击'
            )
        else:
            merged_desc = desc_max

        # Merge barrage names in description (e.g., "XXI" + "XXII" -> "XXI（II）")
        # Pattern: "全弹发射-法拉格特级II" -> "全弹发射-法拉格特级I（II）"
        merged_desc = re.sub(r'([IVX]+)$', r'I（\1）', merged_desc)

        return base_name, merged_desc

    def _get_easter_egg_dialogues(self, stat, ship_skin_words, name_code):
        """Get easter egg dialogues (彩蛋台词) for the ship.

        Returns list of dicts with trigger_groups (list), count, type, and dialogue text.
        Format: {{#invoke:彩蛋台词|解析|<group1>|<group2>|...|<count>|<type>}}<dialogue_text>
        """
        skin_id = stat.get('skin_id', 0)

        if skin_id not in ship_skin_words:
            return []

        dialogue_data = ship_skin_words[skin_id]

        if 'couple_encourage' not in dialogue_data or not dialogue_data['couple_encourage']:
            return []

        easter_eggs = []
        for easter_egg_data in dialogue_data['couple_encourage']:
            # Structure: [[trigger_group_ids], count, dialogue_text, type]
            if len(easter_egg_data) >= 4:
                trigger_groups = easter_egg_data[0]  # List of ship group IDs
                count = easter_egg_data[1]
                dialogue_text = easter_egg_data[2]
                egg_type = easter_egg_data[3]

                # Parse namecode in dialogue text
                dialogue_text = parse_name_code(dialogue_text, name_code, af=True)

                # Keep all trigger groups together (don't split)
                easter_eggs.append({
                    'trigger_groups': trigger_groups,  # Keep as list
                    'count': count,
                    'type': egg_type,
                    'text': dialogue_text
                })

        return easter_eggs

    def _get_all_skin_dialogues(self, group_id, skin_template, ship_skin_words, name_code):
        """Get dialogues for all skins of a ship.

        Returns list of dicts with skin name and dialogues.
        """
        # Find all skins for this group
        skins = []
        for skin_id, skin_data in skin_template.items():
            if skin_data.get('ship_group') == group_id:
                skins.append({
                    'skin_id': skin_id,
                    'name': skin_data.get('name', ''),
                    'painting': skin_data.get('painting', ''),
                    'group_index': skin_data.get('group_index', 0),
                })

        # Sort by group_index (default skin first)
        skins.sort(key=lambda x: x['group_index'])

        # Extract dialogues for each skin (skip default skin at index 0)
        skin_dialogues = []
        for skin in skins[1:]:  # Skip first skin (already in main dialogues)
            skin_id = skin['skin_id']

            if skin_id not in ship_skin_words:
                continue

            dialogue_data = ship_skin_words[skin_id]
            dialogues = {}

            # Extract dialogue fields
            dialogue_fields = [
                ('login', '登录台词'),
                ('detail', '查看详情台词'),
                ('touch', '普通触摸台词'),
                ('touch2', '特殊触摸台词'),
                ('mission', '任务提醒台词'),
                ('mission_complete', '任务完成台词'),
                ('mail', '邮件提醒台词'),
                ('home', '回港台词'),
                ('feeling1', '好感度-失望台词'),
                ('feeling2', '好感度-陌生台词'),
                ('feeling3', '好感度-友好台词'),
                ('feeling4', '好感度-喜欢台词'),
                ('feeling5', '好感度-爱台词'),
                ('propose', '誓约台词'),
                ('upgrade', '强化成功台词'),
                ('battle', '旗舰开战台词'),
                ('win_mvp', '胜利台词'),
                ('skill', '技能台词'),
            ]

            for field_key, field_name in dialogue_fields:
                text = dialogue_data.get(field_key, '')
                if text:
                    text = parse_name_code(text, name_code, af=True)
                    dialogues[field_name] = text

            # Main dialogues (up to 6 parts)
            main_text = dialogue_data.get('main', '')
            if main_text:
                main_parts = main_text.split('|')
                for i, part in enumerate(main_parts[:6], 1):
                    if part:
                        part = parse_name_code(part, name_code, af=True)
                        dialogues[f'主界面{i}台词'] = part

            if dialogues:
                skin_dialogues.append({
                    'name': skin['name'],
                    'painting': skin['painting'],
                    'dialogues': dialogues
                })

        return skin_dialogues

    def _get_ship_dialogues(self, stat, ship_skin_words, name_code):
        """Get ship dialogue information.

        Returns dict with dialogue text for various situations.
        Handles multi-part dialogues (main interface has up to 6 parts separated by |)
        Namecodes are parsed to {{AF|name}} format for wiki auto-formatting.
        """
        # Get skin_id from statistics (use integer key)
        skin_id = stat.get('skin_id', 0)

        # Look up dialogues in ship_skin_words
        if skin_id not in ship_skin_words:
            # Return empty dialogues if skin not found
            return {
                'login': '',
                'detail': '',
                'main': ['', '', '', '', '', ''],
                'touch': '',
                'touch2': '',
                'headtouch': '',
                'mission': '',
                'mission_complete': '',
                'mail': '',
                'home': '',
                'feeling1': '',
                'feeling2': '',
                'feeling3': '',
                'feeling4': '',
                'feeling5': '',
                'propose': '',
                'expedition': '',
                'upgrade': '',
                'battle': '',
                'win_mvp': '',
                'lose': '',
                'skill': '',
                'hp_warning': '',
            }

        dialogue_data = ship_skin_words[skin_id]

        # Extract single-line dialogues and parse namecodes to {{AF|name}} format
        dialogues = {
            'login': parse_name_code(dialogue_data.get('login', ''), name_code, af=True),
            'detail': parse_name_code(dialogue_data.get('detail', ''), name_code, af=True),
            'touch': parse_name_code(dialogue_data.get('touch', ''), name_code, af=True),
            'touch2': parse_name_code(dialogue_data.get('touch2', ''), name_code, af=True),
            'headtouch': parse_name_code(dialogue_data.get('headtouch', ''), name_code, af=True),
            'mission': parse_name_code(dialogue_data.get('mission', ''), name_code, af=True),
            'mission_complete': parse_name_code(dialogue_data.get('mission_complete', ''), name_code, af=True),
            'mail': parse_name_code(dialogue_data.get('mail', ''), name_code, af=True),
            'home': parse_name_code(dialogue_data.get('home', ''), name_code, af=True),
            'feeling1': parse_name_code(dialogue_data.get('feeling1', ''), name_code, af=True),
            'feeling2': parse_name_code(dialogue_data.get('feeling2', ''), name_code, af=True),
            'feeling3': parse_name_code(dialogue_data.get('feeling3', ''), name_code, af=True),
            'feeling4': parse_name_code(dialogue_data.get('feeling4', ''), name_code, af=True),
            'feeling5': parse_name_code(dialogue_data.get('feeling5', ''), name_code, af=True),
            'propose': parse_name_code(dialogue_data.get('propose', ''), name_code, af=True),
            'expedition': parse_name_code(dialogue_data.get('expedition', ''), name_code, af=True),
            'upgrade': parse_name_code(dialogue_data.get('upgrade', ''), name_code, af=True),
            'battle': parse_name_code(dialogue_data.get('battle', ''), name_code, af=True),
            'win_mvp': parse_name_code(dialogue_data.get('win_mvp', ''), name_code, af=True),
            'lose': parse_name_code(dialogue_data.get('lose', ''), name_code, af=True),
            'skill': parse_name_code(dialogue_data.get('skill', ''), name_code, af=True),
            'hp_warning': parse_name_code(dialogue_data.get('hp_warning', ''), name_code, af=True),
        }

        # Handle multi-part main dialogue (split by | first, then parse each part)
        main_text = dialogue_data.get('main', '')
        if main_text:
            main_parts = main_text.split('|')
            # Pad with empty strings if less than 6 parts
            while len(main_parts) < 6:
                main_parts.append('')
            # Parse namecodes in each part
            dialogues['main'] = [parse_name_code(part, name_code, af=True) for part in main_parts[:6]]
        else:
            dialogues['main'] = ['', '', '', '', '', '']

        return dialogues

    def _get_equipment_info(self, initial_template, initial_stat, max_template, max_stat, pr_prof_bonuses=None, ship_type=None):
        """Get equipment slot information.

        Args:
            pr_prof_bonuses: Optional [slot1, slot2, slot3] proficiency bonuses for PR ships (in decimal)
            ship_type: Ship hull type number (18 = super cruiser)

        Returns dict with equipment data for all 3 slots:
        - slot_types: [type1, type2, type3] - Equipment type names
        - initial_efficiency: [eff1, eff2, eff3] - Initial efficiency percentages
        - max_efficiency: [eff1, eff2, eff3] - Max breakout efficiency percentages
        """
        # Get equipment slot types from template (equip_1, equip_2, equip_3)
        slot_types = []
        for i in range(1, 4):
            equip_field = f'equip_{i}'
            equip_types = initial_template.get(equip_field, [])
            if equip_types and len(equip_types) > 0:
                # Special handling for super cruisers (CB-class, type 18) slot 1
                # Equipment type 11 has context-dependent meaning:
                # - For battleships: '副炮' (auxiliary gun)
                # - For super cruisers: '大口径重巡炮' (large-caliber CA gun)
                if ship_type == 18 and i == 1:  # Super cruiser main gun slot
                    has_ca_gun = 3 in equip_types       # Regular CA gun (type 3)
                    has_large_ca = 11 in equip_types    # Large-caliber CA gun (type 11)

                    if has_ca_gun and has_large_ca:
                        # Can use both types (e.g., Aegir)
                        type_name = '重巡炮、大口径重巡炮'
                    elif has_large_ca and not has_ca_gun:
                        # Only large-caliber CA guns (e.g., Guam)
                        type_name = '大口径重巡炮'
                    elif has_ca_gun and not has_large_ca:
                        # Only regular CA guns (rare case)
                        type_name = '重巡炮'
                    else:
                        # Other equipment types (fallback to default logic)
                        if len(equip_types) > 1:
                            type_names = [self.EQUIPMENT_TYPE_MAP.get(t, f'未知({t})') for t in equip_types]
                            type_name = '、'.join(type_names)
                        else:
                            type_id = equip_types[0]
                            type_name = self.EQUIPMENT_TYPE_MAP.get(type_id, f'未知({type_id})')
                else:
                    # Normal equipment slot handling
                    if len(equip_types) > 1:
                        # Multiple types allowed, concatenate with "、"
                        type_names = [self.EQUIPMENT_TYPE_MAP.get(t, f'未知({t})') for t in equip_types]
                        type_name = '、'.join(type_names)
                    else:
                        # Single type
                        type_id = equip_types[0]
                        type_name = self.EQUIPMENT_TYPE_MAP.get(type_id, f'未知({type_id})')

                slot_types.append(type_name)
            else:
                slot_types.append('')

        # Get initial efficiency from initial stats (level 1, 0-break)
        initial_proficiency = initial_stat.get('equipment_proficiency', [0, 0, 0])
        initial_efficiency = [round(p * 100) if p else 0 for p in initial_proficiency]

        # Get max breakout data from max stats
        max_proficiency = max_stat.get('equipment_proficiency', [0, 0, 0])

        # Apply PR development bonuses if provided
        if pr_prof_bonuses:
            max_proficiency = [
                max_proficiency[i] + pr_prof_bonuses[i] if i < len(max_proficiency) else pr_prof_bonuses[i]
                for i in range(3)
            ]

        max_efficiency = [round(p * 100) if p else 0 for p in max_proficiency]

        # Get weapon counts and preload counts from max statistics
        weapon_counts = max_stat.get('base_list', [0, 0, 0])
        preload_counts = max_stat.get('preload_count', [0, 0, 0])

        return {
            'slot_types': slot_types,
            'initial_efficiency': initial_efficiency,
            'max_efficiency': max_efficiency,
            'weapon_counts': weapon_counts[:3],  # Only first 3 slots
            'preload_counts': preload_counts[:3],  # Only first 3 slots
        }

    def _get_enhancement_info(self, template, strengthen):
        """Get enhancement/strengthening information.

        Returns dict with:
        - values: [firepower, torpedo, aviation, reload] nutrition value (what ship provides)
        - required: {firepower: X, torpedo: Y, aviation: Z, reload: W} required amounts to strengthen ship
        - exp_per_point: {firepower: X, torpedo: Y, aviation: Z, reload: W} exp needed per point
        """
        strengthen_id = template.get('strengthen_id', 0)

        # Try both string and int keys
        strengthen_key = None
        if str(strengthen_id) in strengthen:
            strengthen_key = str(strengthen_id)
        elif strengthen_id in strengthen:
            strengthen_key = strengthen_id

        if not strengthen_key:
            return {
                'values': [0, 0, 0, 0],
                'required': {'firepower': 0, 'torpedo': 0, 'aviation': 0, 'reload': 0},
                'exp_per_point': {'firepower': 30, 'torpedo': 20, 'aviation': 15, 'reload': 25}
            }

        strengthen_data = strengthen[strengthen_key]

        # attr_exp: Nutrition value (what this ship gives when used as material)
        # Array order: [Firepower, Torpedo, AA(?), Aviation(?), Reload]
        attr_exp = strengthen_data.get('attr_exp', [0] * 5)

        # durability: Required strengthening (what this ship needs to be strengthened)
        # Array order: [Firepower, Torpedo, AA(?), Aviation(?), Reload]
        durability = strengthen_data.get('durability', [0] * 5)

        # level_exp: Experience required per point
        # Array order: [Firepower, Torpedo, AA(?), Aviation(?), Reload]
        level_exp = strengthen_data.get('level_exp', [30, 20, 0, 15, 25])

        # Extract values (nutrition value - what ship provides as material)
        values = [
            attr_exp[0] if len(attr_exp) > 0 else 0,  # Firepower
            attr_exp[1] if len(attr_exp) > 1 else 0,  # Torpedo
            attr_exp[3] if len(attr_exp) > 3 else 0,  # Aviation (index 3, skipping AA at index 2)
            attr_exp[4] if len(attr_exp) > 4 else 0,  # Reload
        ]

        # Required amounts (what ship needs to be strengthened)
        required = {
            'firepower': durability[0] if len(durability) > 0 else 0,
            'torpedo': durability[1] if len(durability) > 1 else 0,
            'aviation': durability[3] if len(durability) > 3 else 0,
            'reload': durability[4] if len(durability) > 4 else 0,
        }

        # Experience per point
        exp_per_point = {
            'firepower': level_exp[0] if len(level_exp) > 0 else 30,
            'torpedo': level_exp[1] if len(level_exp) > 1 else 20,
            'aviation': level_exp[3] if len(level_exp) > 3 else 15,
            'reload': level_exp[4] if len(level_exp) > 4 else 25,
        }

        return {
            'values': values,
            'required': required,
            'exp_per_point': exp_per_point
        }

    def _get_oil_consumption(self, initial_template, max_template):
        """Get oil consumption at initial and max level.

        Returns dict with:
        - initial: Oil cost at level 1
        - max: Oil cost at level 100+
        """
        # Initial consumption (level 1, initial breakout)
        initial_oil_start = initial_template.get('oil_at_start', 0)
        initial_oil_end = initial_template.get('oil_at_end', 0)

        # Formula: oil = oil_at_start + oil_at_end × (0.5 + (level-1) × 0.005)
        # At level 1: oil_at_start + oil_at_end × 0.5
        initial_oil = int(initial_oil_start + initial_oil_end * 0.5)

        # Max consumption (level 100, max breakout)
        max_oil_start = max_template.get('oil_at_start', 0)
        max_oil_end = max_template.get('oil_at_end', 0)

        # At level 100: oil_at_start + oil_at_end × (0.5 + 99 × 0.005)
        max_level = 100
        max_oil = int(max_oil_start + max_oil_end * (0.5 + (max_level - 1) * 0.005))

        return {
            'initial': initial_oil,
            'max': max_oil
        }

    def _get_meta_repair_bonuses(self, strengthen_id, meta_strengthen, meta_repair, meta_repair_effect):
        """Calculate total META repair/sync bonuses.

        Returns dict with total bonuses for each stat after maxing all repairs.
        Uses the same logic as ship_stats.py apply_meta_repair_bonus().
        """
        return ShipStatsCalculator.get_meta_repair_totals(
            strengthen_id, meta_strengthen, meta_repair, meta_repair_effect
        )

    def _generate_page(self, ship_info, output_name):
        """Generate wiki page stub for a ship."""
        category = ship_info['category']
        filepath = os.path.join(
            self.config.output_directory,
            'character',
            category,
            f"{output_name}.txt"
        )

        # Load name_code for parsing in page generation
        name_code = get_name_code(self.config)

        # Generate content based on category
        if category == '科研':
            content = self._generate_pr_page(ship_info, name_code)
        elif category == 'Meta':
            content = self._generate_meta_page(ship_info, name_code)
        else:
            content = self._generate_normal_page(ship_info, name_code)

        # Write file
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)

    def _generate_normal_page(self, info, name_code):
        """Generate page stub for normal/collab ships."""
        stats = info['initial_stats']
        max_stats = info['max_stats']

        content = f"""{{{{舰娘图鉴
|分组=
|特殊底色=
|型号=
|名称={info['name']}
|和谐名=
|英文名={info['english_name']}
|日文名=
|编号={info['code']}
|类型={info['ship_type']}
|稀有度={info['rarity']}
|阵营={self.NATIONALITY_MAP.get(info['nationality'], '未知')}
|其他获取途径=<!--【无则不填】-->
|相关活动=
|耗时=<!--无法建造则填无法建造,否则可不填,但需在"建造时间"页面补充数据】-->
|退役收益=<!--无法退役则填无法退役,否则不填-->
|营养价值={{{{强化值|炮击={info['enhancement']['values'][0]}|雷击={info['enhancement']['values'][1]}|航空={info['enhancement']['values'][2]}|装填={info['enhancement']['values'][3]}}}}}
|需强化炮击={info['enhancement']['required']['firepower']}
|强化每点炮击所需经验={info['enhancement']['exp_per_point']['firepower']}
|需强化雷击={info['enhancement']['required']['torpedo']}
|强化每点雷击所需经验={info['enhancement']['exp_per_point']['torpedo']}
|需强化航空={info['enhancement']['required']['aviation']}
|强化每点航空所需经验={info['enhancement']['exp_per_point']['aviation']}
|需强化装填={info['enhancement']['required']['reload']}
|强化每点装填所需经验={info['enhancement']['exp_per_point']['reload']}
|解锁图鉴科技点={info['tech_points']['get'] if info['tech_points']['get'] else ''}
|突破至满星科技点={info['tech_points']['upgrade'] if info['tech_points']['upgrade'] else ''}
|达到120级科技点={info['tech_points']['level'] if info['tech_points']['level'] else ''}
|解锁图鉴属性加成=
|达到120级属性加成=
|图鉴耐久={info['property_hexagon'][0]}
|图鉴防空={info['property_hexagon'][1]}
|图鉴机动={info['property_hexagon'][2]}
|图鉴航空={info['property_hexagon'][3]}
|图鉴雷击={info['property_hexagon'][4]}
|图鉴炮击={info['property_hexagon'][5]}
|装甲类型={info['armor_type']}
|初始耐久={stats[0]}
|初始装填={stats[5]}
|初始命中={stats[7]}
|初始炮击={stats[1]}
|初始雷击={stats[2]}
|初始机动={stats[8]}
|初始防空={stats[3]}
|初始航空={stats[4]}
|初始消耗={info['oil_consumption']['initial']}
|初始反潜={stats[11]}
|满级耐久={max_stats[0]}
|满级装填={max_stats[5]}
|满级命中={max_stats[7]}
|满级炮击={max_stats[1]}
|满级雷击={max_stats[2]}
|满级机动={max_stats[8]}
|满级防空={max_stats[3]}
|满级航空={max_stats[4]}
|满级消耗={info['oil_consumption']['max']}
|满级反潜={max_stats[11]}
|航速={stats[9]}
|幸运={stats[10]}
|技能1名={info['skills'][0]['name'] if len(info['skills']) > 0 else ''}
|技能1={info['skills'][0]['desc'] if len(info['skills']) > 0 else ''}
|技能2名={info['skills'][1]['name'] if len(info['skills']) > 1 else ''}
|技能2={info['skills'][1]['desc'] if len(info['skills']) > 1 else ''}
|技能3名={info['skills'][2]['name'] if len(info['skills']) > 2 else ''}
|技能3={info['skills'][2]['desc'] if len(info['skills']) > 2 else ''}
|技能4名={info['skills'][3]['name'] if len(info['skills']) > 3 else ''}
|技能4={info['skills'][3]['desc'] if len(info['skills']) > 3 else ''}
|突破1阶效果=
|突破2阶效果=
|突破3阶效果=
|1号槽装备类型={info['equipment']['slot_types'][0]}
|2号槽装备类型={info['equipment']['slot_types'][1]}
|3号槽装备类型={info['equipment']['slot_types'][2]}
|1号槽装备效率初始={info['equipment']['initial_efficiency'][0]}%
|2号槽装备效率初始={info['equipment']['initial_efficiency'][1]}%
|3号槽装备效率初始={info['equipment']['initial_efficiency'][2]}%
|1号槽装备效率满破={info['equipment']['max_efficiency'][0]}%
|2号槽装备效率满破={info['equipment']['max_efficiency'][1]}%
|3号槽装备效率满破={info['equipment']['max_efficiency'][2]}%
|1号槽满破武器数={info['equipment']['weapon_counts'][0] if info['equipment']['weapon_counts'][0] else ''}
|2号槽满破武器数={info['equipment']['weapon_counts'][1] if info['equipment']['weapon_counts'][1] else ''}
|3号槽满破武器数={info['equipment']['weapon_counts'][2] if info['equipment']['weapon_counts'][2] else ''}
|1号槽满破预装填数={info['equipment']['preload_counts'][0]}
|2号槽满破预装填数={info['equipment']['preload_counts'][1]}
|3号槽满破预装填数={info['equipment']['preload_counts'][2]}
|装备1=
|装备2=
|装备3=
|装备说明=
|评价=
|技能数据=
|机制解析=
|备注=
|CV=
|画师={{{{画师数据 | }}}}
|微博={{{{画师数据 | |微博}}}}
|推特={{{{画师数据 | |推特}}}}
|P站={{{{画师数据 | |P站}}}}
|舰船型号台词=
|自我介绍台词=
|获取台词=
|登录台词={info['dialogues']['login']}
|登录台词_2=
|查看详情台词={info['dialogues']['detail']}
|查看详情台词_2=
|主界面1台词={info['dialogues']['main'][0]}
|主界面2台词={info['dialogues']['main'][1]}
|主界面3台词={info['dialogues']['main'][2]}
|主界面4台词={info['dialogues']['main'][3]}
|主界面5台词={info['dialogues']['main'][4]}
|主界面6台词={info['dialogues']['main'][5]}
|普通触摸台词={info['dialogues']['touch']}
|普通触摸台词_2=
|特殊触摸台词={info['dialogues']['touch2']}
|特殊触摸台词_2=
|摸头台词={info['dialogues']['headtouch']}
|摸头台词_2=
|任务提醒台词={info['dialogues']['mission']}
|任务提醒台词_2=
|任务完成台词={info['dialogues']['mission_complete']}
|任务完成台词_2=
|邮件提醒台词={info['dialogues']['mail']}
|邮件提醒台词_2=
|回港台词={info['dialogues']['home']}
|回港台词_2=
|好感度-失望台词={info['dialogues']['feeling1']}
|好感度-陌生台词={info['dialogues']['feeling2']}
|好感度-友好台词={info['dialogues']['feeling3']}
|好感度-喜欢台词={info['dialogues']['feeling4']}
|好感度-爱台词={info['dialogues']['feeling5']}
|好感度-爱台词_2=
|誓约台词={info['dialogues']['propose']}
|委托完成台词={info['dialogues']['expedition']}
|委托完成台词_2=
|强化成功台词={info['dialogues']['upgrade']}
|强化成功台词_2=
|旗舰开战台词={info['dialogues']['battle']}
|旗舰开战台词_2=
|胜利台词={info['dialogues']['win_mvp']}
|胜利台词_2=
|失败台词={info['dialogues']['lose']}
|失败台词_2=
|技能台词={info['dialogues']['skill']}
|血量告急台词={info['dialogues']['hp_warning']}
"""

        # Add easter egg dialogues (normal ships)
        easter_eggs = info.get('easter_eggs', [])
        if easter_eggs:
            for i, egg in enumerate(easter_eggs[:2], 1):  # Only first 2 easter eggs
                # Format: {{#invoke:彩蛋台词|解析|group1|group2|...|count|type}}text
                trigger_params = '|'.join(str(g) for g in egg['trigger_groups'])
                invoke = f"{{{{#invoke:彩蛋台词|解析|{trigger_params}|{egg['count']}|{egg['type']}}}}}"
                content += f"|彩蛋{i}台词={invoke}{egg['text']}\n"
        else:
            content += "|彩蛋1台词=\n|彩蛋2台词=\n"

        content += """|特性标签=
|实装日期=
|身份=
|性格=
|关键词=
|持有物=
|发色=
|瞳色=
|萌点=
}}
"""

        # Add skin dialogues AFTER template closes (using Lua module invoke format)
        skin_dialogues_list = info.get('skin_dialogues', [])
        if skin_dialogues_list:
            content += "{{#invoke: 舰娘台词 | 台词面板\n"

            for i, skin in enumerate(skin_dialogues_list, 1):
                # Skin title (use actual skin name, parse namecode)
                skin_name = parse_name_code(skin['name'], name_code, af=False)
                content += f"| 标题{i} = {skin_name}\n"

                # Skin dialogue table
                content += f"| 内容{i} = {{{{#invoke: 舰娘台词 | 台词表格\n"

                # Map dialogue fields to wiki format
                dialogue_mapping = {
                    '登录台词': 'login',
                    '查看详情台词': 'detail',
                    '主界面1台词': 'main_1',
                    '主界面2台词': 'main_2',
                    '主界面3台词': 'main_3',
                    '主界面4台词': 'main_4',
                    '主界面5台词': 'main_5',
                    '主界面6台词': 'main_6',
                    '普通触摸台词': 'touch',
                    '特殊触摸台词': 'touch2',
                    '摸头台词': 'headtouch',
                    '任务提醒台词': 'mission',
                    '任务完成台词': 'mission_complete',
                    '邮件提醒台词': 'mail',
                    '回港台词': 'home',
                    '好感度-失望台词': 'feeling1',
                    '好感度-陌生台词': 'feeling2',
                    '好感度-友好台词': 'feeling3',
                    '好感度-喜欢台词': 'feeling4',
                    '好感度-爱台词': 'feeling5',
                    '誓约台词': 'propose',
                    '强化成功台词': 'upgrade',
                    '旗舰开战台词': 'battle',
                    '胜利台词': 'win_mvp',
                    '技能台词': 'skill',
                }

                for field_name_cn, field_name_en in dialogue_mapping.items():
                    if field_name_cn in skin['dialogues']:
                        dialogue_text = skin['dialogues'][field_name_cn]
                        if dialogue_text:  # Only add non-empty dialogues
                            content += f"  | {field_name_en} = {dialogue_text}\n"

                content += "  }}\n"

            content += "}}\n"

        content += """
==舰船相关==
===原型舰简介===
===舰船历史===
==游戏相关==
===更新日志===
===角色设定===
{{#invoke:角色剧情卡|main}}
===相关解释===
===相关图片===
<gallery mode="packed" heights="250px">
沙盒官方海报.jpg|官方海报
沙盒换装官方海报.jpg|换装「」
</gallery>
==其它舰船==
{{舰娘图鉴导航}}"""

        return content

    def _generate_pr_page(self, info, name_code):
        """Generate page stub for PR/DR ships."""
        stats = info['initial_stats']
        max_stats = info['max_stats']

        # Format luck with max value for PR ships
        luck_display = f"0({info['pr_max_luck']})" if info.get('pr_max_luck') else str(stats[10])

        content = f"""{{{{舰娘图鉴
|分组=方案
|特殊底色=
|型号=
|名称={info['name']}
|和谐名=
|英文名={info['english_name']}
|日文名=
|编号={info['code'] % 10000:03d}
|类型={info['ship_type']}
|稀有度=决战方案
|阵营={self.NATIONALITY_MAP.get(info['nationality'], '未知')}
|其他获取途径=[[开发船坞]]
|相关活动=
|耗时=无法建造
|退役收益=无法退役
|营养价值=不可用作强化材料
|需强化炮击=
|强化每点炮击所需经验=
|需强化雷击=
|强化每点雷击所需经验=
|需强化航空=
|强化每点航空所需经验=
|需强化装填=
|强化每点装填所需经验=
|解锁图鉴科技点={info['tech_points']['get']}
|突破至满星科技点={info['tech_points']['upgrade']}
|达到120级科技点={info['tech_points']['level']}
|解锁图鉴属性加成=
|达到120级属性加成=
|图鉴耐久={info['property_hexagon'][0]}
|图鉴防空={info['property_hexagon'][1]}
|图鉴机动={info['property_hexagon'][2]}
|图鉴航空={info['property_hexagon'][3]}
|图鉴雷击={info['property_hexagon'][4]}
|图鉴炮击={info['property_hexagon'][5]}
|装甲类型={info['armor_type']}
|初始耐久={stats[0]}
|初始装填={stats[5]}
|初始命中={stats[7]}
|初始炮击={stats[1]}
|初始雷击={stats[2]}
|初始机动={stats[8]}
|初始防空={stats[3]}
|初始航空={stats[4]}
|初始消耗={info['oil_consumption']['initial']}
|初始反潜={stats[11]}
|满级耐久={max_stats[0]}
|满级装填={max_stats[5]}
|满级命中={max_stats[7]}
|满级炮击={max_stats[1]}
|满级雷击={max_stats[2]}
|满级机动={max_stats[8]}
|满级防空={max_stats[3]}
|满级航空={max_stats[4]}
|满级消耗={info['oil_consumption']['max']}
|满级反潜={max_stats[11]}
|航速={stats[9]}
|幸运={luck_display}
|技能1名={info['skills'][0]['name'] if len(info['skills']) > 0 else ''}
|技能1={info['skills'][0]['desc'] if len(info['skills']) > 0 else ''}
|技能2名={info['skills'][1]['name'] if len(info['skills']) > 1 else ''}
|技能2={info['skills'][1]['desc'] if len(info['skills']) > 1 else ''}
|技能3名={info['skills'][2]['name'] if len(info['skills']) > 2 else ''}
|技能3={info['skills'][2]['desc'] if len(info['skills']) > 2 else ''}
|技能4名={info['skills'][3]['name'] if len(info['skills']) > 3 else ''}
|技能4={info['skills'][3]['desc'] if len(info['skills']) > 3 else ''}
|突破1阶效果=
|突破2阶效果=
|突破3阶效果=
|5级开发加成=
|10级开发加成=
|15级开发加成=
|20级开发加成=
|25级开发加成=
|30级开发加成=
|1号槽装备类型={info['equipment']['slot_types'][0]}
|2号槽装备类型={info['equipment']['slot_types'][1]}
|3号槽装备类型={info['equipment']['slot_types'][2]}
|1号槽装备效率初始={info['equipment']['initial_efficiency'][0]}%
|2号槽装备效率初始={info['equipment']['initial_efficiency'][1]}%
|3号槽装备效率初始={info['equipment']['initial_efficiency'][2]}%
|1号槽装备效率满破={info['equipment']['max_efficiency'][0]}%
|2号槽装备效率满破={info['equipment']['max_efficiency'][1]}%
|3号槽装备效率满破={info['equipment']['max_efficiency'][2]}%
|1号槽满破武器数={info['equipment']['weapon_counts'][0] if info['equipment']['weapon_counts'][0] else ''}
|2号槽满破武器数={info['equipment']['weapon_counts'][1] if info['equipment']['weapon_counts'][1] else ''}
|3号槽满破武器数={info['equipment']['weapon_counts'][2] if info['equipment']['weapon_counts'][2] else ''}
|1号槽满破预装填数={info['equipment']['preload_counts'][0]}
|2号槽满破预装填数={info['equipment']['preload_counts'][1]}
|3号槽满破预装填数={info['equipment']['preload_counts'][2]}
|装备1=
|装备2=
|装备3=
|装备说明=
|评价=
|技能数据=
|机制解析=
|备注=
|CV=
|画师={{{{画师数据 | }}}}
|微博={{{{画师数据 | |微博}}}}
|推特={{{{画师数据 | |推特}}}}
|P站={{{{画师数据 | |P站}}}}
|舰船型号台词=
|自我介绍台词=
|获取台词=
|登录台词={info['dialogues']['login']}
|登录台词_2=
|查看详情台词={info['dialogues']['detail']}
|查看详情台词_2=
|主界面1台词={info['dialogues']['main'][0]}
|主界面2台词={info['dialogues']['main'][1]}
|主界面3台词={info['dialogues']['main'][2]}
|主界面4台词={info['dialogues']['main'][3]}
|主界面5台词={info['dialogues']['main'][4]}
|主界面6台词={info['dialogues']['main'][5]}
|主界面7台词=
|主界面8台词=
|普通触摸台词={info['dialogues']['touch']}
|普通触摸台词_2=
|特殊触摸台词={info['dialogues']['touch2']}
|特殊触摸台词_2=
|摸头台词={info['dialogues']['headtouch']}
|摸头台词_2=
|任务提醒台词={info['dialogues']['mission']}
|任务提醒台词_2=
|任务完成台词={info['dialogues']['mission_complete']}
|任务完成台词_2=
|邮件提醒台词={info['dialogues']['mail']}
|邮件提醒台词_2=
|回港台词={info['dialogues']['home']}
|回港台词_2=
|好感度-失望台词={info['dialogues']['feeling1']}
|好感度-陌生台词={info['dialogues']['feeling2']}
|好感度-友好台词={info['dialogues']['feeling3']}
|好感度-喜欢台词={info['dialogues']['feeling4']}
|好感度-爱台词={info['dialogues']['feeling5']}
|好感度-爱台词_2=
|誓约台词={info['dialogues']['propose']}
|委托完成台词={info['dialogues']['expedition']}
|委托完成台词_2=
|强化成功台词={info['dialogues']['upgrade']}
|强化成功台词_2=
|旗舰开战台词={info['dialogues']['battle']}
|旗舰开战台词_2=
|胜利台词={info['dialogues']['win_mvp']}
|胜利台词_2=
|失败台词={info['dialogues']['lose']}
|失败台词_2=
|技能台词={info['dialogues']['skill']}
"""

        # Add easter egg dialogues (PR ships)
        easter_eggs = info.get('easter_eggs', [])
        if easter_eggs:
            content += "|血量告急台词=\n"
            for i, egg in enumerate(easter_eggs[:2], 1):  # Only first 2 easter eggs
                # Format: {{#invoke:彩蛋台词|解析|group1|group2|...|count|type}}text
                trigger_params = '|'.join(str(g) for g in egg['trigger_groups'])
                invoke = f"{{{{#invoke:彩蛋台词|解析|{trigger_params}|{egg['count']}|{egg['type']}}}}}"
                content += f"|彩蛋{i}台词={invoke}{egg['text']}\n"
        else:
            content += "|血量告急台词=\n|彩蛋1台词=\n|彩蛋2台词=\n"

        content += """|特性标签=
|实装日期=
|身份=
|性格=
|关键词=
|持有物=
|发色=
|瞳色=
|萌点=
}}
"""

        # Add skin dialogues AFTER template closes (using Lua module invoke format)
        skin_dialogues_list = info.get('skin_dialogues', [])
        if skin_dialogues_list:
            content += "{{#invoke: 舰娘台词 | 台词面板\n"

            for i, skin in enumerate(skin_dialogues_list, 1):
                # Skin title (use actual skin name, parse namecode)
                skin_name = parse_name_code(skin['name'], name_code, af=False)
                content += f"| 标题{i} = {skin_name}\n"

                # Skin dialogue table
                content += f"| 内容{i} = {{{{#invoke: 舰娘台词 | 台词表格\n"

                # Map dialogue fields to wiki format
                dialogue_mapping = {
                    '登录台词': 'login',
                    '查看详情台词': 'detail',
                    '主界面1台词': 'main_1',
                    '主界面2台词': 'main_2',
                    '主界面3台词': 'main_3',
                    '主界面4台词': 'main_4',
                    '主界面5台词': 'main_5',
                    '主界面6台词': 'main_6',
                    '普通触摸台词': 'touch',
                    '特殊触摸台词': 'touch2',
                    '摸头台词': 'headtouch',
                    '任务提醒台词': 'mission',
                    '任务完成台词': 'mission_complete',
                    '邮件提醒台词': 'mail',
                    '回港台词': 'home',
                    '好感度-失望台词': 'feeling1',
                    '好感度-陌生台词': 'feeling2',
                    '好感度-友好台词': 'feeling3',
                    '好感度-喜欢台词': 'feeling4',
                    '好感度-爱台词': 'feeling5',
                    '誓约台词': 'propose',
                    '强化成功台词': 'upgrade',
                    '旗舰开战台词': 'battle',
                    '胜利台词': 'win_mvp',
                    '技能台词': 'skill',
                }

                for field_name_cn, field_name_en in dialogue_mapping.items():
                    if field_name_cn in skin['dialogues']:
                        dialogue_text = skin['dialogues'][field_name_cn]
                        if dialogue_text:  # Only add non-empty dialogues
                            content += f"  | {field_name_en} = {dialogue_text}\n"

                content += "  }}\n"

            content += "}}\n"

        content += """
==舰船相关==
===原型舰简介===
===舰船历史===
==游戏相关==
===更新日志===
===角色设定===
{{#invoke:角色剧情卡|main}}
===相关解释===
===相关图片===
<gallery mode="packed" heights="250px">
沙盒官方海报.jpg|官方海报
沙盒换装官方海报.jpg|换装「」
</gallery>
==其它舰船==
{{舰娘图鉴导航}}"""

        return content

    def _generate_meta_page(self, info, name_code):
        """Generate page stub for META ships."""
        stats = info['initial_stats']
        max_stats = info['max_stats']

        content = f"""{{{{舰娘图鉴
|分组=META
|特殊底色=META超稀有
|型号=
|名称={info['name']}
|和谐名=
|英文名={info['english_name']}
|日文名=
|编号={info['code'] % 10000:03d}
|类型={info['ship_type']}
|初始星级=★★★☆☆☆
|稀有度=超稀有
|阵营=META-???
|掉落点=
|活动掉落点=
|其他获取途径=[[META研究室|META研究室资讯同步]]<br>[[META研究室#信标档案|信标档案]]
|耗时=无法建造
|营养价值=不可用作强化材料
|退役收益=无法退役
|强化加成炮击={info['meta_bonuses']['cannon'] if info['meta_bonuses'] and info['meta_bonuses']['cannon'] else ''}
|强化加成雷击={info['meta_bonuses']['torpedo'] if info['meta_bonuses'] and info['meta_bonuses']['torpedo'] else ''}
|强化加成航空={info['meta_bonuses']['air'] if info['meta_bonuses'] and info['meta_bonuses']['air'] else ''}
|强化加成装填={info['meta_bonuses']['reload'] if info['meta_bonuses'] and info['meta_bonuses']['reload'] else ''}
|强化加成耐久={info['meta_bonuses']['durability'] if info['meta_bonuses'] and info['meta_bonuses']['durability'] else ''}
|强化加成防空={info['meta_bonuses']['antiaircraft'] if info['meta_bonuses'] and info['meta_bonuses']['antiaircraft'] else ''}
|强化加成命中={info['meta_bonuses']['hit'] if info['meta_bonuses'] and info['meta_bonuses']['hit'] else ''}
|强化加成机动={info['meta_bonuses']['dodge'] if info['meta_bonuses'] and info['meta_bonuses']['dodge'] else ''}
|解锁图鉴科技点={info['tech_points']['get']}
|突破至满星科技点={info['tech_points']['upgrade']}
|达到120级科技点={info['tech_points']['level']}
|解锁图鉴属性加成=
|达到120级属性加成=
|图鉴耐久={info['property_hexagon'][0]}
|图鉴防空={info['property_hexagon'][1]}
|图鉴机动={info['property_hexagon'][2]}
|图鉴航空={info['property_hexagon'][3]}
|图鉴雷击={info['property_hexagon'][4]}
|图鉴炮击={info['property_hexagon'][5]}
|装甲类型={info['armor_type']}
|初始耐久={stats[0]}
|初始装填={stats[5]}
|初始命中={stats[7]}
|初始炮击={stats[1]}
|初始雷击={stats[2]}
|初始机动={stats[8]}
|初始防空={stats[3]}
|初始航空={stats[4]}
|初始消耗={info['oil_consumption']['initial']}
|初始反潜={stats[11]}
|满级耐久={max_stats[0]}
|满级装填={max_stats[5]}
|满级命中={max_stats[7]}
|满级炮击={max_stats[1]}
|满级雷击={max_stats[2]}
|满级机动={max_stats[8]}
|满级防空={max_stats[3]}
|满级航空={max_stats[4]}
|满级消耗={info['oil_consumption']['max']}
|满级反潜={max_stats[11]}
|航速={stats[9]}
|幸运={stats[10]}
|技能1名={info['skills'][0]['name'] if len(info['skills']) > 0 else ''}
|技能1={info['skills'][0]['desc'] if len(info['skills']) > 0 else ''}
|技能2名={info['skills'][1]['name'] if len(info['skills']) > 1 else ''}
|技能2={info['skills'][1]['desc'] if len(info['skills']) > 1 else ''}
|技能3名={info['skills'][2]['name'] if len(info['skills']) > 2 else ''}
|技能3={info['skills'][2]['desc'] if len(info['skills']) > 2 else ''}
|技能4名={info['skills'][3]['name'] if len(info['skills']) > 3 else ''}
|技能4显示名=
|技能4={info['skills'][3]['desc'] if len(info['skills']) > 3 else ''}
|突破1阶效果=
|突破2阶效果=
|突破3阶效果=
|1号槽装备类型={info['equipment']['slot_types'][0]}
|2号槽装备类型={info['equipment']['slot_types'][1]}
|3号槽装备类型={info['equipment']['slot_types'][2]}
|1号槽装备效率初始={info['equipment']['initial_efficiency'][0]}%
|2号槽装备效率初始={info['equipment']['initial_efficiency'][1]}%
|3号槽装备效率初始={info['equipment']['initial_efficiency'][2]}%
|1号槽装备效率满破={info['equipment']['max_efficiency'][0]}%
|2号槽装备效率满破={info['equipment']['max_efficiency'][1]}%
|3号槽装备效率满破={info['equipment']['max_efficiency'][2]}%
|1号槽满破武器数={info['equipment']['weapon_counts'][0] if info['equipment']['weapon_counts'][0] else ''}
|2号槽满破武器数={info['equipment']['weapon_counts'][1] if info['equipment']['weapon_counts'][1] else ''}
|3号槽满破武器数={info['equipment']['weapon_counts'][2] if info['equipment']['weapon_counts'][2] else ''}
|1号槽满破预装填数={info['equipment']['preload_counts'][0]}
|2号槽满破预装填数={info['equipment']['preload_counts'][1]}
|3号槽满破预装填数={info['equipment']['preload_counts'][2]}
|装备1=
|装备2=
|装备3=
|装备说明=
|评价=
|备注=
|CV=
|画师={{{{画师数据 | }}}}
|微博={{{{画师数据 | |微博}}}}
|推特={{{{画师数据 | |推特}}}}
|P站={{{{画师数据 | |P站}}}}
|舰船型号台词=
|自我介绍台词=
|获取台词=
|登录台词={info['dialogues']['login']}
|查看详情台词={info['dialogues']['detail']}
|主界面1台词={info['dialogues']['main'][0]}
|主界面2台词={info['dialogues']['main'][1]}
|主界面3台词={info['dialogues']['main'][2]}
|普通触摸台词={info['dialogues']['touch']}
|特殊触摸台词={info['dialogues']['touch2']}
|摸头台词={info['dialogues']['headtouch']}
|任务提醒台词={info['dialogues']['mission']}
|任务完成台词={info['dialogues']['mission_complete']}
|邮件提醒台词={info['dialogues']['mail']}
|回港台词={info['dialogues']['home']}
|好感度-未知台词={info['dialogues']['feeling1']}
|好感度-调率台词={info['dialogues']['feeling2']}
|好感度-理解台词={info['dialogues']['feeling3']}
|好感度-同步台词={info['dialogues']['feeling4']}
|好感度-共鸣台词={info['dialogues']['feeling5']}
|誓约台词={info['dialogues']['propose']}
|委托完成台词={info['dialogues']['expedition']}
|强化成功台词={info['dialogues']['upgrade']}
|旗舰开战台词={info['dialogues']['battle']}
|胜利台词={info['dialogues']['win_mvp']}
|失败台词={info['dialogues']['lose']}
|技能台词={info['dialogues']['skill']}
|血量告急台词={info['dialogues']['hp_warning']}
"""

        # Add easter egg dialogues (META ships)
        easter_eggs = info.get('easter_eggs', [])
        if easter_eggs:
            for i, egg in enumerate(easter_eggs[:2], 1):  # Only first 2 easter eggs
                # Format: {{#invoke:彩蛋台词|解析|group1|group2|...|count|type}}text
                trigger_params = '|'.join(str(g) for g in egg['trigger_groups'])
                invoke = f"{{{{#invoke:彩蛋台词|解析|{trigger_params}|{egg['count']}|{egg['type']}}}}}"
                content += f"|彩蛋{i}台词={invoke}{egg['text']}\n"
        else:
            content += "|彩蛋1台词=\n|彩蛋2台词=\n"

        content += """|特性标签=
|实装日期=
|身份=
|性格=
|关键词=
|持有物=
|发色=
|瞳色=
|萌点=
}}
"""

        # Add skin dialogues AFTER template closes (using Lua module invoke format)
        skin_dialogues_list = info.get('skin_dialogues', [])
        if skin_dialogues_list:
            content += "{{#invoke: 舰娘台词 | 台词面板\n"

            for i, skin in enumerate(skin_dialogues_list, 1):
                # Skin title (use actual skin name, parse namecode)
                skin_name = parse_name_code(skin['name'], name_code, af=False)
                content += f"| 标题{i} = {skin_name}\n"

                # Skin dialogue table
                content += f"| 内容{i} = {{{{#invoke: 舰娘台词 | 台词表格\n"

                # Map dialogue fields to wiki format
                dialogue_mapping = {
                    '登录台词': 'login',
                    '查看详情台词': 'detail',
                    '主界面1台词': 'main_1',
                    '主界面2台词': 'main_2',
                    '主界面3台词': 'main_3',
                    '主界面4台词': 'main_4',
                    '主界面5台词': 'main_5',
                    '主界面6台词': 'main_6',
                    '普通触摸台词': 'touch',
                    '特殊触摸台词': 'touch2',
                    '摸头台词': 'headtouch',
                    '任务提醒台词': 'mission',
                    '任务完成台词': 'mission_complete',
                    '邮件提醒台词': 'mail',
                    '回港台词': 'home',
                    '好感度-失望台词': 'feeling1',
                    '好感度-陌生台词': 'feeling2',
                    '好感度-友好台词': 'feeling3',
                    '好感度-喜欢台词': 'feeling4',
                    '好感度-爱台词': 'feeling5',
                    '誓约台词': 'propose',
                    '强化成功台词': 'upgrade',
                    '旗舰开战台词': 'battle',
                    '胜利台词': 'win_mvp',
                    '技能台词': 'skill',
                }

                for field_name_cn, field_name_en in dialogue_mapping.items():
                    if field_name_cn in skin['dialogues']:
                        dialogue_text = skin['dialogues'][field_name_cn]
                        if dialogue_text:  # Only add non-empty dialogues
                            content += f"  | {field_name_en} = {dialogue_text}\n"

                content += "  }}\n"

            content += "}}\n"

        content += """
==舰船相关==
===原型舰简介===
===舰船历史===
==游戏相关==
===更新日志===
===角色设定===
{{#invoke:角色剧情卡|main}}
===相关解释===
===相关图片===
<gallery mode="packed" heights="250px">
沙盒官方海报.jpg|官方海报
沙盒换装官方海报.jpg|换装「」
</gallery>
==其它舰船==
{{舰娘图鉴导航}}"""

        return content

    # Data loading methods (reuse from ShipStatsGenerator)
    def _get_ship_group(self):
        return parse_data_file('ship_data_group', config=self.config)

    def _get_ship_statistics(self):
        return parse_data_file('ship_data_statistics', config=self.config)

    def _get_ship_template(self):
        return parse_data_file('ship_data_template', config=self.config)

    def _get_ship_skin_template(self):
        return parse_data_file('ship_skin_template', config=self.config)

    def _get_ship_strengthen(self):
        return parse_data_file('ship_data_strengthen', config=self.config)

    def _get_ship_trans(self):
        return parse_data_file('ship_data_trans', config=self.config)

    def _get_transform_template(self):
        return parse_data_file('transform_data_template', config=self.config)

    def _get_ship_data_blueprint(self):
        return parse_data_file('ship_data_blueprint', config=self.config)

    def _get_ship_strengthen_blueprint(self):
        return parse_data_file('ship_strengthen_blueprint', config=self.config)

    def _get_ship_strengthen_meta(self):
        return parse_data_file('ship_strengthen_meta', config=self.config)

    def _get_ship_meta_repair(self):
        return parse_data_file('ship_meta_repair', config=self.config)

    def _get_ship_meta_repair_effect(self):
        return parse_data_file('ship_meta_repair_effect', config=self.config)

    def _get_skill_display(self):
        return parse_data_file('skill_data_display', config=self.config)

    def _get_skill_template(self):
        """Load skill_data_template which contains skill names and descriptions."""
        return parse_data_file('skill_data_template', config=self.config)

    def _get_ship_skin_words(self):
        """Load ship_skin_words which contains all dialogue text."""
        return parse_data_file('ship_skin_words', config=self.config)

    def _get_fleet_tech_ship_template(self):
        """Load fleet_tech_ship_template which contains tech points."""
        return parse_data_file('fleet_tech_ship_template', config=self.config)
