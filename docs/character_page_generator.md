# Character Page Generator

## Overview

The Character Page Generator creates wiki page stubs for all ships in Azur Lane with populated data fields. It generates templates for three ship categories:
- **Normal ships** (建造) - Regular buildable ships and collab ships
- **PR/DR ships** (科研) - Priority/Decisive Research ships
- **META ships** (Meta) - META variants

## Usage

### Basic Usage

```bash
# Generate all character pages
python scripts/test_character_page.py
```

### Using as a Library

```python
from azurlane_wiki import Config, CharacterPageGenerator

config = Config(region='CN')
generator = CharacterPageGenerator(config)
generator.generate()
```

## Output Structure

Generated files are organized in `Wiki/character/` with subfolders:
```
Wiki/character/
├── 建造/          # Normal ships (743 files)
├── 科研/          # PR/DR ships (42 files)
└── Meta/          # META ships (56 files)
```

## Features

### Data Populated

The generator automatically populates the following fields:

#### Basic Information
- Name (Chinese, English, Japanese)
- Ship ID (编号)
- Ship type (类型): 驱逐, 轻巡, 重巡, 战列, etc.
- Rarity (稀有度): 普通, 稀有, 精锐, 超稀有, 海上传奇, 决战方案
- Faction (阵营): 白鹰, 皇家, 重樱, 铁血, 东煌, etc.
- Armor type (装甲类型): 轻型, 中型, 重型

#### Statistics
- Initial stats (初始): Level 1 stats from first breakout stage
- Max level stats (满级): Level 120 stats with strengthen and affinity bonuses
- Property hexagon (图鉴): S/A/B/C/D/E ratings for:
  - Durability (耐久)
  - Anti-air (防空)
  - Evasion (机动)
  - Aviation (航空)
  - Torpedo (雷击)
  - Firepower (炮击)
- Speed (航速)
- Luck (幸运)

#### Template Structure
- All required wiki template fields
- Proper categorization by ship type
- Empty fields for manual completion (skills, voices, etc.)

### Duplicate Name Handling

Ships with duplicate names (e.g., multiple ships named "企业") are automatically suffixed with their nation code:
- `企业_USS.txt` (Eagle Union)
- `企业_HMS.txt` (Royal Navy)
- etc.

Nation suffixes:
- USS - 白鹰 (Eagle Union)
- HMS - 皇家 (Royal Navy)
- IJN - 重樱 (Sakura Empire)
- KMS - 铁血 (Iron Blood)
- ROC - 东煌 (Dragon Empery)
- RN - 撒丁帝国 (Sardegna Empire)
- SN - 北方联合 (Northern Parliament)
- FFNF - 自由鸢尾/鸢尾 (Iris/Vichya)
- MNF - 维希教廷 (Vichya Dominion)
- NL - 郁金王国 (Tempesta)

## Stat Calculation

### Initial Stats
Directly extracted from the first breakout stage (3-star) ship data.

### Max Level Stats
Calculated using the following formula for level 120:

```
stat = base + (growth × 119 / 1000) + (growth_extra × 20 / 1000)
```

With additional bonuses:
- **Strengthen bonus**: Scales with level for normal ships, flat for META
- **Affinity bonus**: 6% (1.06 multiplier) for applicable stats
- Applied to: Durability, Firepower, Torpedo, Anti-air, Aviation, Reload, Accuracy, Evasion, ASW
- Not applied to: Speed, Luck, Range

### Property Hexagon Mapping

The game data stores property hexagon in this order:
`[炮击, 雷击, 航空, 机动, 防空, 耐久]`

The generator automatically converts to wiki order:
`[耐久, 防空, 机动, 航空, 雷击, 炮击]`

## Ship Category Determination

Ships are categorized based on their ship code:
- **0-9999**: Normal ships → `建造/`
- **10000-19999**: Collab ships → `建造/`
- **20000-29999**: PR/DR ships → `科研/`
- **30000-39999**: META ships → `Meta/`

## Known Limitations

### Fields Not Auto-Populated

The following fields require manual completion:
- **Skills**: Skill names and descriptions (技能1-4)
- **Breakout effects**: Breakthrough bonuses (突破1-3阶效果)
- **Equipment**: Slot types and efficiencies (装备类型, 效率, etc.)
- **Voice lines**: All character dialogue (台词)
- **Artist/CV**: Illustrator and voice actor information
- **History**: Ship background and history sections
- **Development bonuses**: For PR ships (5级-30级开发加成)

### Stat Discrepancies

Generated max level stats may differ slightly from wiki values due to:
1. Different game versions/data snapshots
2. Additional bonuses not accounted for (e.g., tech points, fleet tech)
3. Rounding differences
4. Unknown bonus calculations for certain ship types

Typical differences are ±5-10 points, which is acceptable for stub generation.

### Known Issues

1. **Nationality mapping**: Some PR ships may show incorrect faction names (e.g., "玛丽亚纳" instead of "郁金王国") due to game data version differences
2. **Equipment data**: Equipment slot information is not yet extracted
3. **Skills**: Skill extraction is not implemented (complex data structure)
4. **Retrofit detection**: Retrofit status is detected but retrofit-specific data is not generated

## Example Output

### Normal Ship (彰武)
```wiki
{{舰娘图鉴
|名称=彰武
|英文名=Chang Wu
|编号=725
|类型=重巡
|稀有度=超稀有
|阵营=东煌
|装甲类型=中型
|初始耐久=835
|初始炮击=35
|初始雷击=56
...
|满级耐久=4793
|满级炮击=190
|满级雷击=299
...
|图鉴耐久=A
|图鉴防空=D
|图鉴机动=C
|图鉴航空=E
|图鉴雷击=C
|图鉴炮击=B
...
}}
```

### PR Ship (金狮)
```wiki
{{舰娘图鉴
|分组=方案
|名称=金狮
|英文名=HNLMS Gouden Leeuw
|编号=042
|类型=重巡
|稀有度=决战方案
|阵营=玛丽亚纳
|其他获取途径=[[开发船坞]]
|耗时=无法建造
|退役收益=无法退役
|营养价值=不可用作强化材料
...
}}
```

### META Ship
```wiki
{{舰娘图鉴
|分组=META
|特殊底色=META超稀有
|名称=皇家方舟·META
|阵营=META-???
|其他获取途径=[[META研究室|META研究室资讯同步]]
|耗时=无法建造
|退役收益=无法退役
...
}}
```

## Future Enhancements

Potential improvements:
- Extract and populate skill data
- Extract equipment slot information
- Add breakout effect descriptions
- Generate retrofit pages separately
- Support for other regions (JP, EN, KR, TW)
- Batch mode for generating specific ships only
- Validation against existing wiki pages
- Auto-fill more static fields (tech points, exp requirements, etc.)

## Troubleshooting

### Encoding Issues
If ship names appear garbled:
- Ensure your terminal supports UTF-8 encoding
- Files are correctly saved with UTF-8 encoding
- Windows users may see `����` in console but files are correct

### Missing Ships
If expected ships are not generated:
- Check if ship code is < 40000 (ships ≥ 40000 are excluded)
- Verify ship exists in your AzurLaneData version
- Check if ship has valid template and statistics data

### Stat Mismatches
If generated stats don't match wiki:
- Verify you're using the latest AzurLaneData
- Check if additional bonuses need to be applied
- Consider wiki values may include tech point bonuses
- Small differences (±10) are normal and acceptable for stubs

## Contributing

To improve the character page generator:
1. Enhance stat calculation accuracy
2. Implement skill data extraction
3. Add equipment slot population
4. Improve nationality mapping for newer ships
5. Add support for retrofit-specific templates
