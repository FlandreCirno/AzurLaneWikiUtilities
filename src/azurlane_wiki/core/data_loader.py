# -*- coding: utf-8 -*-
"""Data loading and parsing utilities."""
import os
import json
import re
from ..config import get_config


def save_json_file(data, file_name, config=None):
    """Save data to JSON file.

    Args:
        data: Data to save
        file_name: Name of the file (without .json extension)
        config: Config instance (uses default if None)
    """
    if config is None:
        config = get_config()

    file_path = os.path.join(config.json_directory, file_name + '.json')
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, sort_keys=True, indent=4, separators=(',', ': '))


def load_json_file(file_name, config=None):
    """Load data from JSON file.

    Args:
        file_name: Name of the file (without .json extension)
        config: Config instance (uses default if None)

    Returns:
        Parsed JSON data as dictionary
    """
    if config is None:
        config = get_config()

    file_name_data = os.path.join(config.json_directory, 'sharecfgdata', file_name + '.json')
    file_name_game = os.path.join(config.json_directory, 'GameCfg', file_name + '.json')
    file_name_share = os.path.join(config.json_directory, 'ShareCfg', file_name + '.json')

    if os.path.isfile(file_name_data):
        if os.path.isfile(file_name_share):
            if os.path.getsize(file_name_share) > os.path.getsize(file_name_data):
                with open(file_name_share, 'r+', encoding='utf-8') as f:
                    content = json.load(f)
                    _clean_metadata(content)
                    return _parse_json(content)
            else:
                with open(file_name_data, 'r+', encoding='utf-8') as f:
                    content = json.load(f)
                    _clean_metadata(content)
                    return _parse_json(content)
    elif file_name in config.gamecfg_list:
        with open(file_name_game, 'r+', encoding='utf-8') as f:
            content = json.load(f)
            _clean_metadata(content)
            return _parse_json(content)
    else:
        with open(file_name_share, 'r+', encoding='utf-8') as f:
            content = json.load(f)
            _clean_metadata(content)
            return _parse_json(content)


def _clean_metadata(content):
    """Remove metadata keys from content dictionary."""
    if 'all' in content.keys():
        del content['all']
    if 'get_id_list_by_group_type' in content.keys():
        del content['get_id_list_by_group_type']


def _parse_json(data):
    """Recursively parse JSON data, converting string keys to integers where possible.

    Args:
        data: JSON data to parse

    Returns:
        Parsed data with integer keys where applicable
    """
    if isinstance(data, dict):
        output = {}
        for k, v in data.items():
            if isinstance(k, str) and k.isdigit():
                output[int(k)] = _parse_json(v)
            else:
                output[k] = _parse_json(v)
    elif isinstance(data, list):
        output = []
        for i in data:
            output.append(_parse_json(i))
    else:
        output = data
    return output


def has_json_file(file_name, config=None):
    """Check if JSON file exists.

    Args:
        file_name: Name of the file (without .json extension)
        config: Config instance (uses default if None)

    Returns:
        True (always returns True for now)
    """
    return True


def parse_data_file(file_name, file_path='sharecfg', mode=0, config=None):
    """Parse data file (Lua or JSON).

    Args:
        file_name: Name of the file
        file_path: Relative path to the file
        mode: 0 for single file, 1 for sublist directory
        config: Config instance (uses default if None)

    Returns:
        Parsed data as dictionary
    """
    if config is None:
        config = get_config()

    if has_json_file(file_name, config):
        return load_json_file(file_name, config)
    else:
        # Lua parsing would go here if needed in the future
        # For now, just return empty dict since we always have JSON
        return {}


def get_chapter_template(file_name='chapter_template', file_path='sharecfg', config=None):
    """Get chapter template data.

    Args:
        file_name: Name of the chapter template file
        file_path: Relative path to the file
        config: Config instance (uses default if None)

    Returns:
        Chapter template data as dictionary
    """
    if config is None:
        config = get_config()

    if has_json_file(file_name, config):
        return load_json_file(file_name, config)
    else:
        # Lua parsing for chapter template would go here if needed
        return {}
