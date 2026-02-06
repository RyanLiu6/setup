# Enable caching of evaluated commands
typeset -A evaluated_cmds

# Function to source files if they haven't been sourced in this session
function source_once() {
    local file=$1
    if [[ ! -v evaluated_cmds[$file] ]]; then
        source "$file"
        evaluated_cmds[$file]=1
    fi
}

# Mark timing for shellperf (no-op if not profiling)
_shellperf_tag "base" "Start base configuration" 2>/dev/null || true

# Source all configuration files
_setup_dir="${${(%):-%N}:A:h}"
for config in "$_setup_dir"/.zsh/*.zsh; do
    source_once "$config"
done
unset _setup_dir

_shellperf_tag "base" "Loaded base configs" 2>/dev/null || true

# Starship is our chosen prompt (config symlinked to ~/.config/starship.toml)
if [[ ! -v evaluated_cmds[starship] ]]; then
    _shellperf_tag "base" "Loading Starship prompt" 2>/dev/null || true
    eval "$(starship init zsh)"
    evaluated_cmds[starship]=1
    _shellperf_tag "base" "Loaded Starship prompt" 2>/dev/null || true
fi
