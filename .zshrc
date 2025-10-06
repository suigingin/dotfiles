# ------- alias
alias ls='ls -FG'
alias ll='ls -ltrFG'
alias lsa='ls -dlFG .*'
alias rewf='networksetup'
alias g='git'
alias gl='git branch'
alias gstart='git checkout main && git pull origin main'
alias ...='cd ../../'
alias grep='grep --color'
alias py='python'
alias cors='open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir="/tmp/chrome_dev_test" --disable-web-security'
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias gi='git-init'
alias diff='colordiff'
alias ci='/Applications/Visual\ Studio\ Code\ -\ Insiders.app/Contents/Resources/app/bin/code'
alias nb='nodebrew'
#alias aws='ssh -i ~/.ssh/yoko.pem ec2-user@ec2-54-79-141-80.ap-southeast-2.compute.amazonaws.com'

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



# ------- k8s
alias k='kubectl'
alias kd='kubectl describe'
alias kds='kubectl describe'

source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
PROMPT='$(kube_ps1)'$PROMPT

# ------- source
#source ~/git/audio/emsdk/emsdk_env.sh

#echo "source <(kubectl completion zsh)" >> ~/.zshrc
source <(kubectl completion zsh)

# ------- flutter
alias f='flutter'


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
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

function ptvim () {
    t=$(pt $@ | peco --query "$LBUFFER" | awk -F : '{print "-c " $2 " " $1}')
    echo $t
    if [ -z $t ] ; then
        echo "bye..."
        return 1
    fi
    vim $(echo $t)
}

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

function git-init () {
  currentBranch=`git branch -a | grep \*`
  echo $currentBranch
}

function ecs () {
  env=$1
  echo "env=${env}"
  if [ "${env}" != "prod" ] && [ "${env}" != "stg" ] && [ "${env}" != "dev1" ] && [ "${env}" != "dev2" ]; then
    echo "env is invalid. Specify < prod | stg | dev1 | dev2 >"
    return 1
  fi

  if [ "${env}" = "prod" ]; then
     echo "go to prod..."
     task=`aws ecs list-tasks --cluster salescoreprod-common --family salescoreprod-worker --profile salescore-prod | jq '.taskArns[0]'`
     echo '--- copy and exec following command --->\n'
     echo 'aws ecs execute-command --cluster salescoreprod-common \'
     echo "--task ${task} \\"
     echo '--container worker \'
     echo '--interactive \'
     echo '--command "/bin/sh" \'
     echo '--profile salescore-prod\n'
  elif [ "${env}" = "stg" ]; then
     echo "go to stg..."
     task=`aws ecs list-tasks --cluster salescorestg-common --family salescorestg-worker --profile salescore-stg | jq '.taskArns[0]'`
     echo '--- copy and exec following command --->\n'
     echo 'aws ecs execute-command --cluster salescorestg-common \'
     echo "--task ${task} \\"
     echo '--container worker \'
     echo '--interactive \'
     echo '--command "/bin/sh" \'
     echo '--profile salescore-stg\n'
  elif [ "${env}" = "dev1" ]; then
     echo "go to dev1..."
     task=`aws ecs list-tasks --cluster salescoredev1-common --family salescoredev1-worker --profile salescore-dev | jq '.taskArns[0]'`
     echo '--- copy and exec following command --->\n'
     echo 'aws ecs execute-command --cluster salescoredev1-common \'
     echo "--task ${task} \\"
     echo '--container worker \'
     echo '--interactive \'
     echo '--command "/bin/sh" \'
     echo '--profile salescore-dev\n'
  else
     echo "go to dev2..."
     task=`aws ecs list-tasks --cluster salescoredev2-common --family salescoredev2-worker --profile salescore-dev | jq '.taskArns[0]'`
     echo '--- copy and exec following command --->\n'
     echo 'aws ecs execute-command --cluster salescoredev2-common \'
     echo "--task ${task} \\"
     echo '--container worker \'
     echo '--interactive \'
     echo '--command "/bin/sh" \'
     echo '--profile salescore-dev\n'
  fi
}


#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/shims:$PATH"
#eval "$(pyenv init --path)"

eval "$(direnv hook zsh)"

export LDFLAGS="-L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include"
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export SPRING_DATASOURCE_PASSWORD=meiji

chpwd() {
     ls -l
}

# bun completions
[ -s "/Users/suigingin/.bun/_bun" ] && source "/Users/suigingin/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
