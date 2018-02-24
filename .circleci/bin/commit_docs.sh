#!/bin/bash -eux

out=$(git status docs)
if [[ "$out" = *"nothing to commit"* ]]; then
  exit
fi

# If the last commit already updated the docs, then exit.
# Preventable measure to avoid infinite loop.
if git log -1 --pretty=oneline | grep 'docs updated by circleci' ; then
  exit
fi

# if reach here, we have some changes on docs that we should commit
git add docs
git commit -m "docs updated by circleci"

# https://makandracards.com/makandra/12107-git-show-current-branch-name-only
current_branch=$(git rev-parse --abbrev-ref HEAD)
git push origin "$current_branch"
