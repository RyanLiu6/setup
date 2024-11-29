# Initialize timing array
zmodload zsh/datetime
zsh_stats=()
start_time=$((EPOCHREALTIME*1000))

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

# source: https://github.com/xero/dotfiles
if [[ $(functions _log_time) ]]; then _log_time "Before configs"; fi
for config in ~/dev/setup/shell/.zsh/*.zsh; do
    source_once $config
done
if [[ $(functions _log_time) ]]; then _log_time "Terminal configs"; fi

# Starship is our chosen prompt
if [[ $(functions _log_time) ]]; then _log_time "Before starship"; fi
if [[ ! -v evaluated_cmds[starship] ]]; then
    eval "$(starship init zsh)"
    evaluated_cmds[starship]=1
fi
if [[ $(functions _log_time) ]]; then _log_time "After starship"; fi

export STARSHIP_CONFIG=~/dev/setup/Terminal/starship.toml

# Print timing statistics
echo "\nShell startup time:"
printf '%s\n' "${zsh_stats[@]}"
echo "Total time: $((EPOCHREALTIME*1000-start_time))ms\n"
