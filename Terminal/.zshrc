# source: https://github.com/xero/dotfiles
for config in ~/dev/setup/Terminal/.zsh/*.zsh; do source $config; done
for config in ~/dev/setup/ignore/*.zsh; do source $config; done

# Starship is our chosen prompt
eval "$(starship init zsh)"

export STARSHIP_CONFIG=~/dev/setup/Terminal/starship.toml
