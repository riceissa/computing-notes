#!/usr/bin/bash

git status --short

git clean -ndX

git clean -nd

git stash list

git log --branches --not --remotes --simplify-by-decoration --decorate --oneline
