#!/usr/bin/env bash
set -Eeuo pipefail

if [[ $# -ne 1 ]]; then
  branch=$(git branch --contains | cut -d " " -f 2)
else
  branch=$1
fi

script="NO_TESTS=1 BRANCH=${branch} build-saas.sh"
echo $script
ssh shoprun@patto.shoprun.jp $script && exit
