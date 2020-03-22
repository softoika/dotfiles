#!/usr/bin/env bash -eu
for file in .??*; do
  [[ $file == ".git" ]] && continue
  [[ $file == ".gitignore" ]] && continue
  [[ $file == ".DS_Store" ]] && continue
  [[ $file == ".config" ]] && continue
  
  ln -fns "${PWD}/${file}" "${HOME}/${file}"
done

# VSCode
ln -fns "${PWD}/vscode/settings.json" "${HOME}/Library/Application Support/Code/User/settings.json"
ln -fns "${PWD}/vscode/keybindings.json" "${HOME}/Library/Application Support/Code/User/keybindings.json"

# Shell Scripts
ln -fns "${PWD}/bin" "${HOME}/.local/bin"

# .config
if [[ ! -e "${HOME}/.config" ]]; then
  mkdir "${HOME}/.config"
fi
for directory in $(find .config -mindepth 1 -maxdepth 1 -type d); do
  if [[ -e "${HOME}/${directory}" ]]; then
    read -p "${directory} has already exist. Replace it? (Y/n)" yn
    case $yn in
      [Y]*)
        rm -rf ${HOME}/${directory}
        echo $directory was removed
        ;;
      *)
        echo $directory was skipped
        break
        ;;
    esac
  fi
  echo Create $directory symbolic link
  ln -fns "${PWD}/${directory}" "${HOME}/.config"
done
