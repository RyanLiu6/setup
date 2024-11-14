# PyEnv, need other in ~/.zprofile (found at PyEnv documentation)
eval "$(pyenv init -)"

# iTerm 2 tab name for directories
if [ $ITERM_SESSION_ID ]; then
    precmd() {
    echo -ne "\e]0;${PWD##*/}\a"
    }
fi

# Homebrew completions
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

    autoload -Uz compinit
    compinit
fi

# zsh completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
fi

# nvm completions
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
