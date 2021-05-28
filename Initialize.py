# -*- coding: utf-8 -*-
import os
FileList = []
PathList = [os.path.join('Wiki', 'memories'), 'json', 'Wiki', os.path.join('json', 'JP'), os.path.join('Wiki', 'memories', 'JP')]

if __name__ == "__main__":
    for f in FileList:
        os.remove(f)
    for p in PathList:
        if os.path.isdir(p):
            files = os.listdir(p)
            for f in files:
                filePath = os.path.join(p, f)
                if os.path.isfile(filePath):
                    os.remove(filePath)
        else:
            os.makedirs(p)