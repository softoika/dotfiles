#!/usr/bin/env bash -eu

for file in .??*; do
  [[ $file == ".git" ]] && continue
  [[ $file == ".gitignore" ]] && continue
  [[ $file == ".DS_Store" ]] && continue
  
  ln -s $file ~/$file
done
