# -*- coding: utf-8 -*-
import re, os
import util
getShipName = util.getShipName
getNameCode = util.getNameCode
parseNameCode = util.parseNameCode

ColorDict = {
    '#a9f548': '#4eb24e', #绿色
    '#ffff4d': '#ffd000', #黄色
    '#ff5c5c': '#ec5d53', #红色
    '#ffa500': '#ff9900' #橙色
}

def getMemoryGroup():
    return util.parseDataFile('memory_group')
    
def getMemoryTemplate():
    return util.parseDataFile('memory_template')
    
def getWorldGroup():
    return util.parseDataFile('world_collection_record_group')
    
def getWorldTemplate():
    return util.parseDataFile('world_collection_record_template')
    
def getStory(filename, type = 1):
    if type == 1:
        return Stories[filename]
    elif type == 2:
        dungeon = Dungeons[filename]
        storylist = []
        if 'beginStoy' in dungeon.keys():
            storylist.append(dungeon['beginStoy'])
        stage = dungeon['stages']
        for wave in stage[0]['waves']:
            if wave['triggerType'] == 3:
                storylist.append(wave['triggerParams']['id'])
        output = []
        for story in storylist:
            s = getStory(story.lower() + '.lua')
            output.append(s)
        return output

def getShipGroup():
    return util.parseDataFile('ship_data_group')
    
def getShipStatistics():
    return util.parseDataFile('ship_data_statistics')
    
def getShipTemplate():
    return util.parseDataFile('ship_data_template')
    
def getShipSkinTemplate():
    return util.parseDataFile('ship_skin_template',
    filePath = os.path.join('sharecfg', 'ship_skin_template_sublist'), mode = 1)

def getGroup(memoryGroup, worldGroup):
    group = []
    for k, v in memoryGroup.items():
        group.append({'memories': v['memories'], 'title': v['title']})
    for k, v in worldGroup.items():
        group.append({'memories': v['child'], 'title': v['name_abbreviate']})
    return group
    
def mergeMemoryTemplate(memoryTemplate, worldTemplate):
    for k, v in worldTemplate.items():
        memoryTemplate[k] = {'id': v['id'], 'type': 1, 'title': v['name'], 'story': v['story']}

def getMemory(memoryID, memoryTemplate):
    output = {}
    for k, v in memoryTemplate.items():
        if v['id'] == memoryID:
            output['title'] = v['title']
            story = v['story'].lower()
            output['type'] = v['type']
    try:
        output['story'] = getStory(story, output['type'])
    except:
        print(output)
        raise
        return None
    return output
    
def sanitizeMemory(memory, skinTemplate, shipStatistics, shipTemplate, nameCode):
    output = {'title': parseNameCode(memory['title'], nameCode, AF = True), 'memory':[]}
    if isinstance(memory['story'], list):
        tempMemory = {'title': memory['title']}
        for story in memory['story']:
            tempMemory['story'] = story
            segMemory = sanitizeMemory(tempMemory, skinTemplate, shipStatistics, shipTemplate, nameCode)
            for m in segMemory['memory']:
                output['memory'].append(m)
            output['memory'].append({'type': 'break', 'words': None, 'name': None, 'actor': None, 'color': None, 'option':None})
        output['memory'] = output['memory'][:-1]
        return output
    scripts = memory['story']['scripts']
    if isinstance(scripts, dict):
        scripts = scripts.values()
    for script in scripts:
        words = ''
        type = None
        name = ''
        actor = None
        color = None
        option = None
        if isinstance(script, dict) and 'sequence' in script.keys():
            if isinstance(script['sequence'], dict):
                script['sequence'] = script['sequence'].values()
            for s in script['sequence']:
                words += s[0] + '\n'
            words = words[:-1]
            type = 'sequence'
            if len(words) == 0:
                continue
        elif isinstance(script, dict) and 'say' in script.keys():
            words = script['say']
            if 'actor' in script.keys():
                actor = script['actor']
            else:
                actor = None
            if 'nameColor' in script.keys():
                color = script['nameColor']
            else:
                color = None
            if 'options' in script.keys():
                if not option:
                    option = {'options': []}
                options = script['options']
                if isinstance(options, dict):
                    options = options.values()
                for o in options:
                    flag = ''
                    if 'flag' in o.keys():
                        flag = o['flag']
                    option['options'].append({'flag': flag, 'content': parseNameCode(o['content'], nameCode, AF = True)})
            if 'optionFlag' in script.keys():
                if not option:
                    option = {}
                option['optionFlag'] = script['optionFlag']
            if 'actorName' in script.keys():
                name = script['actorName']
            elif actor and actor > 0:
                try:
                    name = getShipName(actor, skinTemplate, shipStatistics)
                except:
                    name = str(actor)
                    print(f'未找到actor{actor}名称')
            else:
                name = ''
            type = 'say'
        else:
            continue
        words = re.sub(r'\<.*?\>', '', words)
        words = parseNameCode(words, nameCode, AF = True)
        name = parseNameCode(name, nameCode, AF = True)
        output['memory'].append({'type': type, 'words': words, 'name': name, 'actor': actor, 'color': color, 'option': option})
    return output

def buildGroup(group, skinTemplate, shipStatistics, shipTemplate, memoryTemplate, nameCode):
    output = {'title': parseNameCode(group['title'], nameCode), 'memories':[]}
    try:
        for memoryID in group['memories']:
            memory = getMemory(memoryID, memoryTemplate)
            if memory:
                memory = sanitizeMemory(memory, skinTemplate, shipStatistics, shipTemplate, nameCode)
            else:
                continue
            output['memories'].append(memory)
    except:
        print(str(memory))
        raise
    return output

def wikiPage(group):
    output = '== ' + group['title'] + ' ==\n{{折叠面板|开始}}\n'
    index = 1
    for memory in group['memories']:
        output += wikiParagraph(memory, index)
        index += 1
    output += '{{折叠面板|结束}}\n'
    return output.replace('\\n', '\n')
    
def wikiParagraph(memory, index):
    output = '{{折叠面板|标题=' + memory['title'] + '|选项=' + str(index) + '|主框=1|样式=primary|展开=否}}\n'
    lastActor = None
    lastOption = None
    for slide in memory['memory']:
        output += wikiSlide(slide, lastActor, lastOption)
        lastActor = slide['name']
        lastOption = None
        if slide['option']:
            if 'optionFlag' in slide['option'].keys():
                lastOption = slide['option']['optionFlag']
            elif 'options' in slide['option'].keys():
                lastOption = 0
    output += '{{折叠面板|内容结束}}\n\n'
    return output
    
def wikiSlide(slide, lastActor, lastOption):
    output = ''
    if slide['type'] == 'break':
        return '<br>\n'
    thisOption = None
    if slide['option']:
        if 'optionFlag' in slide['option'].keys():
            thisOption = slide['option']['optionFlag']
        elif 'options' in slide['option'].keys():
            thisOption = 0
    if thisOption != 0 and thisOption != lastOption:
        name = slide['name']
    elif slide['name'] == lastActor:
        name = None
    else:
        name = slide['name']
    if name != None:
        if len(name) > 0:
            if slide['color']:
                output += '<span style="color:' + replaceColor(slide['color']) + ';">' + name + '：</span>'
            else:
                output += name + '：'
        output += '<br>\n'
    if slide['option'] and 'optionFlag' in slide['option'].keys():
        output += "'''''<span style=" + '"color:black;"' + ">（选择项" + str(slide['option']['optionFlag']) + "）</span>'''''"
    output += nowiki(slide['words']).replace('\n', '<br>\n') + '<br>\n'
    if slide['option'] and 'options' in slide['option'].keys():
        output += '<br>\n'
        for option in slide['option']['options']:
            output += "'''''<span style=" + '"color:black;"' + ">选择项" + str(option['flag']) + "："
            output += nowiki(option['content']) + "</span>'''''<br>\n"
    return output

def nowiki(text):
    return re.sub(r'(~{3,})', r'<nowiki>\1</nowiki>', text)

def replaceColor(color):
    if color in ColorDict.keys():
        return ColorDict[color]
    else:
        return color

def wikiGenerate():
    nameCode = getNameCode()
    memoryGroup = getMemoryGroup()
    memoryTemplate = getMemoryTemplate()
    worldGroup = getWorldGroup()
    worldTemplate = getWorldTemplate()
    shipGroup = getShipGroup()
    shipStatistics = getShipStatistics()
    shipTemplate = getShipTemplate()
    skinTemplate = getShipSkinTemplate()
    global Stories
    Stories = util.loadJsonFile('story')
    global Dungeons
    Dungeons = util.loadJsonFile('dungeon')
    groups = getGroup(memoryGroup, worldGroup)
    mergeMemoryTemplate(memoryTemplate, worldTemplate)
    groupsbuilt = []
    for v in groups:
        groupsbuilt.append(buildGroup(v, skinTemplate, shipStatistics, shipTemplate, memoryTemplate, nameCode))
    for group in groupsbuilt:
        with open(os.path.join(util.WikiDirectory, 'memories', group['title'].replace(':', '') + '.txt'), 'w+', encoding='utf-8') as f:
            f.write(wikiPage(group))
            
def MemoryJP():
    util.DataDirectory = os.path.join('AzurLaneData', 'JP')
    util.JsonDirectory = os.path.join('AzurLaneData', 'JP')
    nameCode = getNameCode()
    memoryGroup = getMemoryGroup()
    memoryTemplate = getMemoryTemplate()
    worldGroup = getWorldGroup()
    worldTemplate = getWorldTemplate()
    shipGroup = getShipGroup()
    shipStatistics = getShipStatistics()
    shipTemplate = getShipTemplate()
    skinTemplate = getShipSkinTemplate()
    global Stories
    Stories = util.loadJsonFile('story')
    global Dungeons
    Dungeons = util.loadJsonFile('dungeon')
    groups = getGroup(memoryGroup, worldGroup)
    mergeMemoryTemplate(memoryTemplate, worldTemplate)
    groupsbuilt = []
    for v in groups:
        groupsbuilt.append(buildGroup(v, skinTemplate, shipStatistics, shipTemplate, memoryTemplate, nameCode))
    for group in groupsbuilt:
        with open(os.path.join(util.WikiDirectory, 'memories', 'JP', group['title'].replace(':', '：').replace('?', '？') + '.txt'), 'w+', encoding='utf-8') as f:
            f.write(wikiPage(group))

if __name__ == "__main__":
    wikiGenerate()
    MemoryJP()
