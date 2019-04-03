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

# Customize to your needs...
alias vi='nvim'
alias ll='ls -la'
alias de='diskutil eject'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gch='git checkout'
alias gs='git status'
alias gp='git push'
alias ssh='change_tmux_prefix && sshrc'
alias yr='yarn run'

# historyに時刻を表示するようにする
export HISTTIMEFORMAT='%F %T '
# TMUX用色設定
export TERM='xterm-256color'
# gitなどのエディター設定
export EDITOR=nvim
# crontab -eで$EDITORのエディタを使う
export VISUAL=${EDITOR}

# tmux起動時にはPATHを追加しない
if [[ -z $TMUX ]]; then
  export PATH="$HOME/.pyenv/shims:$PATH"
  export PATH="/usr/local/opt/mysql@5.7/bin/:$PATH"
  export PATH="/usr/local/bin:$PATH"
  export PATH="$HOME/.local/bin:$PATH"
  export PATH=$HOME/.nodebrew/current/bin:$PATH
  export JAVA_HOME=`/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home -v "1.8"`
  export PATH=${JAVA_HOME}/bin:${PATH}
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

dirtouch() {
  mkdir -p "$(dirname $1)"
  touch "$1"
}
alias touch='dirtouch'

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


#if type zprof > /dev/null 2>&1; then
#  zprof | cat
#fi
export NVIM_PYTHON3_HOST_PROG='/Users/pc1170/.pyenv/shims/python3'

