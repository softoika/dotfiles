#!/usr/bin/env bash -eu
for file in .??*; do
  [[ $file == ".git" ]] && continue
  [[ $file == ".gitignore" ]] && continue
  [[ $file == ".DS_Store" ]] && continue
  
  ln -fns "${PWD}/${file}" "${HOME}/${file}"
done

# VSCode
ln -fns "${PWD}/vscode/settings.json" "${HOME}/Library/Application Support/Code/User/settings.json"

# Shell Scripts
ln -fns "${PWD}/bin" "${HOME}/.local/bin"

