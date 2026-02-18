# Ship Stats Calculation Refactoring

## Overview

This document describes the refactoring of ship statistics calculation code to improve reusability and reduce code duplication between generators.

## Problem

Previously, ship statistics calculation logic was scattered across multiple files:

1. **`ship_stats.py`**: Contained the core calculation logic, including:
   - PN array manipulation
   - PR ship development bonus application
   - META ship repair bonus application
   - Stat calculation at various levels

2. **`character_page.py`**: Duplicated much of this logic:
   - Used `ShipStatsGenerator` as a helper instance
   - Duplicated `_get_meta_repair_bonuses()` logic
   - Tightly coupled to the generator class

This led to:
- Code duplication
- Maintenance burden (changes needed in multiple places)
- Tight coupling between generators
- Difficulty testing calculation logic independently

## Solution

Created a new **`ShipStatsCalculator`** class in `core/ship_stats_calculator.py` that provides reusable, static methods for all ship stats calculations.

### New Module Structure

```
src/azurlane_wiki/core/
├── ship_stats_calculator.py   # NEW: Reusable calculation logic
├── data_loader.py
├── name_resolver.py
└── file_utils.py
```

### Key Features

The `ShipStatsCalculator` class provides:

1. **Static Constants**:
   - `STATUS_ENUM`: Maps stat names to indices
   - `STATUS_INVERSE`: Maps indices to stat names

2. **Core Methods**:
   - `build_pn_array()`: Builds 56-element PN arrays from ship data
   - `status_list_to_total()`: Converts status modification lists to totals
   - `apply_pr_development_bonus()`: Applies PR/DR development bonuses
   - `apply_meta_repair_bonus()`: Applies META repair/sync bonuses
   - `get_meta_repair_totals()`: Gets META bonuses as a dict
   - `calculate_stats()`: Calculates final stats at any level with all modifiers

### Changes to Existing Files

#### 1. `ship_stats.py` (ShipStatsGenerator)

**Before**: Contained ~100 lines of calculation logic

**After**: Delegates to `ShipStatsCalculator`
- Re-exports constants for backward compatibility
- Wraps calculator methods with instance methods
- Focuses on file I/O and data loading

```python
# Before
def _calculate_stats(self, pn, ...):
    # 50+ lines of calculation logic
    ...

# After
def _calculate_stats(self, pn, ...):
    return ShipStatsCalculator.calculate_stats(pn, ...)
```

#### 2. `character_page.py` (CharacterPageGenerator)

**Before**: Used `ShipStatsGenerator` as helper, duplicated logic

**After**: Uses `ShipStatsCalculator` directly
- Removed `self.stats_generator` dependency
- Added `_get_wiki_id()` method (no longer needs generator)
- Simplified `_calculate_max_level_stats()`
- Removed duplicate `_get_meta_repair_bonuses()` implementation

```python
# Before
def __init__(self, config=None):
    super().__init__(config)
    self.stats_generator = ShipStatsGenerator(config)

# After
def __init__(self, config=None):
    super().__init__(config)
```

#### 3. `core/__init__.py`

**Before**: Exported data loaders and name resolvers

**After**: Also exports `ShipStatsCalculator`

```python
from .ship_stats_calculator import ShipStatsCalculator

__all__ = [
    # ... existing exports ...
    'ShipStatsCalculator',
]
```

## Benefits

1. **Single Source of Truth**: All calculation logic in one place
2. **Reusability**: Any generator can use the calculator
3. **Testability**: Static methods are easy to unit test
4. **Maintainability**: Changes only needed in one location
5. **Loose Coupling**: Generators no longer depend on each other
6. **Backward Compatibility**: Existing code continues to work

## Usage Examples

### Basic Stat Calculation

```python
from azurlane_wiki.core import ShipStatsCalculator

# Build PN array
pn = ShipStatsCalculator.build_pn_array(
    attrs=[1000, 50, 60, ...],           # Base stats
    attrs_growth=[100, 20, 30, ...],      # Growth per level
    attrs_growth_extra=[50, 10, 15, ...], # Extra growth 100+
    strengthen_values=[10, 15, 20, 25, 30],
    oil_at_start=2,
    oil_at_end=10
)

# Calculate stats at level 125
stats = ShipStatsCalculator.calculate_stats(
    pn, strengthen=True, level=125, intimacy=1.06
)
```

### PR Ship Development Bonuses

```python
# Apply PR development bonuses
pn_with_dev = ShipStatsCalculator.apply_pr_development_bonus(
    pn, group_id=10910, blueprint_data, blueprint_strengthen, breakout=3
)

# Calculate with development bonuses
stats = ShipStatsCalculator.calculate_stats(
    pn_with_dev, strengthen=False, level=125
)
```

### META Ship Repair Bonuses

```python
# Apply META repair bonuses
pn_with_repair = ShipStatsCalculator.apply_meta_repair_bonus(
    pn, strengthen_id, meta_strengthen, meta_repair, meta_repair_effect
)

# Calculate META ship stats
stats = ShipStatsCalculator.calculate_stats(
    pn_with_repair, strengthen=True, level=125, is_meta=True
)

# Or get totals as dict
totals = ShipStatsCalculator.get_meta_repair_totals(
    strengthen_id, meta_strengthen, meta_repair, meta_repair_effect
)
# Returns: {'durability': 500, 'cannon': 50, 'torpedo': 0, ...}
```

## Migration Guide

If you have custom code using the old structure:

### Old Way
```python
from azurlane_wiki.generators.ship_stats import ShipStatsGenerator

generator = ShipStatsGenerator(config)
pn = [...]  # Build manually
pn_modified = generator.apply_pr_development_bonus(pn, ...)
```

### New Way
```python
from azurlane_wiki.core import ShipStatsCalculator

pn = ShipStatsCalculator.build_pn_array(...)
pn_modified = ShipStatsCalculator.apply_pr_development_bonus(pn, ...)
```

## Testing

The calculator can be easily tested independently:

```python
import unittest
from azurlane_wiki.core import ShipStatsCalculator

class TestShipStatsCalculator(unittest.TestCase):
    def test_build_pn_array(self):
        pn = ShipStatsCalculator.build_pn_array(
            attrs=[100, 10, 20, 30, 0, 50, 60, 70, 80, 25, 50, 60],
            attrs_growth=[...],
            attrs_growth_extra=[...]
        )
        self.assertEqual(len(pn), 56)
        self.assertEqual(pn[0], 100)  # durability

    def test_calculate_stats(self):
        pn = [...]  # Test data
        stats = ShipStatsCalculator.calculate_stats(pn, level=100)
        self.assertEqual(len(stats), 13)
```

## Code Quality

The `ShipStatsCalculator` follows modern Python best practices:

1. **Type Hints**: Full type annotations using `typing` module
   - Better IDE autocomplete and error detection
   - Self-documenting code
   - Easier to maintain and refactor

2. **Static Methods**: All methods are `@staticmethod`
   - No hidden state or side effects
   - Pure functions for predictable behavior
   - Easy to test and reason about

3. **Naming Conventions**:
   - Class: `PascalCase` ✓
   - Methods: `snake_case` ✓
   - Constants: `UPPER_CASE` ✓
   - Parameters: `snake_case` ✓

4. **Documentation**: Comprehensive docstrings with Args/Returns
   - Google-style docstrings
   - Type information in both hints and docs

## Future Enhancements

Potential improvements:
1. Add validation for PN array structure
2. Create builder pattern for complex configurations
3. Add caching for expensive calculations
4. Support batch calculations for multiple ships

## Files Changed

- **Created**: `src/azurlane_wiki/core/ship_stats_calculator.py` (new)
- **Modified**: `src/azurlane_wiki/core/__init__.py`
- **Modified**: `src/azurlane_wiki/generators/ship_stats.py`
- **Modified**: `src/azurlane_wiki/generators/character_page.py`
- **Created**: `docs/ship_stats_refactoring.md` (this file)

## Backward Compatibility

All existing code continues to work:
- `ShipStatsGenerator` methods still exist (now delegate to calculator)
- Method signatures unchanged
- Constants re-exported from calculator

No breaking changes for existing users of the library.
