# -*- coding: utf-8 -*-
import re, os
from slpp import slpp
import util

def getShipGroup():
    return util.parseDataFile('ship_data_group')
    
def getShipStatistics():
    return util.parseDataFile('ship_data_statistics')
    
def getShipTemplate():
    return util.parseDataFile('ship_data_template')

def getShipName(groupID, shipStatistics, shipTemplate):
    for k, v in shipTemplate.items():
        if v['group_type'] == groupID:
            for i, j in shipStatistics.items():
                if j['id'] == v['id']:
                    return j['name']

def createNameList():
    shipGroup = getShipGroup()
    shipStatistics = getShipStatistics()
    shipTemplate = getShipTemplate()
    shipCollection = {}
    for k, v in shipGroup.items():
        shipCollection[v['code']] = v['group_type']
    with open(os.path.join(util.WikiDirectory, 'nameIndex.txt'), 'w+', encoding='utf-8') as f:
        for k, v in shipCollection.items():
            name = getShipName(v, shipStatistics, shipTemplate)
            f.write(name + ', ' + str(k) + ', ' + str(v) + '\n')

if __name__ == "__main__":
    createNameList()
