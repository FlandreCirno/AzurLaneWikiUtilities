# -*- coding: utf-8 -*-
"""Wiki module generators for Lua data modules."""
import os
from .base import BaseGenerator
from ..core import parse_data_file


class WikiModulesGenerator(BaseGenerator):
    """Generator for wiki Lua data modules (模块:舰娘数据 and 模块:装备数据)."""

    def generate(self):
        """Generate both ship data and equipment data modules."""
        self.generate_ship_data_module()
        self.generate_equipment_data_module()

    def generate_ship_data_module(self):
        """Generate 模块:舰娘数据 (Ship Data Module)."""
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
        group_min_star = {}
        for template_id, template_info in ship_data_template.items():
            group_type = template_info.get('group_type', 0)
            star = template_info.get('star', 0)
            if group_type not in group_min_star or star < group_min_star[group_type]['star']:
                group_min_star[group_type] = {
                    'star': star,
                    'id': template_info.get('id', 0)
                }

        # Build ship_data table using the base form (minimum star) for each group
        ship_data = {}
        for group_type, info in group_min_star.items():
            ship_id = info['id']
            if ship_id == 0:
                continue

            # Get ship stats from statistics (keys are integers)
            ship_info = ship_statistics.get(ship_id, {})
            name = ship_info.get('name', '')
            if not name:
                continue

            entry = {
                'id': ship_id,
                'nationality': ship_info.get('nationality', 0),
                'type': ship_info.get('type', 0),
                'rarity': ship_info.get('rarity', 0),
            }

            # Add transform flag if ship's group can retrofit
            if group_type in transform_groups:
                entry['transform'] = True

            ship_data[name] = entry

        # Define lookup tables
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

        # Generate Lua output
        output_path = os.path.join(self.config.output_directory, '模块_舰娘数据.lua')
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write('local p = {}\n\n')

            # Write ship_data table
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

            # Write nation_data
            f.write('p.nation_data = {\n')
            for key in sorted(nation_data.keys()):
                f.write(f"\t[{key}] = '{nation_data[key]}',\n")
            f.write('}\n\n')

            # Write nation_data.prints
            f.write('p.nation_data.prints = {\n')
            for key in sorted(nation_prints.keys()):
                f.write(f'\t[{key}] = "{nation_prints[key]}",\n')
            f.write('}\n\n')

            # Write type_data
            f.write('p.type_data = {\n')
            for key in sorted(type_data.keys()):
                comment = ""
                if key == 6:
                    comment = "\t\t--轻母"
                elif key == 7:
                    comment = "\t\t--正航"
                elif key == 20:
                    comment = "\t\t--前排，后排21"
                f.write(f'\t[{key}] = "{type_data[key]}",{comment}\n')
            f.write('}\n\n')

            # Write type_sort
            f.write('p.type_sort = {\n')
            for key in sorted(type_sort.keys()):
                f.write(f'\t[{key}] = {type_sort[key]},\n')
            f.write('}\n\n')

            # Write nation_sort
            f.write('p.nation_sort = {\n')
            for key in sorted(nation_sort.keys()):
                f.write(f'\t[{key}] = {nation_sort[key]},\n')
            f.write('}\n\n')

            # Write helper functions
            f.write('''--------------------------------------------------
--	将阵营ID转换为阵营的名字
--------------------------------------------------
function p.NationIdToName(id, default)
	--if id == 'prints' then return default end
	return p.nation_data[id] or default
end

--------------------------------------------------
--	将阵营ID转换为阵营的英文缩写
--------------------------------------------------
function p.NationIdToAbbreviation(id, default)
	return p.nation_data.prints[id] or default
end

--------------------------------------------------
--	将舰船类型ID转换为舰船类型的名字
--------------------------------------------------
function p.TypeIdToName(id, default)
	return p.type_data[id] or default
end

--------------------------------------------------
--	将舰船ID转换为舰船的名字
--------------------------------------------------
function p.ShipIdToName(id, default)
	local id1 = id * 10 + 1
	for ship, v in pairs(p.ship_data) do
		if v.id == id then return ship end
		if v.id == id1 then return ship end
	end
	return default
end

--------------------------------------------------
--	将舰船名字标准化为当前wiki通用的船名
--------------------------------------------------
function p.NormalizeShipName(name)
	if type(name) == 'number' then
		return tostring(name)
	elseif type(name) ~= 'string' then
		error('NormalizeShipName：第一参数应为string类型（实际为'..type(name)..'）', 2)
	end
	return name:gsub('jp','JP'):gsub('de','DE'):gsub('MKⅡ','MKII'):gsub('doa','DOA'):gsub('ssss','SSSS'):gsub('meta','·META'):gsub('北安普顿','北安普敦'):gsub('休斯顿','休斯敦'):gsub('马可波罗','马可·波罗'):gsub('▪','·'):gsub('・','·')
end

return p
''')

        print(f"  Generated: {output_path}")

    def generate_equipment_data_module(self):
        """Generate 模块:装备数据 (Equipment Data Module)."""
        # Load required data
        equip_statistics = parse_data_file('equip_data_statistics', config=self.config)
        equip_template = parse_data_file('equip_data_template', config=self.config)

        # Build equipment data structure
        equip_data_map = {}  # Group by base equipment ID

        for equip_id, equip_info in equip_statistics.items():
            name = equip_info.get('name', '')
            if not name:
                continue

            # Get template info
            template_info = equip_template.get(str(equip_id), {})

            base_id = template_info.get('base', 0)
            if base_id == 0:
                base_id = int(equip_id)

            tech_level = equip_info.get('tech', 0)
            nationality = equip_info.get('nationality', 0)
            equip_type = equip_info.get('type', 0)
            rarity = equip_info.get('rarity', 0)

            # Strip tech suffix from name (T0, T1, T2, T3)
            base_name = name
            for suffix in ['T3', 'T2', 'T1', 'T0']:
                if name.endswith(suffix):
                    base_name = name[:-2]
                    break

            if base_name not in equip_data_map:
                equip_data_map[base_name] = {
                    'id': base_id,
                    'name': base_name,
                    'type': equip_type,
                    'nationality': nationality,
                    'sub_equips': []
                }

            equip_data_map[base_name]['sub_equips'].append({
                'tech': tech_level,
                'rarity': rarity,
                'id': int(equip_id)
            })

        # Sort sub_equips by tech level
        for equip in equip_data_map.values():
            equip['sub_equips'].sort(key=lambda x: x['tech'])

        # Equipment type lookup
        equip_type_data = {
            1: "舰炮(驱逐)",
            2: "舰炮(轻巡)",
            3: "舰炮(重巡)",
            4: "舰炮(战列)",
            5: "鱼雷(水面)",
            6: "防空炮(近程)",
            7: "战斗机",
            8: "鱼雷机",
            9: "轰炸机",
            10: "设备(通常)",
            11: "舰炮(大口径重巡)",
            12: "水上机",
            13: "鱼雷(潜艇)",
            14: "设备(反潜)",
            15: "反潜机",
            17: "直升机",
            18: "货物",
            20: "导弹",
            21: "防空炮(远程)",
            101: "通常特殊兵装",
            102: "专属特殊兵装",
        }

        # Generate Lua output
        output_path = os.path.join(self.config.output_directory, '模块_装备数据.lua')
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write('local p = {}\n\n')
            f.write('--------------------------------------------------\n')
            f.write('--\t公开函数\n')
            f.write('--------------------------------------------------\n\n')

            # Write helper function to get equipment ID by name
            f.write('''p['装备ID'] = function(frame)
\tlocal name = frame.args['装备']
\tlocal tech = string.upper(string.sub(name, -2))
\tif tech == 'T0' then
\t\ttech = 0
\telseif tech == 'T1' then
\t\ttech = 1
\telseif tech == 'T2' then
\t\ttech = 2
\telseif tech == 'T3' then
\t\ttech = 3
\telse
\t\ttech = -1
\tend
\tif tech ~= -1 then
\t\tname = string.sub(name, 0, -3)
\tend
\tfor _, item in ipairs(p.equip_data) do
\t\tif item.name == name then
\t\t\tlocal id = item.id
\t\t\tfor _, sub in ipairs(item.sub_equips) do
\t\t\t\tif sub.tech == tech then
\t\t\t\t\tid = sub.id
\t\t\t\tend
\t\t\tend
\t\t\treturn id
\t\tend
\tend
\treturn 99999
end

''')

            # Write equip_data table
            f.write('p.equip_data = {\n')
            for equip in sorted(equip_data_map.values(), key=lambda x: x['id']):
                f.write('{\n')
                f.write(f'\tid = {equip["id"]},\n')
                f.write(f'\tname = "{equip["name"]}",\n')
                f.write(f'\ttype = {equip["type"]},\n')
                f.write(f'\tnationality = {equip["nationality"]},\n')
                f.write('\tsub_equips = {\n')
                for sub in equip['sub_equips']:
                    f.write(f'\t\t{{\ttech = {sub["tech"]}, rarity = {sub["rarity"]}, id = {sub["id"]}\t}};\n')
                f.write('\t}\n')
                f.write('};\n')
            f.write('}\n\n')

            # Write equip_type lookup
            f.write('p.equip_type = {\n')
            for key in sorted(equip_type_data.keys()):
                f.write(f'\t[{key}] = "{equip_type_data[key]}",\n')
            f.write('}\n\n')

            f.write('return p\n')

        print(f"  Generated: {output_path}")
