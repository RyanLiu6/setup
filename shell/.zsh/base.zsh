# Lazy load functions
function lazy_load() {
    local load_func=$1
    local cmd=$2
    local precmd=$3

    # If precmd is provided, run it immediately
    if [[ -n "$precmd" ]]; then
        eval "$precmd"
    fi

    eval "${cmd}() {
        unset -f ${cmd}
        eval \"\$($load_func)\"
        $cmd \"\$@\"
    }"
}

# Initialize direnv
eval "$(direnv hook zsh)"

# uv (Python package manager) - installed to ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"

# pnpm (Node package manager)
if [[ "$OSTYPE" == darwin* ]]; then
    export PNPM_HOME="$HOME/Library/pnpm"
else
    export PNPM_HOME="$HOME/.local/share/pnpm"
fi
export PATH="$PNPM_HOME:$PATH"

# Lazy load fnm, but set up auto-use
if [[ "$OSTYPE" == darwin* ]]; then
    lazy_load "fnm env --use-on-cd" fnm 'export PATH="$HOME/Library/Application Support/fnm:$PATH"'
else
    lazy_load "fnm env --use-on-cd" fnm 'export PATH="$HOME/.local/share/fnm:$PATH"'
fi

# iTerm 2 tab name for directories
if [ $ITERM_SESSION_ID ]; then
    precmd() {
        echo -ne "\e]0;${PWD##*/}\a"
    }
fi

# Optimize completion system
() {
    # Only regenerate completion cache once per day
    local zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
    if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
        zcompile "$zcompdump"
    fi
}

# Load completions efficiently (Homebrew is macOS only)
if [[ "$OSTYPE" == darwin* ]] && type brew &>/dev/null; then
    # Add Homebrew completions to FPATH but don't initialize yet
    FPATH="$(brew --prefix)/share/zsh/site-functions:$(brew --prefix)/share/zsh-completions:${FPATH}"
fi

# Defer completions but ensure they're loaded before first prompt
autoload -Uz compinit bashcompinit
# Get modification day of .zcompdump (cross-platform)
_zcompdump_mod_day() {
    if [[ "$OSTYPE" == darwin* ]]; then
        stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null
    else
        date -r ~/.zcompdump +'%j' 2>/dev/null
    fi
}
if [[ "$(date +'%j')" != "$(_zcompdump_mod_day)" ]]; then
    compinit
else
    compinit -C
fi
bashcompinit
unfunction _zcompdump_mod_day 2>/dev/null

# Enable completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $HOME/.cache/zsh/completion

# Default editor
export EDITOR=vim
export VISUAL=vim

# Languages
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LESSCHARSET=utf-8

# History
HISTFILE=~/.zhistory
setopt APPEND_HISTORY
HISTSIZE=1200
SAVEHIST=1000
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

# source: https://github.com/imkira/dotfiles/blob/master/.zsh/colored-man-pages.zsh
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;38;5;74m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[38;33;246m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[04;38;5;146m'

# Data directory (macOS external drive)
if [[ "$OSTYPE" == darwin* ]]; then
    export DATA_DIRECTORY=/Volumes/Data
    export OLLAMA_MODELS=/Volumes/Data/.ollama/models
fi
