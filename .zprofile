source ~/.zshrc

if [ -e ~/instantclient_12_1 ] ; then
    export PATH=~/instantclient_12_1:$PATH
fi

if [ -e ~/tools/pt_darwin_amd64 ] ; then
    export PATH=~/tools/pt_darwin_amd64:$PATH
fi


## export
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="$HOME/git/flutter/bin:$PATH"


eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

which peco > /dev/null
if [ $? -eq 0 ] ; then
    zle -N peco-history-selection
    bindkey '^R' peco-history-selection
else
    bindkey "^R" history-incremental-search-backward
fi
