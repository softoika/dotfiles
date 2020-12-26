#!/usr/bin/env bash -eu
for file in .??*; do
  [[ $file == ".git" ]] && continue
  [[ $file == ".gitignore" ]] && continue
  [[ $file == ".DS_Store" ]] && continue
  [[ $file == ".config" ]] && continue
  
  ln -fns "${PWD}/${file}" "${HOME}/${file}"
done

# VSCode
vscode_dir="${HOME}/Library/Application Support/Code/User"
if [[ -d $vscode_dir ]]; then
  ln -fns "${PWD}/vscode/settings.json" "${vscode_dir}/settings.json"
  ln -fns "${PWD}/vscode/keybindings.json" "${vscode_dir}/keybindings.json"
fi

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

# tmux plugins ~/.tmux/plugins/tpm/tpm
tmux_plugins="${HOME}/.tmux/plugins"
if [[ ! -d $tmux_plugins ]]; then
  mkdir -p $tmux_plugins
fi
cd $tmux_plugins
git clone --depth 1 https://github.com/tmux-plugins/tpm
