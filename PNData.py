# -*- coding: utf-8 -*-
import re, os
import util

STATUSENUM = {'durability': 0, 'cannon': 1, 'torpedo': 2, 'antiaircraft': 3, 'air': 4, 'reload': 5, 'range': 6, 'hit': 7, 'dodge': 8, 'speed': 9, 'luck': 10, 'antisub': 11, 'gearscore': 12}
STATUSINVERSE = ['durability', 'cannon', 'torpedo', 'antiaircraft', 'air', 'reload', 'range', 'hit', 'dodge', 'speed', 'luck', 'antisub', 'gearscore']

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

def getShipStrengthenBlueprint():
    return util.parseDataFile('ship_strengthen_blueprint')
    
def getShipDataBlueprint():
    return util.parseDataFile('ship_data_blueprint')
    
def getShipStrengthenMeta():
    return util.parseDataFile('ship_strengthen_meta')
    
def getShipMetaRepair():
    return util.parseDataFile('ship_meta_repair')
    
def getShipMetaRepairEffect():
    return util.parseDataFile('ship_meta_repair_effect')

def getWikiID(id):
    wikiID = '%03d' % (id % 10000)
    if id < 10000:
        return wikiID
    elif id < 20000:
        return 'Collab' + wikiID
    elif id < 30000:
        return 'Plan' + wikiID
    elif id < 40000:
        return 'META' + wikiID

def shipTransform(group, shipTrans, transformTemplate):
    if group in shipTrans.keys():
        trans = shipTrans[group]
        trans = trans['transform_list']
        transList = []
        transShipID = []
        for t1 in trans:
            for t2 in t1:
                data = transformTemplate[t2[1]]
                for e in data['effect']:
                    for k, v in e.items():
                        transList.append({'type': k, 'amount': v})
                for e in data['gear_score']:
                    transList.append({'type': 'gearscore', 'amount': e})
                if 'ship_id' in data.keys() and len(data['ship_id']) > 0:
                    if not data['ship_id'][0][1] in transShipID:
                        transShipID.append(data['ship_id'][0][1])
        return (statusTransTotal(transList), transShipID)
    else:
        return None, None
        
def statusTransTotal(transList):
    total = [0] * 13
    for t in transList:
        if t['type'] in STATUSENUM.keys():
            total[STATUSENUM[t['type']]] += t['amount']
    return total

def modifyTechData(data, blueprintData, blueprintStrengthen):
    for ship in data:
        if ship['realID'] > 20000 and ship['realID'] < 30000:
            groupID = ship['groupID']
            blueprintStrengthenID = blueprintData[groupID]['strengthen_effect']
            strengthenList = []
            for i in range(0, min(30, ship['breakout']*10)):
                if 'effect_attr' in blueprintStrengthen[blueprintStrengthenID[i]].keys() \
                            and blueprintStrengthen[blueprintStrengthenID[i]]['effect_attr']:
                    for effect in blueprintStrengthen[blueprintStrengthenID[i]]['effect_attr']:
                        strengthenList.append({'type': effect[0], 'amount': effect[1]*100})
                for j in range(5):
                    strengthenList.append({'type': STATUSINVERSE[j+1], 'amount': blueprintStrengthen[blueprintStrengthenID[i]]['effect'][j]})
            strengthenTotal = statusTransTotal(strengthenList)
            for i in range(12):
                ship['values'][3*i] += strengthenTotal[i]//100
            for i in range(36, 41):
                ship['values'][i] = 0

def modifyMetaData(data, metaStrengthen, metaRepair, metaRepairEffect):
    for ship in data:
        if ship['realID'] > 30000 and ship['realID'] < 40000:
            strengthenData = metaStrengthen[ship['strengthen']]
            strengthenList = []
            for s, i in STATUSENUM.items():
                if "repair_"+s in strengthenData.keys():
                    l = strengthenData["repair_"+s]
                    for repair in l:
                        attr = metaRepair[repair]["effect_attr"]
                        strengthenList.append({'type': attr[0], 'amount': attr[1]})
            for repair in strengthenData['repair_effect']:
                effect = metaRepairEffect[repair[1]]
                for attr in effect["effect_attr"]:
                    strengthenList.append({'type': attr[0], 'amount': attr[1]})
            strengthenTotal = statusTransTotal(strengthenList)
            for i in range(12):
                ship['values'][41+i] += strengthenTotal[i]
        
def getData(group, statistics, template, strengthen, shipTrans, transformTemplate, ships = None): 
    if not ships:
        ships = {}
        for k, v in group.items():
            if v['code'] < 40000:
                ships[v['code']] = v['group_type']
    shipData = []
    for realID, groupID in ships.items():
        id = getWikiID(realID)
        shipID = {}
        for tempID, v in template.items():
            if v['group_type'] == groupID and tempID // 10 == groupID :
                shipID[3 - (v['star_max'] - v['star'])] = {'id':tempID, 'oil_at_start':v['oil_at_start'], 
                'oil_at_end':v['oil_at_end'], 'strengthen_id':v['strengthen_id'], 'wikiID': id, 'realID': realID, 'groupID': groupID}
        shipRemould, transShipID = shipTransform(groupID, shipTrans, transformTemplate)
        if transShipID:
            if len(transShipID) == 1 and transShipID[0] in template.keys():
                v = template[transShipID[0]]
                shipID[4] = {'id':transShipID[0], 'oil_at_start':v['oil_at_start'], 
                    'oil_at_end':v['oil_at_end'], 'strengthen_id':v['strengthen_id'], 'wikiID':id, 'realID': realID, 'groupID': groupID}
            elif len(transShipID) == 2 and transShipID[0] in template.keys() and transShipID[1] in template.keys():
                v = template[transShipID[0]]
                if v['type'] == 20:
                    shipID[4] = {'id':transShipID[0], 'oil_at_start':v['oil_at_start'], 
                        'oil_at_end':v['oil_at_end'], 'strengthen_id':v['strengthen_id'], 'wikiID':id, 'realID': realID, 'groupID': groupID}
                    v = template[transShipID[1]]
                    shipID[5] = {'id':transShipID[1], 'oil_at_start':v['oil_at_start'], 
                        'oil_at_end':v['oil_at_end'], 'strengthen_id':v['strengthen_id'], 'wikiID':id, 'realID': realID, 'groupID': groupID}
                else:
                    v = template[transShipID[1]]
                    shipID[4] = {'id':transShipID[1], 'oil_at_start':v['oil_at_start'], 
                        'oil_at_end':v['oil_at_end'], 'strengthen_id':v['strengthen_id'], 'wikiID':id, 'realID': realID, 'groupID': groupID}
                    v = template[transShipID[0]]
                    shipID[5] = {'id':transShipID[0], 'oil_at_start':v['oil_at_start'], 
                        'oil_at_end':v['oil_at_end'], 'strengthen_id':v['strengthen_id'], 'wikiID':id, 'realID': realID, 'groupID': groupID}
                    
                
        for breakout in range(6):
            if breakout in shipID.keys():
                v = shipID[breakout]
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
                v['values'] = [0]*56
                for i in range(12):
                    v['values'][3*i] = v['attrs'][i]
                    v['values'][3*i+1] = v['attrs_growth'][i]
                    v['values'][3*i+2] = v['attrs_growth_extra'][i]
                if isinstance(v['strengthen'], list):
                    for i in range(5):
                        v['values'][36+i] = v['strengthen'][i]
                v['values'][54] = v['oil_at_start']
                v['values'][55] = v['oil_at_end']
                if shipRemould:
                    for i in range(13):
                        v['values'][i+41] += shipRemould[i]
                shipData.append(v)
    return shipData

def formatData(ID, values, name, breakout):
    if ID in ['001', '002', '003']:
        breakout = 0
    output = 'PN' + ID
    if breakout == 4:
        output += 'g3:['
    elif breakout == 5:
        output += 'g3m:['
    else:
        output += str(breakout) + ':['
    for v in values:
        output += str(v) + ','
    output = output[:-1] + '],\t//' + name + '_'
    if breakout >= 4:
        output += '3'
    else:
        output += str(breakout)
    output += '破'
    return output

if __name__ == "__main__":
    f = open(os.path.join(util.WikiDirectory, 'PN.txt'), 'w+', encoding = 'utf-8')
    group = getShipGroup()
    statistics = getShipStatistics()
    template = getShipTemplate()
    strengthen = getShipStrengthen()
    shipTrans = getShipTrans()
    transformTemplate = getTransformTemplage()
    blueprintData = getShipDataBlueprint()
    blueprintStrengthen = getShipStrengthenBlueprint()
    metaStrengthen = getShipStrengthenMeta()
    metaRepair = getShipMetaRepair()
    metaRepairEffect = getShipMetaRepairEffect()
    data = getData(group, statistics, template, strengthen, shipTrans, transformTemplate)
    modifyTechData(data, blueprintData, blueprintStrengthen)
    modifyMetaData(data, metaStrengthen, metaRepair, metaRepairEffect)
    def func(ship):
        return ship['wikiID'] + str(ship['breakout'])
    data.sort(key = func)
    for ship in data:
        f.write(formatData(ship['wikiID'], ship['values'], ship['name'], ship['breakout']))
        f.write('\n')
    f.close()
