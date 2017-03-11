# ------- alias
alias ls='ls -FG'
alias ll='ls -lFG'


# ------- autoload
## 補完機能
autoload -U compinit
compinit

## 色
autoload -U colors
colors
PROMPT="%{$fg[green]%}%m:%{$fg[blue]%}[%?]:%{$fg[cyan]%}[%~]
%{$reset_color%}%{$fg[green]%}%%%{$reset_color%} "
PROMPT2="%{$fg[green]%}%_> %{$reset_color%}"
SPROMPT="%{$fg[red]%}correct: %R -> %r [nyae]? %{$reset_color%}"

# ------- option
## コマンド訂正
setopt correct

## 補完候補を詰めて表示する
setopt list_packed

## ヒストリーに重複を表示しない
setopt histignorealldups
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

## cdコマンドを省略して、ディレクトリ名のみの入力で移動
setopt auto_cd


# ------- stty
stty -ixon


# ------- peco
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection
