#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

source "${HOME}/.java_home.zsh"

dirtouch() {
  mkdir -p "$(dirname $1)"
  touch "$1"
}

change_tmux_prefix() {
  tmux set-option -g prefix C-t
  tmux unbind-key C-g
  #trap "tmux set-option -g prefix C-g && tmux unbind-key C-t" EXIT
}

revert_tmux_prefix() {
  tmux set-option -g prefix C-g
  tmux unbind-key C-t
}

# 必要のないブランチを全て削除する
git_branch_delete() {
  git fetch -p && for branch in $(git branch -vv --no-color | grep ': gone]' | awk '{print $1}'); do git branch -D $branch; done
}

# git pull and copy '${commit hash #1}..${commit hash #2}'
git_pull_diff_copy() {
    local output=$(git pull) # | tee >(xargs -I@ echo @) | head -n 1 | awk '{ print $2 }' | pbcopy
    echo $output
    echo $output | head -n1 | awk '{ print $2 }' | pbcopy
    echo Copied commit hashes of diff by git pull
}

# Shortcut of ffmpeg use case which convert video to gif
# Example: to_gif foo.mov
to_gif() {
  v=$1
  f=$(echo $v | sed -r 's/(.+)\.mov$/\1/')
  ffmpeg -i $v -r 10 -vf scale=1024:-1 "${f}.gif"
}

alias vi='nvim'
alias ls='\ls -G'
alias ll='ls -la'
alias grep="rg" # ripgrep
alias G='grep'
alias g='git'
alias ga='git add'
alias gaa='git add -A'
alias gbi='git bisect'
alias gbr='git branch'
alias gc='git commit'
alias gch='git checkout'
alias gs='git status'
alias gst='git stash'
alias gl='git log'
# alias gd='git diff'
alias gd='git icdiff'
alias gmr='git merge'
alias gmv='git mv'
alias gp='git push'
alias gps='git push'
alias gpl='git_pull_diff_copy'
alias grb='git rebase'
alias grm='git rm'
alias grs='git reset'
alias h='hub browse'
alias hpr='hub pull-request'
alias k='kubectl'
alias kr='kubectl run'
alias kl='kubectl logs'
alias kg='kubectl get'
alias ka='kubectl apply -f'
alias ke='kubectl explain'
alias kx='kubectl exec'
alias kxp='kubectl explain'
alias kxc='kubectl exec'
alias kdl='kubectl delete'
alias kds='kubectl describe'
alias d='docker'
alias db='docker build'
alias dr='docker run'
alias drm='docker rm'
alias drmi='docker rmi'
alias dp='docker ps'
alias dps='docker ps'
alias dpsh='docker push'
alias dpl='docker pull'
alias di='docker images'
alias ssh='change_tmux_prefix && sshrc'
alias sed='gsed'
alias yr='yarn run'
alias nr='npm run'
alias t='tmux'
alias ta='tmux a -t'
alias tls='tmux ls'
alias c='cd ~/Repositories'
alias dot='cd ~/Repositories/dotfiles'
alias brew='brew.sh'
alias touch='dirtouch'

# historyに時刻を表示するようにする
export HISTTIMEFORMAT='%F %T '
# TMUX用色設定
export TERM='xterm-256color'
# gitなどのエディター設定
export EDITOR=nvim
# crontab -eで$EDITORのエディタを使う
export VISUAL=${EDITOR}

### fzf settings ###
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_R_OPTS='--sort --exact'

# fbr - checkout git branch (including remote branches)
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fuzzy git add (https://qiita.com/reviry/items/e798da034955c2af84c5)
fad() {
  local out q n addfiles
  while out=$(
      git status --short |
      awk '{if (substr($0,2,1) !~ / /) print $2}' |
      fzf-tmux --multi --exit-0 --expect=ctrl-d); do
    q=$(head -1 <<< "$out")
    n=$[$(wc -l <<< "$out") - 1]
    addfiles=(`echo $(tail "-$n" <<< "$out")`)
    [[ -z "$addfiles" ]] && continue
    if [ "$q" = ctrl-d ]; then
      git diff --color=always $addfiles | less -R
    else
      git add $addfiles
    fi
  done
}
### fzf settings ###

# tmux起動時にはPATHを追加しない
if [[ -z $TMUX ]]; then
  export PATH="$HOME/.pyenv/shims:$PATH"
  export PATH="/usr/local/opt/mysql@5.7/bin/:$PATH"
  export PATH="/usr/local/bin:$PATH"
  export PATH="$HOME/.local/bin:$PATH"
  # coreutils
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"
  export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}"
  # ed
  export PATH="/usr/local/opt/ed/libexec/gnubin:${PATH}"
  export MANPATH="/usr/local/opt/ed/libexec/gnuman:${MANPATH}"
  # findutils
  export PATH="/usr/local/opt/findutils/libexec/gnubin:${PATH}"
  export MANPATH="/usr/local/opt/findutils/libexec/gnuman:${MANPATH}"
  # sed
  export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:${PATH}"
  export MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:${MANPATH}"
  # tar
  export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:${PATH}"
  export MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:${MANPATH}"
  # grep
  export PATH="/usr/local/opt/grep/libexec/gnubin:${PATH}"
  export MANPATH="/usr/local/opt/grep/libexec/gnuman:${MANPATH}"
  export PATH=${JAVA_HOME}/bin:${PATH}
  export GRAALVM_HOME="/Library/Java/JavaVirtualMachines/graalvm-ce-${GRAALVM_VERSION}/Contents/Home"
  export PATH=${JAVA_HOME}/bin:${PATH}
  # nodebrew
  export PATH="$HOME/.nodebrew/current/bin:$PATH"
  # pyenvを実行しておく(pythonのパスを通しておくため)
  pyenv
  # tmuxを自動起動する
  tmux new-session
fi

# pyenvが呼ばれたときに初期化するようにする
pyenv() {
  unset -f pyenv
  eval "$(command pyenv init -)"
  pyenv $@
}

kubectl() {
  unset -f kubectl
  eval "$(source <(kubectl completion zsh))"
  kubectl $@
}

autoload -Uz compinit
if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR:-$HOME}/.zcompdump) ]; then
  compinit
  compdump
else
  compinit -C
fi

_python_argcomplete() {
    local IFS=$'\013'
    local SUPPRESS_SPACE=0
    if compopt +o nospace 2> /dev/null; then
        SUPPRESS_SPACE=1
    fi
    COMPREPLY=( $(IFS="$IFS" \
                  COMP_LINE="$COMP_LINE" \
                  COMP_POINT="$COMP_POINT" \
                  COMP_TYPE="$COMP_TYPE" \
                  _ARGCOMPLETE_COMP_WORDBREAKS="$COMP_WORDBREAKS" \
                  _ARGCOMPLETE=1 \
                  _ARGCOMPLETE_SUPPRESS_SPACE=$SUPPRESS_SPACE \
                  "$1" 8>&1 9>&2 1>/dev/null 2>/dev/null) )
    if [[ $? != 0 ]]; then
        unset COMPREPLY
    elif [[ $SUPPRESS_SPACE == 1 ]] && [[ "$COMPREPLY" =~ [=/:]$ ]]; then
        compopt -o nospace
    fi
}

###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm


if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
    if type __ltrim_colon_completions &>/dev/null; then
      __ltrim_colon_completions "${words[cword]}"
    fi
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#if type zprof > /dev/null 2>&1; then
#  zprof | cat
#fi
