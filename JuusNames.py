# -*- coding: utf-8 -*-
import re, os
import util
    
def getShipStatistics():
    return util.parseDataFile('ship_data_statistics')
    
def getShipTemplate():
    return util.parseDataFile('ship_data_template')

def getJuusNameTemplate():
    return util.parseDataFile('activity_ins_ship_group_template')

def getShipName(groupID, shipStatistics, shipTemplate):
    for k, v in shipTemplate.items():
        if v['group_type'] == groupID:
            for i, j in shipStatistics.items():
                if j['id'] == v['id']:
                    return j['name']

def createJuusNameList():
    JuusNameTemplate = getJuusNameTemplate()
    shipStatistics = getShipStatistics()
    shipTemplate = getShipTemplate()
    with open(os.path.join(util.WikiDirectory, 'JuusNames.txt'), 'w+', encoding='utf-8') as f:
        for k, v in JuusNameTemplate.items():
            name = getShipName(v['ship_group'], shipStatistics, shipTemplate)
            if name:
                f.write(name + ' ' + v['name'] + '\n')

if __name__ == "__main__":
    createJuusNameList()
