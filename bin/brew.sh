#!/usr/bin/env bash -eu

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
            cat $BREWLIST_PATH | while read pkg
            do
                brew install $pkg
            done
        else
            echo Not found .brewlist
            echo Creating .brewlist ...
            brew list > $BREWLIST_PATH
        fi
    fi
else
    brew $@
fi

