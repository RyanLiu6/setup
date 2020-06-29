eval "$(pyenv init -)"

if type brew &>/dev/null; then
FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi
