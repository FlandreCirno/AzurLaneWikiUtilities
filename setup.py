# -*- coding: utf-8 -*-
"""Setup script for Azur Lane Wiki Utilities."""
from setuptools import setup, find_packages
from pathlib import Path

# Read README
readme_file = Path(__file__).parent / 'README.md'
if readme_file.exists():
    long_description = readme_file.read_text(encoding='utf-8')
else:
    long_description = 'Tools for maintaining Azur Lane CN Wiki'

setup(
    name='azurlane-wiki-utilities',
    version='2.0.0',
    author='Your Name',
    description='Tools for maintaining Azur Lane CN Wiki based on data from AzurLaneData',
    long_description=long_description,
    long_description_content_type='text/markdown',
    url='https://github.com/yourusername/AzurLaneWikiUtilities',
    package_dir={'': 'src'},
    packages=find_packages(where='src'),
    python_requires='>=3.7',
    install_requires=[
        'GitPython>=3.1.0',
    ],
    entry_points={
        'console_scripts': [
            'azurlane-wiki=azurlane_wiki.cli:main',
        ],
    },
    classifiers=[
        'Development Status :: 4 - Beta',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
    ],
    license='MIT',
)
