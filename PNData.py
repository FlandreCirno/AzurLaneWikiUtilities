# -*- coding: utf-8 -*-
import re, os
from slpp import slpp
import util

STATUSENUM = {'durability': 0, 'cannon': 1, 'torpedo': 2, 'antiaircraft': 3, 'air': 4, 'reload': 5, 'range': 6, 'hit': 7, 'dodge': 8, 'speed': 9, 'luck': 10, 'antisub': 11}

def getShipGroup():
    return util.parseDataFile('ship_data_group')
    
def getShipStatistics():
    return util.parseDataFile('ship_data_statistics')
    
def getShipTemplate():
    return util.parseDataFile('ship_data_template')

def getShipStrengthen():
    return util.parseDataFile('ship_data_strengthen')
    
def getShipTrans():
    return util.parseDataFile('ship_data_trans')
    
def getTransformTemplage():
    return util.parseDataFile('transform_data_template')

def getWikiID(id):
    wikiID = '%03d' % (id % 10000)
    if id < 10000:
        return wikiID
    elif id > 10000:
        return 'Collab' + wikiID
    elif id > 20000:
        return 'Plan' + wikiID
    elif id > 30000:
        return 'Meta' + wikiID

def shipTransform(group, shipTrans, transformTemplate):
    if group in shipTrans.keys():
        trans = shipTrans[group]
        trans = trans['transform_list']
        transList = []
        for t1 in trans:
            for t2 in t1:
                effect = transformTemplate[t2[1]]['effect']
                for e in effect:
                    for k, v in e.items():
                        transList.append({'type': k, 'amount': v})
        return statusTransTotal(transList)
    else:
        return None
        
def statusTransTotal(transList):
    total = [0] * 12
    for t in transList:
        if t['type'] in STATUSENUM.keys():
            total[STATUSENUM[t['type']]] += t['amount']
    return total

def getData(ships = None): 
    group = getShipGroup()
    statistics = getShipStatistics()
    template = getShipTemplate()
    strengthen = getShipStrengthen()
    shipTrans = getShipTrans()
    transformTemplate = getTransformTemplage()
    if not ships:
        ships = {}
        for k, v in group.items():
            ships[v['code']] = v['group_type']
    shipData = []
    for realID, groupID in ships.items():
        if realID < 20000:
            id = getWikiID(realID)
            shipID = {}
            for tempID, v in template.items():
                if v['group_type'] == groupID and tempID // 10 == groupID :
                    shipID[3 - (v['star_max'] - v['star'])] = {'id':tempID, 'oil_at_start':v['oil_at_start'], 
                    'oil_at_end':v['oil_at_end'], 'strengthen_id':v['strengthen_id'], 'wikiID':id}
            for breakout in range(4):
                if breakout in shipID.keys():
                    v = shipID[breakout]
                    v['breakout'] = breakout
                    stat = statistics[v['id']]
                    v['attrs'] = stat['attrs']
                    v['attrs_growth'] = stat['attrs_growth']
                    v['attrs_growth_extra'] = stat['attrs_growth_extra']
                    v['strengthen'] = strengthen[v['strengthen_id']]['durability']
                    name = stat['name']
                    v['values'] = [0]*56
                    for i in range(12):
                        v['values'][3*i] = v['attrs'][i]
                        v['values'][3*i+1] = v['attrs_growth'][i]
                        v['values'][3*i+2] = v['attrs_growth_extra'][i]
                    for i in range(5):
                        v['values'][36+i] = v['strengthen'][i]
                    v['values'][54] = v['oil_at_start']
                    v['values'][55] = v['oil_at_end']
                    shipRemould = shipTransform(groupID, shipTrans, transformTemplate)
                    if shipRemould:
                        for i in range(12):
                            v['values'][i+41] += shipRemould[i]
                    v['format'] = formatData(id, v['values'], name, breakout)
                    shipData.append(v)
    return shipData

def formatData(ID, values, name, breakout):
    if ID in ['001', '002', '003']:
        breakout = 0
    output = 'PN' + ID + str(breakout) + ':['
    for v in values:
        output += str(v) + ','
    output = output[:-1] + '],\t//' + name + str(breakout) + '破'
    return output

if __name__ == "__main__":
    f = open(os.path.join(util.WikiDirectory, 'PN.txt'), 'w+', encoding = 'utf-8')
    data = getData()
    def func(ship):
        return ship['wikiID'] + str(ship['breakout'])
    data.sort(key = func)
    for ship in data:
        f.write(ship['format'])
        f.write('\n')
    f.close()
