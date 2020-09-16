#!/usr/bin/env bash
if [[ -z $1 ]]; then
  BRANCH=$(git symbolic-ref --short HEAD)
else
  BRANCH=$1
fi
git fetch
echo "${BRANCH}($(git rev-parse --short origin/$BRANCH))"

