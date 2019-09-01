#!/usr/bin/env bash 

# The brew command that can be used like npm (e.g. `npm i``)

BREWLIST_DIR="${HOME}/Repositories/dotfiles"
BREWLIST_PATH="${BREWLIST_DIR}/.brewlist"
PACKAGES=${@:2:($#-1)}

brew upgrade

if [[ $1 = "install" ]]; then
  # brew install $PACKAGES
  if [[ $# -gt 1 ]]; then
    brew install $PACKAGES
    echo Updating .brewlist ...
    brew list > $BREWLIST_PATH
  # brew install .brewlist
  else
    if [[ -f $BREWLIST_PATH ]]; then
      diff <(brew list) $BREWLIST_PATH > .brewlist.diff
      cat .brewlist.diff \
        | grep ">" \
        | awk '{ print $2 }' \
        | while read pkg;
      do
        echo "Found lacking package $pkg";
        brew install $pkg
      done
      rm .brewlist.diff
    else
      echo Not found .brewlist
      echo Creating .brewlist ...
      brew list > $BREWLIST_PATH
    fi
  fi
elif [[ $1 = "uninstall" ]]; then
  brew uninstall $PACKAGES
  echo Updating .brewlist ...
  brew list > $BREWLIST_PATH
else
  brew $@
fi

