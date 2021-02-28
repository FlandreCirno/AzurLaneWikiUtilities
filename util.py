# -*- coding: utf-8 -*-
import re, os, json
from slpp import slpp

DataDirectory = r'AzurLaneData\zh-CN'
JsonDirectory = r'json'
WikiDirectory = r'Wiki'

def parseDataFile(fileName, filePath = r'sharecfg', mode = 0):
    if mode == 0:
        filePath = os.path.join(DataDirectory, filePath, fileName + '.lua')
        with open(filePath, 'r', encoding='utf-8') as f:
            content = f.read()
        content = re.match(r".*" + fileName + r" = (\{.*\})", content, flags = re.DOTALL)[1]
        output = slpp.decode(content)
        if isinstance(output, dict) and 'all' in output.keys():
            del output['all']
        return output
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
        return output

if __name__ == "__main__":
    pass
