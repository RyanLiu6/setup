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

# Source all configuration files
for config in ~/dev/setup/shell/.zsh/*.zsh; do
    source_once $config
done

# Starship is our chosen prompt
if [[ ! -v evaluated_cmds[starship] ]]; then
    eval "$(starship init zsh)"
    evaluated_cmds[starship]=1
fi

export STARSHIP_CONFIG=~/dev/setup/terminal/starship.toml
