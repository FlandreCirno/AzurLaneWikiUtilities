# -*- coding: utf-8 -*-
import re, os, json
from slpp import slpp

DataDirectory = os.path.join('AzurLaneData', 'zh-CN')
JsonDirectory = 'json'
WikiDirectory = 'Wiki'

def saveJsonFile(data, fileName):
    with open(os.path.join(JsonDirectory, fileName + '.json'), 'w', encoding='utf-8') as f:
        json.dump(data, f, sort_keys = True, indent = 4, separators = (',', ': '))
        
def loadJsonFile(fileName):
    with open(os.path.join(JsonDirectory, fileName + '.json'), 'r+', encoding='utf-8') as f:
        content = json.load(f)
        return parseJson(content)

def parseJson(data):
    if isinstance(data, dict):
        output = {}
        for k, v in data.items():
            if isinstance(k, str) and k.isdigit():
                output[int(k)] = parseJson(v)
            else:
                output[k] = parseJson(v)
    elif isinstance(data, list):
        output = []
        for i in data:
            output.append(parseJson(i))
    else:
        output = data
    return output

def hasJsonFile(fileName):
    return os.path.isfile(os.path.join(JsonDirectory, fileName + '.json'))

def parseDataFile(fileName, filePath = r'sharecfg', mode = 0):
    if hasJsonFile(fileName):
        return loadJsonFile(fileName)
    else:
        output = None
        if mode == 0:
            filePath = os.path.join(DataDirectory, filePath, fileName + '.lua')
            with open(filePath, 'r', encoding='utf-8') as f:
                content = f.read()
            content = re.match(r".*" + fileName + r" = (\{.*\})", content, flags = re.DOTALL)[1]
            output = slpp.decode(content)
            if isinstance(output, dict) and 'all' in output.keys():
                del output['all']
        elif mode == 1:
            filePath = os.path.join(DataDirectory, filePath)
            output = {}
            templateFileNames = os.listdir(filePath)
            for fNames in templateFileNames:
                with open(os.path.join(filePath, fNames), 'r', encoding='utf-8') as f:
                    content = f.read()
                content = re.match(r".*" + fileName + r"_\d+ = (\{.*\})", content, flags = re.DOTALL)[1]
                o = slpp.decode(content)
                for k, v in o.items():
                    output[k] = v
            if isinstance(output, dict) and 'all' in output.keys():
                del output['all']
        saveJsonFile(output, fileName)
        return output
        
if __name__ == "__main__":
    pass
