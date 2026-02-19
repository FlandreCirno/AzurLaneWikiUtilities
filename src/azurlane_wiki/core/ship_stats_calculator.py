# -*- coding: utf-8 -*-
"""Ship statistics calculation utilities.

This module provides reusable functions for calculating ship stats at various levels,
applying bonuses from PR development, META repair, retrofits, etc.
"""
from typing import List, Dict, Optional, Any


class ShipStatsCalculator:
    """Calculator for ship statistics with various bonuses and modifiers.

    All methods are static and can be called without instantiation.
    This class serves as a namespace for ship statistics calculations.
    """

    # Status enumeration for mapping stat names to indices
    STATUS_ENUM: Dict[str, int] = {
        'durability': 0, 'cannon': 1, 'torpedo': 2, 'antiaircraft': 3,
        'air': 4, 'reload': 5, 'range': 6, 'hit': 7, 'dodge': 8,
        'speed': 9, 'luck': 10, 'antisub': 11, 'gearscore': 12
    }

    # Inverse mapping for indices to stat names
    STATUS_INVERSE: List[str] = [
        'durability', 'cannon', 'torpedo', 'antiaircraft', 'air', 'reload',
        'range', 'hit', 'dodge', 'speed', 'luck', 'antisub', 'gearscore'
    ]

    @staticmethod
    def build_pn_array(
        attrs: List[int],
        attrs_growth: List[int],
        attrs_growth_extra: List[int],
        strengthen_values: Optional[List[int]] = None,
        oil_at_start: int = 0,
        oil_at_end: int = 0,
        remould_bonuses: Optional[List[int]] = None
    ) -> List[int]:
        """Build a 56-element PN array from ship statistics.

        Args:
            attrs: Base attributes [durability, cannon, torpedo, ...] (12 values)
            attrs_growth: Growth values for level 1-100 (12 values)
            attrs_growth_extra: Extra growth for level 100+ (12 values)
            strengthen_values: Strengthening bonuses [cannon, torpedo, AA, air, reload] (5 values)
            oil_at_start: Base oil consumption
            oil_at_end: Oil consumption growth
            remould_bonuses: Retrofit/remould bonuses (13 values)

        Returns:
            List of 56 values representing the ship's PN array
        """
        pn = [0] * 56

        # Fill base stats, growth, and extra growth (indices 0-35)
        for i in range(12):
            pn[3 * i] = attrs[i] if i < len(attrs) else 0
            pn[3 * i + 1] = attrs_growth[i] if i < len(attrs_growth) else 0
            pn[3 * i + 2] = attrs_growth_extra[i] if i < len(attrs_growth_extra) else 0

        # Fill strengthen bonuses (indices 36-40)
        if strengthen_values:
            for i in range(min(5, len(strengthen_values))):
                pn[36 + i] = strengthen_values[i]

        # Fill remould bonuses (indices 41-53)
        if remould_bonuses:
            for i in range(min(13, len(remould_bonuses))):
                pn[41 + i] = remould_bonuses[i]

        # Fill oil consumption (indices 54-55)
        pn[54] = oil_at_start
        pn[55] = oil_at_end

        return pn

    @staticmethod
    def status_list_to_total(status_list: List[Dict[str, Any]]) -> List[int]:
        """Convert a list of status modifications to total bonuses.

        Args:
            status_list: List of dicts with 'type' (stat name) and 'amount' (bonus value)

        Returns:
            List of 13 total bonuses (one per stat)
        """
        total = [0] * 13
        for item in status_list:
            stat_type = item.get('type')
            if stat_type in ShipStatsCalculator.STATUS_ENUM:
                idx = ShipStatsCalculator.STATUS_ENUM[stat_type]
                total[idx] += item.get('amount', 0)
        return total

    @staticmethod
    def apply_pr_development_bonus(
        pn: List[int],
        group_id: int,
        blueprint_data: Dict[int, Any],
        blueprint_strengthen: Dict[int, Any],
        breakout: int = 3
    ) -> List[int]:
        """Apply PR/DR ship development bonuses to PN array.

        Args:
            pn: PN array (56 values)
            group_id: Ship group ID (group_type, not code)
            blueprint_data: Blueprint data dict
            blueprint_strengthen: Blueprint strengthen data dict
            breakout: Breakout level (3 for max)

        Returns:
            Modified PN array with development bonuses applied
        """
        if group_id not in blueprint_data:
            return pn

        blueprint_strengthen_id = blueprint_data[group_id]['strengthen_effect']
        strengthen_list = []

        for i in range(0, min(30, breakout * 10)):
            if i < len(blueprint_strengthen_id):
                bp_id = blueprint_strengthen_id[i]
                if bp_id in blueprint_strengthen:
                    # Add attribute bonuses (effect_attr)
                    if ('effect_attr' in blueprint_strengthen[bp_id] and
                            blueprint_strengthen[bp_id]['effect_attr']):
                        for effect in blueprint_strengthen[bp_id]['effect_attr']:
                            strengthen_list.append({'type': effect[0], 'amount': effect[1] * 100})

                    # Add direct stat bonuses (effect)
                    if 'effect' in blueprint_strengthen[bp_id]:
                        for j in range(5):
                            if j < len(blueprint_strengthen[bp_id]['effect']):
                                strengthen_list.append({
                                    'type': ShipStatsCalculator.STATUS_INVERSE[j + 1],
                                    'amount': blueprint_strengthen[bp_id]['effect'][j]
                                })

        strengthen_total = ShipStatsCalculator.status_list_to_total(strengthen_list)

        # Apply bonuses to base stats
        pn_modified = pn.copy()
        for i in range(12):
            pn_modified[3 * i] += strengthen_total[i] // 100

        # Zero out regular strengthen bonuses for PR ships (they use development bonuses instead)
        for i in range(36, 41):
            pn_modified[i] = 0

        return pn_modified

    @staticmethod
    def apply_meta_repair_bonus(
        pn: List[int],
        strengthen_id: int,
        meta_strengthen: Dict[int, Any],
        meta_repair: Dict[int, Any],
        meta_repair_effect: Dict[int, Any]
    ) -> List[int]:
        """Apply META ship repair/sync bonuses to PN array.

        Args:
            pn: PN array (56 values)
            strengthen_id: Strengthen ID from template
            meta_strengthen: META strengthen data dict
            meta_repair: META repair data dict
            meta_repair_effect: META repair effect data dict

        Returns:
            Modified PN array with repair bonuses applied
        """
        if strengthen_id not in meta_strengthen:
            return pn

        strengthen_data = meta_strengthen[strengthen_id]
        strengthen_list = []

        # Collect bonuses from repair levels (repair_air, repair_reload, etc.)
        for stat_name, stat_idx in ShipStatsCalculator.STATUS_ENUM.items():
            repair_key = "repair_" + stat_name
            if repair_key in strengthen_data:
                for repair_id in strengthen_data[repair_key]:
                    if repair_id in meta_repair:
                        attr = meta_repair[repair_id]["effect_attr"]
                        strengthen_list.append({'type': attr[0], 'amount': attr[1]})

        # Add milestone bonuses from repair_effect
        if 'repair_effect' in strengthen_data:
            for repair in strengthen_data['repair_effect']:
                if repair[1] in meta_repair_effect:
                    effect = meta_repair_effect[repair[1]]
                    for attr in effect["effect_attr"]:
                        strengthen_list.append({'type': attr[0], 'amount': attr[1]})

        strengthen_total = ShipStatsCalculator.status_list_to_total(strengthen_list)

        # Apply bonuses to remould stats (indices 41-52)
        pn_modified = pn.copy()
        for i in range(12):
            pn_modified[41 + i] += strengthen_total[i]

        return pn_modified

    @staticmethod
    def get_pr_equipment_proficiency_bonus(
        group_id: int,
        blueprint_data: Dict[int, Any],
        blueprint_strengthen: Dict[int, Any],
        equip_types: List[List[int]],
        max_dev_level: int = 30
    ) -> List[float]:
        """Calculate PR ship equipment proficiency bonuses from development.

        Args:
            group_id: Ship group ID (group_type, not code)
            blueprint_data: Blueprint data dict
            blueprint_strengthen: Blueprint strengthen data dict
            equip_types: List of equipment type lists for each slot (not actually used, kept for API compatibility)
            max_dev_level: Maximum development level (default 30)

        Returns:
            List of 3 proficiency bonuses (decimal) for each slot

        Important:
            The "type" value in effect_equipment_proficiency[0] refers to SLOT POSITION, not equipment type ID!
            This is a different numbering system from the equipment types in ship_data_template.

            Blueprint "type" mapping:
            - Type 1 = Slot 1 (equip_1) - Usually the main gun slot
            - Type 2 = Slot 2 (equip_2) - Usually secondary weapon or torpedoes
            - Type 3 = Slot 3 (equip_3) - Usually AA gun or auxiliary

            Example (Azuma):
            - Blueprint Type 1 → Slot 1 (which uses equipment types [3, 11] = CA guns)
            - Blueprint Type 3 → Slot 3 (which uses equipment type [6] = AA guns)

            Do NOT confuse this with equipment type IDs (1=DD gun, 3=CA gun, 6=AA gun, etc.)!
            Do NOT use 900xxx simulation templates - they have bonuses pre-applied!
        """
        if group_id not in blueprint_data:
            return [0.0, 0.0, 0.0]

        strengthen_ids = blueprint_data[group_id].get('strengthen_effect', [])

        # Collect bonuses by slot position (blueprint "type" = slot index + 1)
        slot_bonuses = [0.0, 0.0, 0.0]

        for i in range(min(max_dev_level, len(strengthen_ids))):
            strengthen_id = strengthen_ids[i]
            if strengthen_id in blueprint_strengthen:
                effect_equipment = blueprint_strengthen[strengthen_id].get('effect_equipment_proficiency', [])
                if effect_equipment and len(effect_equipment) >= 2:
                    slot_type = effect_equipment[0]  # Slot position indicator (1, 2, or 3)
                    bonus = effect_equipment[1]  # Bonus value (e.g., 0.05 for 5%)
                    # Convert 1-indexed slot type to 0-indexed slot position
                    slot_idx = slot_type - 1
                    if 0 <= slot_idx < 3:
                        slot_bonuses[slot_idx] += bonus

        return slot_bonuses

    @staticmethod
    def get_pr_max_luck(
        group_id: int,
        blueprint_data: Dict[int, Any],
        blueprint_strengthen: Dict[int, Any]
    ) -> int:
        """Calculate PR ship maximum luck from blueprint development.

        Args:
            group_id: Ship group ID (group_type, not code)
            blueprint_data: Blueprint data dict
            blueprint_strengthen: Blueprint strengthen data dict

        Returns:
            Total luck bonus from all development levels
        """
        if group_id not in blueprint_data:
            return 0

        strengthen_ids = blueprint_data[group_id].get('strengthen_effect', [])
        total_luck = 0

        # Check luck bonuses in the strengthen_effect list
        for strengthen_id in strengthen_ids:
            if strengthen_id in blueprint_strengthen:
                effect_attr = blueprint_strengthen[strengthen_id].get('effect_attr', [])
                # effect_attr format: [["stat_name", value]]
                if effect_attr and len(effect_attr) > 0:
                    for attr in effect_attr:
                        if isinstance(attr, list) and len(attr) >= 2 and attr[0] == 'luck':
                            total_luck += attr[1]

        # Luck bonuses are typically in IDs beyond the strengthen_effect list (levels 31-35)
        # Check 5 consecutive IDs after the last strengthen_effect ID
        if strengthen_ids:
            last_id = strengthen_ids[-1]
            for i in range(1, 6):  # Check IDs last_id+1 through last_id+5
                strengthen_id = last_id + i
                if strengthen_id in blueprint_strengthen:
                    effect_attr = blueprint_strengthen[strengthen_id].get('effect_attr', [])
                    if effect_attr and len(effect_attr) > 0:
                        for attr in effect_attr:
                            if isinstance(attr, list) and len(attr) >= 2 and attr[0] == 'luck':
                                total_luck += attr[1]

        return total_luck

    @staticmethod
    def get_meta_repair_totals(
        strengthen_id: int,
        meta_strengthen: Dict[int, Any],
        meta_repair: Dict[int, Any],
        meta_repair_effect: Dict[int, Any]
    ) -> Dict[str, int]:
        """Calculate total META repair/sync bonuses as a dict.

        Args:
            strengthen_id: Strengthen ID from template
            meta_strengthen: META strengthen data dict
            meta_repair: META repair data dict
            meta_repair_effect: META repair effect data dict

        Returns:
            Dict mapping stat names to total bonus values
        """
        if strengthen_id not in meta_strengthen:
            return {stat: 0 for stat in ShipStatsCalculator.STATUS_ENUM.keys()}

        strengthen_data = meta_strengthen[strengthen_id]
        strengthen_list = []

        # Collect bonuses from repair levels
        for stat_name in ShipStatsCalculator.STATUS_ENUM.keys():
            repair_key = "repair_" + stat_name
            if repair_key in strengthen_data:
                for repair_id in strengthen_data[repair_key]:
                    if repair_id in meta_repair:
                        attr = meta_repair[repair_id]["effect_attr"]
                        strengthen_list.append({'type': attr[0], 'amount': attr[1]})

        # Add milestone bonuses
        if 'repair_effect' in strengthen_data:
            for repair in strengthen_data['repair_effect']:
                if repair[1] in meta_repair_effect:
                    effect = meta_repair_effect[repair[1]]
                    for attr in effect["effect_attr"]:
                        strengthen_list.append({'type': attr[0], 'amount': attr[1]})

        # Calculate totals as dict
        totals = {stat: 0 for stat in ShipStatsCalculator.STATUS_ENUM.keys()}
        for item in strengthen_list:
            if item['type'] in totals:
                totals[item['type']] += item['amount']

        return totals

    @staticmethod
    def calculate_stats(
        pn: List[int],
        strengthen: bool = True,
        level: int = 125,
        intimacy: float = 1.06,
        remould: bool = True,
        is_meta: bool = False
    ) -> List[float]:
        """Calculate final ship stats at given level.

        Args:
            pn: PN array (56 values)
            strengthen: Whether to apply strengthening bonuses
            level: Target level (1-125)
            intimacy: Intimacy multiplier (1.06 for 100 affinity, 1.0 for none)
            remould: Whether to apply retrofit/remould bonuses
            is_meta: Whether this is a META ship (affects strengthen/remould handling)

        Returns:
            List of 13 calculated stats [durability, cannon, torpedo, ..., oil]
        """
        # Initialize remould bonuses (no intimacy applied yet)
        if remould and not is_meta:
            remould_values = pn[41:54]
        else:
            remould_values = [0] * 13

        # Initialize strengthen bonuses
        if strengthen:
            if is_meta:
                # META ships: use strengthen values directly, remould values are repair bonuses
                strengthen_values = pn[36:41]
                remould_values = pn[41:54]
            else:
                # Regular ships: strengthen scales with level (30% at level 1, 100% at level 100)
                strengthen_values = [
                    int(pn[36 + i] * (min(level, 100) / 100 * 0.7 + 0.3))
                    for i in range(5)
                ]
        else:
            strengthen_values = [0] * 5
            if is_meta:
                remould_values = [0] * 13

        # Calculate base stats WITHOUT intimacy first
        stats = []

        # Durability (no strengthen)
        stats.append(
            pn[0] + pn[1] * (level - 1) / 1000 + pn[2] * (max(level, 100) - 100) / 1000
            + remould_values[0]
        )

        # Cannon
        stats.append(
            pn[3] + pn[4] * (level - 1) / 1000 + strengthen_values[0] + pn[5] * (max(level, 100) - 100) / 1000
            + remould_values[1]
        )

        # Torpedo
        stats.append(
            pn[6] + pn[7] * (level - 1) / 1000 + strengthen_values[1] + pn[8] * (max(level, 100) - 100) / 1000
            + remould_values[2]
        )

        # Antiaircraft
        stats.append(
            pn[9] + pn[10] * (level - 1) / 1000 + strengthen_values[2] + pn[11] * (max(level, 100) - 100) / 1000
            + remould_values[3]
        )

        # Air
        stats.append(
            pn[12] + pn[13] * (level - 1) / 1000 + strengthen_values[3] + pn[14] * (max(level, 100) - 100) / 1000
            + remould_values[4]
        )

        # Reload
        stats.append(
            pn[15] + pn[16] * (level - 1) / 1000 + strengthen_values[4] + pn[17] * (max(level, 100) - 100) / 1000
            + remould_values[5]
        )

        # Range (no strengthen)
        stats.append(
            pn[18] + pn[19] * (level - 1) / 1000 + pn[20] * (max(level, 100) - 100) / 1000
            + remould_values[6]
        )

        # Hit
        stats.append(
            pn[21] + pn[22] * (level - 1) / 1000 + pn[23] * (max(level, 100) - 100) / 1000
            + remould_values[7]
        )

        # Dodge
        stats.append(
            pn[24] + pn[25] * (level - 1) / 1000 + pn[26] * (max(level, 100) - 100) / 1000
            + remould_values[8]
        )

        # Speed
        stats.append(
            pn[27] + pn[28] * (level - 1) / 1000 + pn[29] * (max(level, 100) - 100) / 1000
            + remould_values[9]
        )

        # Luck
        stats.append(
            pn[30] + pn[31] * (level - 1) / 1000 + pn[32] * (max(level, 100) - 100) / 1000
            + remould_values[10]
        )

        # Antisub
        stats.append(
            pn[33] + pn[34] * (level - 1) / 1000 + pn[35] * (max(level, 100) - 100) / 1000
            + remould_values[11]
        )

        # Oil consumption (no intimacy)
        stats.append(pn[54] + pn[55] * (0.5 + min(level, 99) * 0.005))

        # Apply intimacy at the END to avoid rounding errors
        # Intimacy affects: durability, cannon, torpedo, AA, air, reload, hit, dodge, antisub
        # Does NOT affect: range, speed, luck, oil
        intimacy_indices = [0, 1, 2, 3, 4, 5, 7, 8, 11]
        for i in intimacy_indices:
            stats[i] *= intimacy

        return stats
