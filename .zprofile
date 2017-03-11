source ~/.zshrc

if [ -e ~/instantclient_12_1 ] ; then
    export PATH=~/instantclient_12_1:$PATH
fi

if [ -e ~/tools/pt_darwin_amd64 ] ; then
    export PATH=~/tools/pt_darwin_amd64:$PATH
fi
