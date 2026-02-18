# -*- coding: utf-8 -*-
"""Ship statistics generator (from PNData.py)."""
import os
from .base import BaseGenerator
from ..core import parse_data_file, ShipStatsCalculator


class ShipStatsGenerator(BaseGenerator):
    """Generator for ship statistics data."""

    # Re-export calculator constants for backward compatibility
    STATUS_ENUM = ShipStatsCalculator.STATUS_ENUM
    STATUS_INVERSE = ShipStatsCalculator.STATUS_INVERSE

    def generate(self):
        """Generate ship statistics files."""
        # Load all required data
        group = self._get_ship_group()
        statistics = self._get_ship_statistics()
        template = self._get_ship_template()
        strengthen = self._get_ship_strengthen()
        ship_trans = self._get_ship_trans()
        transform_template = self._get_transform_template()
        blueprint_data = self._get_ship_data_blueprint()
        blueprint_strengthen = self._get_ship_strengthen_blueprint()
        meta_strengthen = self._get_ship_strengthen_meta()
        meta_repair = self._get_ship_meta_repair()
        meta_repair_effect = self._get_ship_meta_repair_effect()

        # Get ship data
        data = self._get_data(group, statistics, template, strengthen, ship_trans, transform_template)
        self._modify_tech_data(data, blueprint_data, blueprint_strengthen)
        self._modify_meta_data(data, meta_strengthen, meta_repair, meta_repair_effect)

        # Sort data
        data.sort(key=lambda ship: ship['wikiID'] + str(ship['breakout']))

        # Write output files
        self._write_pn_file(data)
        self._write_csv_files(data)

    def _get_ship_group(self):
        return parse_data_file('ship_data_group', config=self.config)

    def _get_ship_statistics(self):
        return parse_data_file('ship_data_statistics', config=self.config)

    def _get_ship_template(self):
        return parse_data_file('ship_data_template', config=self.config)

    def _get_ship_strengthen(self):
        return parse_data_file('ship_data_strengthen', config=self.config)

    def _get_ship_trans(self):
        return parse_data_file('ship_data_trans', config=self.config)

    def _get_transform_template(self):
        return parse_data_file('transform_data_template', config=self.config)

    def _get_ship_strengthen_blueprint(self):
        return parse_data_file('ship_strengthen_blueprint', config=self.config)

    def _get_ship_data_blueprint(self):
        return parse_data_file('ship_data_blueprint', config=self.config)

    def _get_ship_strengthen_meta(self):
        return parse_data_file('ship_strengthen_meta', config=self.config)

    def _get_ship_meta_repair(self):
        return parse_data_file('ship_meta_repair', config=self.config)

    def _get_ship_meta_repair_effect(self):
        return parse_data_file('ship_meta_repair_effect', config=self.config)

    def _get_wiki_id(self, ship_id):
        """Get wiki ID from ship ID."""
        wiki_id = '%03d' % (ship_id % 10000)
        if ship_id < 10000:
            return wiki_id
        elif ship_id < 20000:
            return 'Collab' + wiki_id
        elif ship_id < 30000:
            return 'Plan' + wiki_id
        elif ship_id < 40000:
            return 'META' + wiki_id

    def _ship_transform(self, group, ship_trans, transform_template):
        """Calculate ship transformation bonuses."""
        if group not in ship_trans.keys():
            return None, None

        trans = ship_trans[group]['transform_list']
        trans_list = []
        trans_ship_id = []

        for t1 in trans:
            for t2 in t1:
                data = transform_template[t2[1]]
                for e in data['effect']:
                    for k, v in e.items():
                        trans_list.append({'type': k, 'amount': v})
                for e in data['gear_score']:
                    trans_list.append({'type': 'gearscore', 'amount': e})
                if 'ship_id' in data.keys() and len(data['ship_id']) > 0:
                    if data['ship_id'][0][1] not in trans_ship_id:
                        trans_ship_id.append(data['ship_id'][0][1])

        return self._status_trans_total(trans_list), trans_ship_id

    def _status_trans_total(self, trans_list):
        """Calculate total transformation bonuses."""
        return ShipStatsCalculator.status_list_to_total(trans_list)

    def apply_pr_development_bonus(self, pn, group_id, blueprint_data, blueprint_strengthen, breakout=3):
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
        return ShipStatsCalculator.apply_pr_development_bonus(
            pn, group_id, blueprint_data, blueprint_strengthen, breakout
        )

    def _modify_tech_data(self, data, blueprint_data, blueprint_strengthen):
        """Modify data for PR/DR ships with blueprint strengthening."""
        for ship in data:
            if 20000 < ship['realID'] < 30000:
                group_id = ship['groupID']
                ship['values'] = self.apply_pr_development_bonus(
                    ship['values'], group_id, blueprint_data, blueprint_strengthen, ship['breakout']
                )

    def apply_meta_repair_bonus(self, pn, strengthen_id, meta_strengthen, meta_repair, meta_repair_effect):
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
        return ShipStatsCalculator.apply_meta_repair_bonus(
            pn, strengthen_id, meta_strengthen, meta_repair, meta_repair_effect
        )

    def _modify_meta_data(self, data, meta_strengthen, meta_repair, meta_repair_effect):
        """Modify data for META ships with repair bonuses."""
        for ship in data:
            if 30000 < ship['realID'] < 40000:
                ship['values'] = self.apply_meta_repair_bonus(
                    ship['values'], ship['strengthen'], meta_strengthen, meta_repair, meta_repair_effect
                )

    def _get_data(self, group, statistics, template, strengthen, ship_trans, transform_template, ships=None):
        """Extract ship data for all breakout stages."""
        if not ships:
            ships = {}
            for k, v in group.items():
                if v['code'] < 40000:
                    ships[v['code']] = v['group_type']

        ship_data = []
        for real_id, group_id in ships.items():
            wiki_id = self._get_wiki_id(real_id)
            ship_id = {}

            # Get ship IDs for each rarity/breakout
            for temp_id, v in template.items():
                if v['group_type'] == group_id and temp_id // 10 == group_id:
                    ship_id[3 - (v['star_max'] - v['star'])] = {
                        'id': temp_id,
                        'oil_at_start': v['oil_at_start'],
                        'oil_at_end': v['oil_at_end'],
                        'strengthen_id': v['strengthen_id'],
                        'wikiID': wiki_id,
                        'realID': real_id,
                        'groupID': group_id
                    }

            # Handle transformations/retrofits
            ship_remould, trans_ship_id = self._ship_transform(group_id, ship_trans, transform_template)
            if trans_ship_id:
                self._add_transform_ids(ship_id, trans_ship_id, template, wiki_id, real_id, group_id)

            # Process each breakout stage
            for breakout in range(6):
                if breakout in ship_id.keys():
                    v = ship_id[breakout]
                    v['breakout'] = breakout
                    stat = statistics[v['id']]
                    v['attrs'] = stat['attrs']
                    v['attrs_growth'] = stat['attrs_growth']
                    v['attrs_growth_extra'] = stat['attrs_growth_extra']

                    if v['strengthen_id'] in strengthen.keys():
                        v['strengthen'] = strengthen[v['strengthen_id']]['durability']
                    else:
                        v['strengthen'] = v['strengthen_id']

                    v['name'] = stat['name']
                    v['values'] = [0] * 56

                    # Fill in stat values
                    for i in range(12):
                        v['values'][3 * i] = v['attrs'][i]
                        v['values'][3 * i + 1] = v['attrs_growth'][i]
                        v['values'][3 * i + 2] = v['attrs_growth_extra'][i]

                    if isinstance(v['strengthen'], list):
                        for i in range(5):
                            v['values'][36 + i] = v['strengthen'][i]

                    v['values'][54] = v['oil_at_start']
                    v['values'][55] = v['oil_at_end']

                    if ship_remould:
                        for i in range(13):
                            v['values'][i + 41] += ship_remould[i]

                    ship_data.append(v)

        return ship_data

    def _add_transform_ids(self, ship_id, trans_ship_id, template, wiki_id, real_id, group_id):
        """Add transformation/retrofit ship IDs."""
        if len(trans_ship_id) == 1 and trans_ship_id[0] in template.keys():
            v = template[trans_ship_id[0]]
            ship_id[4] = {
                'id': trans_ship_id[0],
                'oil_at_start': v['oil_at_start'],
                'oil_at_end': v['oil_at_end'],
                'strengthen_id': v['strengthen_id'],
                'wikiID': wiki_id,
                'realID': real_id,
                'groupID': group_id
            }
        elif len(trans_ship_id) == 2:
            if trans_ship_id[0] in template.keys() and trans_ship_id[1] in template.keys():
                v0 = template[trans_ship_id[0]]
                v1 = template[trans_ship_id[1]]
                if v0['type'] == 20:
                    ship_id[4] = self._create_ship_entry(v0, wiki_id, real_id, group_id)
                    ship_id[5] = self._create_ship_entry(v1, wiki_id, real_id, group_id)
                else:
                    ship_id[4] = self._create_ship_entry(v1, wiki_id, real_id, group_id)
                    ship_id[5] = self._create_ship_entry(v0, wiki_id, real_id, group_id)

    def _create_ship_entry(self, template_data, wiki_id, real_id, group_id):
        """Create a ship entry dictionary."""
        return {
            'id': template_data['id'],
            'oil_at_start': template_data['oil_at_start'],
            'oil_at_end': template_data['oil_at_end'],
            'strengthen_id': template_data['strengthen_id'],
            'wikiID': wiki_id,
            'realID': real_id,
            'groupID': group_id
        }

    def _format_data(self, wiki_id, values, name, breakout):
        """Format ship data as PN string."""
        if wiki_id in ['001', '002', '003']:
            breakout = 0
        key = 'PN' + wiki_id
        if breakout == 4:
            key += 'g3'
        elif breakout == 5:
            key += 'g3m'
        else:
            key += str(breakout)

        output = key + ":["
        for v in values:
            output += str(v) + ','
        output = output[:-1] + '],\t//' + name + '_'

        if breakout >= 4:
            output += '3'
        else:
            output += str(breakout)
        output += '破'
        return output

    def _write_pn_file(self, data):
        """Write PN.txt file with ship stat arrays."""
        filepath = os.path.join(self.config.output_directory, 'PN.txt')
        with open(filepath, 'w+', encoding='utf-8') as f:
            for ship in data:
                line = self._format_data(ship['wikiID'], ship['values'], ship['name'], ship['breakout'])
                f.write(line + '\n')

    def _write_csv_files(self, data):
        """Write CSV files with level 120 and 125 stats."""
        filepath120 = os.path.join(self.config.output_directory, 'ship120data.csv')
        filepath125 = os.path.join(self.config.output_directory, 'ship125data.csv')

        with open(filepath120, 'w+', encoding='gbk') as f1, \
             open(filepath125, 'w+', encoding='gbk') as f2:

            header = "舰船,耐久,炮击,雷击,防空,航空,装填,射程,命中,机动,航速,幸运,反潜\n"
            f1.write(header)
            f2.write(header)

            for ship in data:
                is_meta = 'META' in ship['name']
                if ship['breakout'] == 3:
                    ship120 = self._calculate_stats(ship['values'], is_meta=is_meta, level=120, remould=False)
                    ship125 = self._calculate_stats(ship['values'], is_meta=is_meta, level=125, remould=False)
                    self._write_csv_line(f1, ship['name'], ship120)
                    self._write_csv_line(f2, ship['name'], ship125)
                elif ship['breakout'] == 4:
                    ship120 = self._calculate_stats(ship['values'], is_meta=False, level=120, remould=True)
                    ship125 = self._calculate_stats(ship['values'], is_meta=False, level=125, remould=True)
                    self._write_csv_line(f1, ship['name'], ship120)
                    self._write_csv_line(f2, ship['name'], ship125)
                elif ship['breakout'] == 5:
                    ship120 = self._calculate_stats(ship['values'], is_meta=False, level=120, remould=True)
                    ship125 = self._calculate_stats(ship['values'], is_meta=False, level=125, remould=True)
                    self._write_csv_line(f1, ship['name'] + '(主力)', ship120)
                    self._write_csv_line(f2, ship['name'] + '(主力)', ship125)

    def _write_csv_line(self, file, name, stats):
        """Write a single CSV line."""
        line = name + ',' + ','.join(str(s) for s in stats[:12]) + '\n'
        file.write(line)

    def _calculate_stats(self, pn, strengthen=True, level=125, intimacy=1.06, remould=True, is_meta=False):
        """Calculate final ship stats at given level."""
        return ShipStatsCalculator.calculate_stats(
            pn, strengthen=strengthen, level=level, intimacy=intimacy,
            remould=remould, is_meta=is_meta
        )
