# -*- coding: utf-8 -*-
"""File utility functions."""


def sanitize_filename(file_name):
    """Sanitize filename by replacing special characters.

    Args:
        file_name: Original filename

    Returns:
        Sanitized filename safe for Windows filesystems
    """
    char_set = [
        [':', '：'],
        ['?', '？'],
        ['"', '“'],
        ['.', '。'],
        ['<', '《'],
        ['>', '》']
    ]
    for char_pair in char_set:
        file_name = file_name.replace(char_pair[0], char_pair[1])
    return file_name
