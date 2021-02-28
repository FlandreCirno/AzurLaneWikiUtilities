# -*- coding: utf-8 -*-
import os
FileList = ['Wiki/nameIndex.txt']
PathList = ['Wiki/memories']

if __name__ == "__main__":
    for f in FileList:
        os.remove(f)
    for p in PathList:
        files = os.listdir(p)
        for f in files:
            filePath = os.path.join(p, f)
            if os.path.isfile(filePath):
                os.remove(filePath)