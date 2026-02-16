# Azur Lane Wiki Utilities

## Project Overview

This project provides Python utilities for maintaining the Azur Lane CN Wiki. It processes game data from the [AzurLaneData](https://github.com/AzurLaneTools/AzurLaneData) repository and generates wiki-formatted content for various game elements including ship statistics, memories/stories, and chapter awards.

## Project Structure

```
AzurLaneWikiUtilities/
├── src/
│   └── azurlane_wiki/          # Main package
│       ├── __init__.py
│       ├── config.py            # Configuration management
│       ├── cli.py               # Command-line interface
│       ├── core/                # Core utilities
│       │   ├── __init__.py
│       │   ├── data_loader.py   # Data parsing and loading
│       │   ├── name_resolver.py # Name resolution utilities
│       │   └── file_utils.py    # File utility functions
│       └── generators/          # Content generators
│           ├── __init__.py
│           ├── base.py          # Base generator class
│           ├── memory.py        # Memory/story generator
│           ├── ship_stats.py   # Ship statistics generator
│           ├── chapter_awards.py # Chapter awards generator
│           ├── ship_index.py    # Ship index generator
│           └── juus_names.py    # Juus names generator
├── scripts/                     # Helper scripts
│   ├── generate_all.py         # Main generation script
│   ├── clean_output.py         # Clean output directory
│   └── update_data.py          # Update git submodule
├── Wiki/                        # Generated wiki content (tracked in git)
│   ├── memories/               # Generated memory/story pages
│   ├── chapterAwards/          # Generated chapter award information
│   ├── PN.txt                  # Ship statistics data
│   ├── ship120data.csv         # Level 120 ship statistics
│   ├── ship125data.csv         # Level 125 ship statistics
│   ├── nameIndex.txt           # Ship name index
│   └── JuusNames.txt           # Juus social media names
├── AzurLaneData/               # Git submodule containing game data
│   ├── CN/                     # Chinese game data
│   ├── JP/                     # Japanese game data
│   ├── EN/                     # English game data
│   ├── KR/                     # Korean game data
│   └── TW/                     # Traditional Chinese game data
├── .gitignore
├── README.md
├── CLAUDE.md
├── LICENSE
├── requirements.txt            # Python dependencies
└── setup.py                    # Package setup script
```

## Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/AzurLaneWikiUtilities.git
cd AzurLaneWikiUtilities

# Initialize submodule
git submodule init
git submodule update

# Install dependencies
pip install -r requirements.txt

# Or install as a package
pip install -e .
```

### Basic Usage

```bash
# Generate all wiki content for CN region
python scripts/generate_all.py

# Generate for specific region
python scripts/generate_all.py --region JP

# Generate specific content type
python scripts/generate_all.py --generator memory

# Clean output directory before generation
python scripts/clean_output.py

# Update game data submodule
python scripts/update_data.py
```

### Using the CLI

After installing the package, you can use the CLI command:

```bash
# Generate all content
azurlane-wiki

# Generate specific content for specific region
azurlane-wiki --region EN --generator stats
```

## Architecture

### Configuration Management

The `Config` class (in [config.py](src/azurlane_wiki/config.py)) manages all configuration:

```python
from azurlane_wiki import Config

# Create config for specific region
config = Config(region='JP')

# Access paths
print(config.data_directory)      # Path to game data
print(config.output_directory)    # Path to output

# Change region
config.set_region('EN')
```

### Core Modules

#### data_loader.py
Handles all data loading and parsing:
- `load_json_file()` - Load cached JSON data
- `save_json_file()` - Save data to JSON cache
- `parse_data_file()` - Parse game data files
- `get_chapter_template()` - Get chapter template data

#### name_resolver.py
Resolves ship names and handles name codes:
- `get_ship_name()` - Get ship name from skin ID
- `get_ship_type()` - Get ship type from ship ID
- `parse_name_code()` - Replace `{namecode:123}` placeholders
- `get_name_code()` - Get name code dictionary

#### file_utils.py
File utility functions:
- `sanitize_filename()` - Convert special characters for safe filenames

### Generators

All generators inherit from `BaseGenerator` and implement the `generate()` method.

#### MemoryGenerator
Generates wiki pages for game memories/stories:
- Processes story scripts from memory and world templates
- Handles dialogue, character names, and branching choices
- Outputs wiki-formatted text with collapsible panels
- Supports all 5 regions: CN, JP, EN, KR, TW

```python
from azurlane_wiki import MemoryGenerator, Config

config = Config(region='CN')
generator = MemoryGenerator(config)
generator.generate()

# Generate for all regions
for region in ['CN', 'JP', 'EN', 'KR', 'TW']:
    generator.generate(region=region)
```

#### ShipStatsGenerator
Calculates ship statistics at various levels and breakout stages:
- Processes base stats, growth rates, and strengthening bonuses
- Handles retrofit (remould) modifications
- Calculates stats for regular ships, PR ships, and META ships
- Generates PN.txt (stat arrays) and CSV files (level 120/125 stats)

```python
from azurlane_wiki import ShipStatsGenerator, Config

config = Config(region='CN')
generator = ShipStatsGenerator(config)
generator.generate()
```

#### ChapterAwardsGenerator
Generates chapter drop information:
- Lists ships that drop from each chapter
- Organizes by ship type (destroyer, cruiser, battleship, etc.)
- Categorizes chapters (main story, hard mode, events, archives)

#### ShipIndexGenerator
Creates an index of all ship names with their IDs.

#### JuusNamesGenerator
Generates Juus social media names for ships.

## Common Workflows

### Generating All Wiki Content

```bash
# Update the data submodule
python scripts/update_data.py

# Clean old output
python scripts/clean_output.py

# Generate all content
python scripts/generate_all.py
```

### Generating Content for Specific Region

```bash
# Generate memories for Japanese version
python scripts/generate_all.py --region JP --generator memory
```

### Using as a Library

```python
from azurlane_wiki import Config, MemoryGenerator, ShipStatsGenerator

# Create config
config = Config(region='CN')

# Generate memories
memory_gen = MemoryGenerator(config)
memory_gen.generate()

# Generate ship stats
stats_gen = ShipStatsGenerator(config)
stats_gen.generate()
```

## Key Concepts

### Data Sources
- **AzurLaneData**: Git submodule containing raw game data extracted from the game client
- Data is organized by region: CN, JP, EN, KR, TW
- Raw data is in JSON format, stored in `sharecfg/`, `sharecfgdata/`, `GameCfg/`, and `ShareCfg/` directories

### Data Processing Flow
1. Parse JSON files from AzurLaneData using `data_loader`
2. Process and calculate derived values (e.g., ship stats at different levels)
3. Generate wiki-formatted output

### Multi-region Support
- **CN** uses full name code parsing with the name code dictionary
- **JP/EN/KR/TW** use simplified versions (no name code dictionary needed)
- Story files: CN uses 'story', JP uses 'storyjp', others use 'story'

### Ship ID Conventions
Real ID ranges indicate ship categories:
- **1-9999**: Normal ships (Wiki ID: `001`-`999`)
- **10000-19999**: Collab ships (Wiki ID: `Collab001`-`Collab999`)
- **20000-29999**: PR ships (Wiki ID: `Plan001`-`Plan999`)
- **30000-39999**: META ships (Wiki ID: `META001`-`META999`)

## Output Formats

### Memory Pages (output/memories/)
Wiki markup with collapsible panels:
```
== Title ==
{{折叠面板|开始}}
{{折叠面板|标题=Memory Title|选项=1|主框=1|样式=primary|展开=是}}
<span style="color:#3498DB;" class="shikikanname">指挥官</span>：<br>
Dialogue text<br>
{{折叠面板|内容结束}}
{{折叠面板|结束}}
```

### Ship Statistics (output/PN.txt)
Format: `PN123:[stats array], //ShipName_XBreak`
- Each ship has entries for breakout stages 0-3 (sometimes 4-5 for retrofits)
- 56-value arrays: base, growth, growth_extra for each stat (12 stats × 3) + strengthen + remould + oil

### CSV Files (output/ship120data.csv, ship125data.csv)
Level 120 and 125 final stats in CSV format:
```
舰船,耐久,炮击,雷击,防空,航空,装填,射程,命中,机动,航速,幸运,反潜
ShipName,1234,567,890,...
```

### Chapter Awards (output/chapterAwards/)
Organized by category folders with drop information:
```
MapName
ChapterName-StageName
|掉落驱逐=ShipA、ShipB
|掉落轻巡=ShipC、ShipD
```

## Development Notes

### Adding a New Generator

1. Create a new file in `src/azurlane_wiki/generators/`
2. Inherit from `BaseGenerator`
3. Implement the `generate()` method
4. Add to `generators/__init__.py`
5. Update CLI in `cli.py`

Example:
```python
# src/azurlane_wiki/generators/my_generator.py
from .base import BaseGenerator
from ..core import parse_data_file

class MyGenerator(BaseGenerator):
    def generate(self):
        # Load data
        data = parse_data_file('some_data', config=self.config)

        # Process and generate output
        # ...
```

### Color Mapping for Character Names
```python
COLOR_DICT = {
    '#a9f548': '#4eb24e',  # Green
    '#ffff4d': '#ffd000',  # Yellow
    '#ff5c5c': '#ec5d53',  # Red
    '#ffa500': '#ff9900'   # Orange
}
```

### Stat Calculation Notes
- **Affinity bonus** (intimacy): multiply stats by 1.06 (except speed/luck/range)
- **Strengthening**: scales with level for regular ships, flat bonus for META
- **Retrofit** (remould): flat bonuses, no scaling
- **Level 100+**: uses different growth rate multiplier

### Wiki Template Usage
- Commander name: `<span class="shikikanname">指挥官</span>` (special CSS class)
- Auto-formatting names: `{{AF|ShipName}}` for automatic ship page linking
- Nowiki for tildes: `<nowiki>~~~</nowiki>` to prevent wiki signature

## Troubleshooting

### "未找到actor{ID}名称" Error
- Ship actor ID not found in skin templates
- Check if ship exists in that region's data
- Some ships are region-exclusive

### Missing Story Files
- Verify AzurLaneData submodule is up to date: `python scripts/update_data.py`
- Check if story exists in the JSON files
- Some events may not have story data extracted yet

### Import Errors
After reorganization, if you encounter import errors:
```bash
# Reinstall the package
pip install -e .
```

### Encoding Issues
- Source files use UTF-8 encoding
- CSV output uses GBK for Excel compatibility in Chinese locale
- File paths with Chinese characters work on Windows with proper encoding

## Git Workflow

### Before Making Changes
```bash
# Update data submodule
python scripts/update_data.py

# Create a new branch for changes
git checkout -b feature/your-feature-name
```

### Committing Changes
- **Wiki/ directory IS tracked** - Contains generated output for public consumption
- Commit source code changes with clear messages
- Update this CLAUDE.md if adding new features or changing workflows
- GitHub Actions automatically generates and commits Wiki/ content

### Current Branch
- Main branch: `master`

## Dependencies

### Python Requirements
- **Python 3.7+**
- **GitPython** - Used by Summary.py for git operations (optional)

### Installing Dependencies
```bash
pip install -r requirements.txt
```

### Git Submodule
```bash
# Initialize submodule
git submodule init
git submodule update

# Update to latest
python scripts/update_data.py
# or
git submodule update --remote AzurLaneData
```

## Legacy Files (Deprecated)

The following files in the project root are deprecated and replaced by the new package structure:
- `util.py` → Refactored into `src/azurlane_wiki/core/`
- `Memory.py` → Refactored into `src/azurlane_wiki/generators/memory.py`
- `PNData.py` → Refactored into `src/azurlane_wiki/generators/ship_stats.py`
- `ChapterAwards.py` → Refactored into `src/azurlane_wiki/generators/chapter_awards.py`
- `ShipIndex.py` → Refactored into `src/azurlane_wiki/generators/ship_index.py`
- `JuusNames.py` → Refactored into `src/azurlane_wiki/generators/juus_names.py`
- `Initialize.py` → Refactored into `scripts/clean_output.py`
- `Summary.py` → Functionality available through git commands

These files can be removed once you verify the new structure works correctly.

## Migration Guide

If you have existing code using the old structure:

### Old Way
```python
import util
import Memory

util.DataDirectory = 'AzurLaneData/JP'
Memory.MemoryJP()
```

### New Way
```python
from azurlane_wiki import Config, MemoryGenerator

config = Config(region='JP')
generator = MemoryGenerator(config)
generator.generate()
```

## Future Enhancements

Potential improvements to consider:
- Progress indicators for long-running operations
- Diff detection to only regenerate changed content
- Validation for generated wiki markup
- Parallel processing for multi-region generation
- Web interface for browsing generated content
- CI/CD integration for automated generation
