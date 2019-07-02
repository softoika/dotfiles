#!/usr/bin/env bash

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
BASE_BRANCH=$(git show-branch | grep '*' | grep -v "${CURRENT_BRANCH}" | head -n1 | awk -F'[]~^[]' '{print $2}')
PR_LIST=$(hub pr list -f '%i (%H)%n')
RELEASE_PR=$(printf "${PR_LIST}" | grep $BASE_BRANCH)
ISSUES=$(echo $CURRENT_BRANCH | gsed -r "s/[^0-9]/\n/g" | egrep "[0-9]" | gsed -r "s/([0-9]+)/#\1/g")
DESCRIPTION="## Issues\n${ISSUES}\n\n## Summary\n\n## Release PR\n${RELEASE_PR}\n"
MESSAGE=$(printf "$(echo $ISSUES | while read line; do echo -n $line; done)\n\n${DESCRIPTION}")
hub pull-request -eop -b $BASE_BRANCH -m "${MESSAGE}"

