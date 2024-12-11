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

# Lazy load fnm, but set up auto-use
lazy_load "fnm env --use-on-cd" fnm 'export PATH="$HOME/Library/Application Support/fnm:$PATH"'

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

# Load completions efficiently
if type brew &>/dev/null; then
    # Add Homebrew completions to FPATH but don't initialize yet
    FPATH="$(brew --prefix)/share/zsh/site-functions:$(brew --prefix)/share/zsh-completions:${FPATH}"
fi

# Defer completions but ensure they're loaded before first prompt
autoload -Uz compinit
if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null) ]; then
    compinit
else
    compinit -C
fi

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

# Shell profiling function
zsh_profile() {
    # Enable profiling
    zmodload zsh/datetime
    local start_time=$((EPOCHREALTIME*1000))
    local last_time=$start_time
    local timings=()

    function _log_time() {
        local new_time=$((EPOCHREALTIME*1000))
        local label=$1
        local duration=$((new_time-last_time))
        timings+=("$label: ${duration}ms")
        last_time=$new_time
    }

    # Source zshrc and collect timings
    source ~/.zshrc

    # Print results
    echo "\nShell startup timing:"
    printf '%s\n' "${timings[@]}"
    echo "Total time: $((EPOCHREALTIME*1000-start_time))ms\n"

    # Clean up
    unset -f _log_time
}

# Python project initialization helper
pyinit() {
    # Create project structure
    mkdir -p src tests

    # Create .envrc
    echo "layout uv" > .envrc
    direnv allow

    # Install common dev dependencies
    uv pip install pytest ruff

    echo "Python project initialized with direnv!"
}

# Data directory
export DATA_DIRECTORY=/Volumes/Data
