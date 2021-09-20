# -*- coding: utf-8 -*-
import git

if __name__ == "__main__":
    print(git.Repo('AzurLaneData').commit('main').summary)