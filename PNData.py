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
    key = 'PN' + ID
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

def calculateStats(PN, strengthen=True, breakout="3", PNlevel=125, PNintimacy=1.06, remould=True, isMETA=False):
    if remould and not isMETA:
        PNdurabilityremould=PN[41]
        PNcannonremould=PN[42]
        PNtorpedoremould=PN[43]
        PNantiaircraftremould=PN[44]
        PNairremould=PN[45]
        PNreloadremould=PN[46]
        PNrangeremould=PN[47]
        PNhitremould=PN[48]
        PNdodgeremould=PN[49]
        PNspeedremould=PN[50]
        PNluckremould=PN[51]
        PNantisubremould=PN[52]
        PNsynthesizepowerremould=PN[53]
    else:
        PNdurabilityremould=0
        PNcannonremould=0
        PNtorpedoremould=0
        PNantiaircraftremould=0
        PNairremould=0
        PNreloadremould=0
        PNrangeremould=0
        PNhitremould=0
        PNdodgeremould=0
        PNspeedremould=0
        PNluckremould=0
        PNantisubremould=0
        PNsynthesizepowerremould=0
    if strengthen:
        if isMETA:
            PNcannonstrengthen=PN[36]
            PNtorpedostrengthen=PN[37]
            PNantiaircraftstrengthen=PN[38]
            PNairstrengthen=PN[39]
            PNreloadstrengthen=PN[40]
            PNdurabilityremould=PN[41]*PNintimacy
            PNcannonremould=PN[42]*PNintimacy
            PNtorpedoremould=PN[43]*PNintimacy
            PNantiaircraftremould=PN[44]*PNintimacy
            PNairremould=PN[45]*PNintimacy
            PNreloadremould=PN[46]*PNintimacy
            PNrangeremould=PN[47]*PNintimacy
            PNhitremould=PN[48]*PNintimacy
            PNdodgeremould=PN[49]*PNintimacy
            PNspeedremould=PN[50]
            PNluckremould=PN[51]
            PNantisubremould=PN[52]*PNintimacy
            PNsynthesizepowerremould=PN[53]
        
        else:
            PNcannonstrengthen=int(PN[36]*(min(PNlevel,100)/100*0.7+0.3))
            PNtorpedostrengthen=int(PN[37]*(min(PNlevel,100)/100*0.7+0.3))
            PNantiaircraftstrengthen=int(PN[38]*(min(PNlevel,100)/100*0.7+0.3))
            PNairstrengthen=int(PN[39]*(min(PNlevel,100)/100*0.7+0.3))
            PNreloadstrengthen=int(PN[40]*(min(PNlevel,100)/100*0.7+0.3))
        
    
    else:
        PNcannonstrengthen=0
        PNtorpedostrengthen=0
        PNantiaircraftstrengthen=0
        PNairstrengthen=0
        PNreloadstrengthen=0
        if isMETA:
            PNdurabilityremould=0
            PNcannonremould=0
            PNtorpedoremould=0
            PNantiaircraftremould=0
            PNairremould=0
            PNreloadremould=0
            PNrangeremould=0
            PNhitremould=0
            PNdodgeremould=0
            PNspeedremould=0
            PNluckremould=0
            PNantisubremould=0
            PNsynthesizepowerremould=0
    PNdurability=(PN[0]+PN[1]*(PNlevel-1)/1000+PN[2]*(max(PNlevel,100)-100)/1000)*PNintimacy+PNdurabilityremould
    PNcannon=(PN[3]+PN[4]*(PNlevel-1)/1000+PNcannonstrengthen+PN[5]*(max(PNlevel,100)-100)/1000)*PNintimacy+PNcannonremould
    PNtorpedo=(PN[6]+PN[7]*(PNlevel-1)/1000+PNtorpedostrengthen+PN[8]*(max(PNlevel,100)-100)/1000)*PNintimacy+PNtorpedoremould
    PNantiaircraft=(PN[9]+PN[10]*(PNlevel-1)/1000+PNantiaircraftstrengthen+PN[11]*(max(PNlevel,100)-100)/1000)*PNintimacy+PNantiaircraftremould
    PNair=(PN[12]+PN[13]*(PNlevel-1)/1000+PNairstrengthen+PN[14]*(max(PNlevel,100)-100)/1000)*PNintimacy+PNairremould
    PNreload=(PN[15]+PN[16]*(PNlevel-1)/1000+PNreloadstrengthen+PN[17]*(max(PNlevel,100)-100)/1000)*PNintimacy+PNreloadremould
    PNrange=PN[18]+PN[19]*(PNlevel-1)/1000+PN[20]*(max(PNlevel,100)-100)/1000+PNrangeremould
    PNhit=(PN[21]+PN[22]*(PNlevel-1)/1000+PN[23]*(max(PNlevel,100)-100)/1000)*PNintimacy+PNhitremould
    PNdodge=(PN[24]+PN[25]*(PNlevel-1)/1000+PN[26]*(max(PNlevel,100)-100)/1000)*PNintimacy+PNdodgeremould
    PNspeed=PN[27]+PN[28]*(PNlevel-1)/1000+PN[29]*(max(PNlevel,100)-100)/1000+PNspeedremould
    PNluck=PN[30]+PN[31]*(PNlevel-1)/1000+PN[32]*(max(PNlevel,100)-100)/1000+PNluckremould
    PNantisub=(PN[33]+PN[34]*(PNlevel-1)/1000+PN[35]*(max(PNlevel,100)-100)/1000)*PNintimacy+PNantisubremould
    PNoil=(PN[54]+PN[55]*(0.5+min(PNlevel,99)*0.005))
    PNout = [PNdurability, PNcannon, PNtorpedo, PNantiaircraft, PNair, PNreload, PNrange, PNhit, PNdodge, PNspeed, PNluck, PNantisub, PNoil]
    return PNout

if __name__ == "__main__":
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
    f = open(os.path.join(util.WikiDirectory, 'PN.txt'), 'w+', encoding = 'utf-8')
    f1 = open(os.path.join(util.WikiDirectory, 'ship120data.csv'), 'w+', encoding = 'gbk')
    f2 = open(os.path.join(util.WikiDirectory, 'ship125data.csv'), 'w+', encoding = 'gbk')
    f1.write("舰船,耐久,炮击,雷击,防空,航空,装填,射程,命中,机动,航速,幸运,反潜\n")
    f2.write("舰船,耐久,炮击,雷击,防空,航空,装填,射程,命中,机动,航速,幸运,反潜\n")
    for ship in data:
        if ship['breakout'] == 3:
            if 'META' in ship['name']:
                ship120 = calculateStats(ship['values'], isMETA = True, PNlevel=120, remould=False)
                ship125 = calculateStats(ship['values'], isMETA = True, PNlevel=125, remould=False)
            else:
                ship120 = calculateStats(ship['values'], isMETA = False, PNlevel=120, remould=False)
                ship125 = calculateStats(ship['values'], isMETA = False, PNlevel=125, remould=False)
            f1.write(ship['name'] + ',' + str(ship120[0]) + ',' + str(ship120[1]) + ',' + str(ship120[2]) + ',' + str(ship120[3]) + ',' + str(ship120[4]) + ',' + str(ship120[5]) + ',' + str(ship120[6]) + ',' + str(ship120[7]) + ',' + str(ship120[8]) + ',' + str(ship120[9]) + ',' + str(ship120[10]) + ',' + str(ship120[11]) + '\n')
            f2.write(ship['name'] + ',' + str(ship125[0]) + ',' + str(ship125[1]) + ',' + str(ship125[2]) + ',' + str(ship125[3]) + ',' + str(ship125[4]) + ',' + str(ship125[5]) + ',' + str(ship125[6]) + ',' + str(ship125[7]) + ',' + str(ship125[8]) + ',' + str(ship125[9]) + ',' + str(ship125[10]) + ',' + str(ship125[11]) + '\n')
        elif ship['breakout'] == 4:
            ship120 = calculateStats(ship['values'], isMETA = False, PNlevel=120, remould=True)
            ship125 = calculateStats(ship['values'], isMETA = False, PNlevel=125, remould=True)
            f1.write(ship['name'] + ',' + str(ship120[0]) + ',' + str(ship120[1]) + ',' + str(ship120[2]) + ',' + str(ship120[3]) + ',' + str(ship120[4]) + ',' + str(ship120[5]) + ',' + str(ship120[6]) + ',' + str(ship120[7]) + ',' + str(ship120[8]) + ',' + str(ship120[9]) + ',' + str(ship120[10]) + ',' + str(ship120[11]) + '\n')
            f2.write(ship['name'] + ',' + str(ship125[0]) + ',' + str(ship125[1]) + ',' + str(ship125[2]) + ',' + str(ship125[3]) + ',' + str(ship125[4]) + ',' + str(ship125[5]) + ',' + str(ship125[6]) + ',' + str(ship125[7]) + ',' + str(ship125[8]) + ',' + str(ship125[9]) + ',' + str(ship125[10]) + ',' + str(ship125[11]) + '\n')
        elif ship['breakout'] == 5:
            ship120 = calculateStats(ship['values'], isMETA = False, PNlevel=120, remould=True)
            ship125 = calculateStats(ship['values'], isMETA = False, PNlevel=125, remould=True)
            f1.write(ship['name'] + '(主力),' + str(ship120[0]) + ',' + str(ship120[1]) + ',' + str(ship120[2]) + ',' + str(ship120[3]) + ',' + str(ship120[4]) + ',' + str(ship120[5]) + ',' + str(ship120[6]) + ',' + str(ship120[7]) + ',' + str(ship120[8]) + ',' + str(ship120[9]) + ',' + str(ship120[10]) + ',' + str(ship120[11]) + '\n')
            f2.write(ship['name'] + '(主力),' + str(ship125[0]) + ',' + str(ship125[1]) + ',' + str(ship125[2]) + ',' + str(ship125[3]) + ',' + str(ship125[4]) + ',' + str(ship125[5]) + ',' + str(ship125[6]) + ',' + str(ship125[7]) + ',' + str(ship125[8]) + ',' + str(ship125[9]) + ',' + str(ship125[10]) + ',' + str(ship125[11]) + '\n')
        f.write(formatData(ship['wikiID'], ship['values'], ship['name'], ship['breakout']))
        f.write('\n')
    f.close()
    f1.close()
    f2.close()
