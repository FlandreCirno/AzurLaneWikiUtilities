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
# Clone the repository with submodules (AzurLaneData, the JSON dumps)
git clone --recurse-submodules https://github.com/yourusername/AzurLaneWikiUtilities.git
cd AzurLaneWikiUtilities

# Fetch the Lua configuration the wiki is generated from.
# The upstream is 2.7 GB, so only the ~130 MB per region that is actually read
# is pulled, via a blobless sparse clone.
python scripts/fetch_lua_data.py

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

## Data Sources

The generators read the **Lua sources** by default and fall back to the JSON
dumps for whatever the Lua sources do not ship:

| Source | Repo | Layout |
|---|---|---|
| Lua sources (default) | [AzurLaneLuaScripts](https://github.com/AzurLaneTools/AzurLaneLuaScripts) | `<region>/{sharecfgdata,sharecfg,gamecfg}/<table>.lua` |
| JSON dumps (fallback) | [AzurLaneData](https://github.com/AzurLaneTools/AzurLaneData) | `<region>/{sharecfgdata,ShareCfg,GameCfg}/<table>.json` |

`AzurLaneData` is the upstream the project used to depend on, but it stopped
receiving updates in May 2026. `AzurLaneLuaScripts` - the upstream *it* is
generated from - is still refreshed daily, so the wiki is now generated from
that instead.

The upstream is 2.7 GB while only about 130 MB per region is ever read, so
`AzurLaneLuaScripts` is deliberately **not** a submodule: `fetch_lua_data.py`
does a blobless sparse clone (`--filter=blob:none` + `sparse-checkout`) that
downloads the tree structure and then only the blobs that land in the working
tree. `AzurLaneData` stays a submodule and acts as the fallback.

Choose the source explicitly if you need to:

```python
config = Config(region='CN', data_source='auto')  # default: Lua, then JSON
config = Config(region='CN', data_source='lua')   # Lua sources only
config = Config(region='CN', data_source='json')  # JSON dumps only
```

Refresh the data with:

```
python scripts/update_data.py        # both sources
python scripts/update_data.py lua    # Lua sources only
python scripts/update_data.py json   # JSON dumps only
```

Notes on coverage:

- Tables are read from `sharecfgdata/` when present, otherwise `gamecfg/`
  (`dungeon`, `story`) or `sharecfg/`.
- `dungeon` and `story` are shipped as **one file per record**
  (`gamecfg/dungeon/0000000.lua`, each file `return`s its record). They are
  keyed by file stem, so numeric stems become integer keys - the same layout
  the JSON dumps use.
- The Lua sources only ship `dungeon`/`story` for **CN** (EN has `dungeon` but
  not `story`), and they have no `storyjp`. The JSON dumps do carry
  `JP/GameCfg/storyjp.json`, so keep the JSON submodule around if you generate
  JP memories - `data_source='auto'` picks it up automatically.

## Project Structure

```
AzurLaneWikiUtilities/
├── src/azurlane_wiki/      # Main package
│   ├── core/               # Core utilities
│   │   ├── data_loader.py  # reads Lua sources / JSON dumps
│   │   └── lua_parser.py   # minimal Lua config-table parser
│   └── generators/         # Content generators
├── scripts/                # Helper scripts
│   ├── fetch_lua_data.py   # sparse blobless fetch of the Lua sources
│   └── check_data_sources.py  # reports which source a run will read
├── Wiki/                   # Generated wiki content (tracked in git)
├── AzurLaneLuaScripts/     # Game Lua sources (fetched, not a submodule)
└── AzurLaneData/           # Game JSON dumps (git submodule)
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
