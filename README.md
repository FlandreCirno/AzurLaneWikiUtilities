# AzurLaneWikiUtilities

Tools for maintaining Azur Lane CN Wiki based on data from [AzurLaneTools/AzurLaneData](https://github.com/AzurLaneTools/AzurLaneData)

## Features

- **Memory/Story Generator**: Generate wiki pages for game memories and stories
- **Ship Statistics Calculator**: Calculate ship stats at various levels (120, 125) and breakout stages
- **Chapter Awards Generator**: Generate chapter drop information
- **Ship Index Generator**: Create index of all ship names
- **Character Page Generator**: Generate wiki page stubs for all ships (843 ships)
- **Wiki Modules Generator**: Generate Lua data modules (模块:舰娘数据, 模块:装备数据) with 770 equipment and 843 ships
- **Multi-region Support**: CN, JP, EN, KR, TW

## Quick Start

### Installation

```bash
# Clone the repository with submodules
git clone --recurse-submodules https://github.com/yourusername/AzurLaneWikiUtilities.git
cd AzurLaneWikiUtilities

# Install dependencies
pip install -r requirements.txt

# Or install as a package
pip install -e .
```

### Usage

```bash
# Generate all wiki content
python scripts/generate_all.py

# Generate for specific region
python scripts/generate_all.py --region JP

# Generate specific content type
python scripts/generate_all.py --generator memory

# Clean output before generation
python scripts/clean_output.py

# Update game data
python scripts/update_data.py
```

### Using as Library

```python
from azurlane_wiki import Config, MemoryGenerator, ShipStatsGenerator, WikiModulesGenerator

# Create config
config = Config(region='CN')

# Generate memories
memory_gen = MemoryGenerator(config)
memory_gen.generate()

# Generate ship stats
stats_gen = ShipStatsGenerator(config)
stats_gen.generate()

# Generate wiki modules
wiki_modules_gen = WikiModulesGenerator(config)
wiki_modules_gen.generate()  # Generates both ship and equipment modules
```

## Project Structure

```
AzurLaneWikiUtilities/
├── src/azurlane_wiki/      # Main package
│   ├── core/               # Core utilities
│   └── generators/         # Content generators
├── scripts/                # Helper scripts
├── Wiki/                   # Generated wiki content (tracked in git)
└── AzurLaneData/          # Game data (git submodule)
```

## Documentation

See [CLAUDE.md](CLAUDE.md) for comprehensive documentation including:
- Detailed architecture
- Generator documentation
- API reference
- Development guide
- Troubleshooting

## Requirements

- Python 3.7+
- GitPython (optional, for git operations)

## License

[MIT License](LICENSE)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Acknowledgments

- Game data from [AzurLaneTools/AzurLaneData](https://github.com/AzurLaneTools/AzurLaneData)
