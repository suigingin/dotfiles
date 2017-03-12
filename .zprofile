source ~/.zshrc

if [ -e ~/instantclient_12_1 ] ; then
    export PATH=~/instantclient_12_1:$PATH
fi

if [ -e ~/tools/pt_darwin_amd64 ] ; then
    export PATH=~/tools/pt_darwin_amd64:$PATH
fi

which peco > /dev/null
if [ $? -eq 0 ] ; then
    zle -N peco-history-selection
    bindkey '^R' peco-history-selection
else
    bindkey "^R" history-incremental-search-backward
fi
