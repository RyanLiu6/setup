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
for config in ~/dev/setup/Terminal/.zsh/*.zsh; do
    source_once $config
done
if [[ $(functions _log_time) ]]; then _log_time "Terminal configs"; fi

for config in ~/dev/setup/ignore/*.zsh; do
    source_once $config
done
if [[ $(functions _log_time) ]]; then _log_time "Ignore configs"; fi

# Starship is our chosen prompt
if [[ $(functions _log_time) ]]; then _log_time "Before starship"; fi
if [[ ! -v evaluated_cmds[starship] ]]; then
    eval "$(starship init zsh)"
    evaluated_cmds[starship]=1
fi
if [[ $(functions _log_time) ]]; then _log_time "After starship"; fi

export STARSHIP_CONFIG=~/dev/setup/Terminal/starship.toml

# fnm is lazy loaded now, no need to evaluate here

# Print timing statistics
echo "\nShell startup timing:"
printf '%s\n' "${zsh_stats[@]}"
echo "Total time: $((EPOCHREALTIME*1000-start_time))ms\n"
