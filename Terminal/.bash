export PS1='\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[35;1m\]\w\[\033[m\]\$ '
export CLICOLOR=1
export LSCOLORS=dxFxBxExCxegedabagacad

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

alias ls='ls -GFh'
alias pipuninstall="pip uninstall -y -r <(pip freeze)"
alias reload='. ~/.bash_profile && echo "bash_profile reloaded correctly" || echo "Syntax Error in bash_profile"'
