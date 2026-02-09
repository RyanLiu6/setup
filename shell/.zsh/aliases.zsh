#  Overriding defaults
if [[ "$OSTYPE" == darwin* ]]; then
    alias ls="ls -hFG"
else
    alias ls="ls -hF --color=auto"
fi
alias grep="grep -i"
alias mkdir="mkdir -p"
alias systemctl="sudo systemctl"

# Custom aliases
alias reload="exec zsh"
alias cdm="cd ~/dev/dotfiles/"
alias dps='docker ps -a --format="table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
