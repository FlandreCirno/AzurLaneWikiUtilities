# -*- coding: utf-8 -*-
"""Get git summary for commit message."""
import sys
import os

try:
    import git
except ImportError:
    print("update [CN]")
    sys.exit(0)

if __name__ == "__main__":
    try:
        repo = git.Repo('AzurLaneData')
        commit_summary = repo.commit('main').summary
        print(commit_summary)
    except Exception as e:
        print(f"update [CN]: {e}")
