# ------- alias
alias ls='ls -FG'
alias lsa='ls -dlFG .*'
alias ll='ls -lFG'
alias rewf='networksetup'
alias gl='git branch'
alias ...='cd ../../'

# ------- bindkey
# Shift-Tabで候補を逆順に補完する
bindkey '^[[Z' reverse-menu-complete

# ------- autoload
## 補完機能
autoload -U compinit
compinit

## 色
autoload -U colors
colors


# ------- prompt
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
RPROMPT='${vcs_info_msg_0_}'

PROMPT="%{$fg[green]%}%m:%(?.%F{green}.%F{red})%(?!(´･_･)!(´~_~%))%f%{$reset_color%}%{$fg[cyan]%}[%~]
%{$reset_color%}%{$fg[green]%}%%%{$reset_color%} "
PROMPT2="%{$fg[green]%}%_> %{$reset_color%}"
SPROMPT="%{%B$fg[red]%}correct: %R -> %r [nyae]? %{$reset_color%}"


# ------- option
## コマンド訂正
setopt correct

## 補完候補を詰めて表示する
setopt list_packed

## 補完候補をハイライトする
zstyle ':completion:*:default' menu select=2

## ヒストリーに重複を表示しない
setopt histignorealldups
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

## cdコマンドを省略して、ディレクトリ名のみの入力で移動
setopt auto_cd

## 補完候補を一覧で表示する
setopt auto_list

## =以降も補完
setopt magic_equal_subst

## バックグラウンド処理の状態変化を通知する
setopt notify

## zsh間で履歴を共有する
setopt share_history


# ------- stty
stty -ixon


# ------- function
## peco history
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

## ptvim
function ptvim () {
    t=$(pt $@ | peco --query "$LBUFFER" | awk -F : '{print "-c " $2 " " $1}')
    echo $t
    if [ -z $t ] ; then
        echo "bye..."
        return 1
    fi
    vim $(echo $t)
}

## findvim
function fvim () {
    f=$(find . -name $@ | peco --query "$LBUFFER")
    if [ -z $f ] ; then
        echo "bye..."
        return 1
    fi
    vim $(echo $f)
}

. /usr/local/etc/profile.d/z.sh

function peco-z-search
{
  which peco z > /dev/null
  if [ $? -ne 0 ]; then
    echo "Please install peco and z"
    return 1
  fi
  local res=$(z | sort -rn | cut -c 12- | uniq | peco)
  if [ -n "$res" ]; then
    BUFFER+="cd $res"
    zle accept-line
  else
    return 1
  fi
}
zle -N peco-z-search
bindkey '^o' peco-z-search
