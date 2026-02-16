# -*- coding: utf-8 -*-
"""Name resolution utilities."""
import re
from .data_loader import parse_data_file


def get_ship_name(skin_id, skin_template, ship_statistics, group_id=None):
    """Get ship name from skin ID.

    Args:
        skin_id: Ship skin ID
        skin_template: Ship skin template data
        ship_statistics: Ship statistics data
        group_id: Ship group ID (optional)

    Returns:
        Ship name as string, or None if not found
    """
    if skin_id in skin_template.keys():
        if not group_id:
            group_id = skin_template[skin_id]['ship_group']
        for k, v in skin_template.items():
            if group_id == v['ship_group'] and v['group_index'] == 0:
                return v['name']
    else:
        group_id = skin_id // 10
        for k, v in ship_statistics.items():
            if skin_id == v['skin_id']:
                return v['name']
        for k, v in ship_statistics.items():
            if group_id == v['id'] // 10:
                return v['name']
    return None


def get_ship_type(ship_id, ship_template, group_id=None):
    """Get ship type from ship ID.

    Args:
        ship_id: Ship ID
        ship_template: Ship template data
        group_id: Ship group ID (optional)

    Returns:
        Ship type as integer
    """
    if not group_id:
        group_id = ship_template[ship_id]['group_type']
    for k, v in ship_template.items():
        if group_id == v['group_type']:
            return v['type']
    return ship_template[ship_id]['type']


def parse_name_code(text, name_code, af=False):
    """Parse name code placeholders in text.

    Args:
        text: Text containing {namecode:123} placeholders
        name_code: Dictionary mapping name code IDs to names
        af: If True, wrap names in {{AF|name}} template

    Returns:
        Text with placeholders replaced
    """
    def parse_func(matchobj):
        id_num = int(matchobj.group(1))
        if id_num in name_code.keys():
            name = name_code[id_num]
            if af:
                return '{{AF|' + name + '}}'
            else:
                return name
        else:
            return matchobj.group(0)

    return re.sub(r'\{namecode:(\d+)(:.*?)?\}', parse_func, text)


def get_name_code(config=None):
    """Get name code dictionary.

    Args:
        config: Config instance (uses default if None)

    Returns:
        Dictionary mapping name code IDs to names
    """
    content = parse_data_file('name_code', config=config)
    if isinstance(content, dict):
        content = content.values()
    output = {}
    for i in content:
        output[i['id']] = i['name']
    return output
