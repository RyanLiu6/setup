# Enable caching of evaluated commands
typeset -A evaluated_cmds

# Function to source files if they haven't been sourced in this session
function source_once() {
    local file=$1
    if [[ ! -v evaluated_cmds[$file] ]]; then
        source $file
        evaluated_cmds[$file]=1
    fi
}

# Mark timing for shellperf (no-op if not profiling)
_shellperf_tag "base" "Start base configuration" 2>/dev/null || true

# Source all configuration files
for config in ~/dev/setup/shell/.zsh/*.zsh; do
    source_once $config
done

_shellperf_tag "base" "Loaded base configs" 2>/dev/null || true

# Source local customizations (for work-specific configs, not tracked in git)
if [[ -f ~/.zshrc.local ]]; then
    _shellperf_tag "local" "Loading local customizations" 2>/dev/null || true
    source ~/.zshrc.local
    _shellperf_tag "local" "Loaded local customizations" 2>/dev/null || true
fi

# Starship is our chosen prompt
if [[ ! -v evaluated_cmds[starship] ]]; then
    _shellperf_tag "base" "Loading Starship prompt" 2>/dev/null || true
    eval "$(starship init zsh)"
    evaluated_cmds[starship]=1
    _shellperf_tag "base" "Loaded Starship prompt" 2>/dev/null || true
fi

export STARSHIP_CONFIG=~/dev/setup/terminal/starship.toml
