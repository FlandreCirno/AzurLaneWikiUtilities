# -*- coding: utf-8 -*-
import re, os
from slpp import slpp
import util

shipType = ['驱逐', '轻巡', '重巡', '战巡', '战列', '轻母', '航母', '潜艇', '航巡', '航战', '雷巡', '维修', '重炮', '占位', '占位', '占位', '潜母', '超巡', '运输']
shipAwardList = ['驱逐', '轻巡', '重巡', '战巡', '战列', '航母', '轻母', '重炮', '维修', '潜艇']

def getShipTemplate():
    return util.parseDataFile('ship_data_template')

def getChapterTemplate():
    return util.getChapterTemplate()
    
def getMapData():
    return util.parseDataFile('expedition_data_by_map')
    
def getShipSkinTemplate():
    return util.parseDataFile('ship_skin_template',
    filePath = os.path.join('sharecfg', 'ship_skin_template_sublist'), mode = 1)
    
def getItemStatistics():
    return util.parseDataFile('item_data_statistics')
    
def getChapterAward():
    shipTemplate = getShipTemplate()
    shipSkin = getShipSkinTemplate()
    mapData = getMapData()
    chapterTemplate = getChapterTemplate()
    itemStatistics = getItemStatistics()
    nameCode = util.getNameCode()
    mapName = {}
    for c in chapterTemplate.values():
        c['characterAward'] = []
        c['equipmentAward'] = []
        for award in c['awards']:
            if award[0] == 2:
                for a in itemStatistics[award[1]]['display_icon']:
                    if a[0] == 4:
                        c['characterAward'].append(a[1])
    for m in mapData.values():
        m['chapters'] = {}
        for c in chapterTemplate.values():
            if c['map'] == m['map']:
                m['chapters'][c['id']] = c
        if m['name'] in mapName.keys():
            mapName[m['name']][m['map']] = m
        else:
            mapName[m['name']] = {m['map']: m}
    for m in mapName.values():
        for m2 in m.values():
            if m2['type'] == 1:
                m2['category'] = '普通主线'
            elif m2['type'] == 2:
                m2['category'] = '困难主线'
            else:
                if m2['on_activity'] == 0:
                    m2['category'] = '作战档案'
                else:
                    on_activity = m2['on_activity']
                    for m3 in m.values():
                        if m3['on_activity'] != 0 and m3['on_activity'] < on_activity:
                            on_activity = m3['on_activity']
                    if on_activity != m2['on_activity']:
                        m2['category'] = '复刻活动'
                    else:
                        m2['category'] = '限时活动'
    for m in mapData.values():
        filename = re.match(r'[^|]*', m['name'])[0]
        if m['type'] == 4:
            filename += '普通'
        elif m['type'] == 5:
            filename += '困难'
        filename += '.txt'
        filePath = os.path.join(util.WikiDirectory, 'chapterAwards', m['category'], filename)
        if os.path.isfile(filePath):
            raise Exception(f'File: {filename} already exists!')
        with open(filePath, 'w+', encoding='utf-8') as f:
            output = formatMap(m, shipSkin, shipTemplate)
            output = util.parseNameCode(output, nameCode)
            f.write(output)

def formatMap(mapData, shipSkin, shipTemplate):
    output = mapData['name'] + '\n'
    for chapter in mapData['chapters'].values():
        output += formatChapter(chapter, shipSkin, shipTemplate)
    return output

def formatChapter(chapterData, shipSkin, shipTemplate):
    output = chapterData['chapter_name'] + '-' + chapterData['name'] + '\n'
    characterList = {}
    for t in shipAwardList:
        characterList[t] = []
    for award in chapterData['characterAward']:
        t = util.getShipType(award, shipTemplate, award//10)
        if shipType[t-1] in characterList.keys():
            characterList[shipType[t-1]].append(util.getShipName(award, shipSkin, award//10))
    for k, v in characterList.items():
        output += '|掉落' + k + '='
        for s in v:
            output += s + '、'
        output = output[:-1] + '\n'
    return output
        

if __name__ == "__main__":
    getChapterAward()
