#  Overriding defaults
alias ls="ls -hFG"
alias grep="grep -i"
alias mkdir="mkdir -p"
alias systemctl="sudo systemctl"

# Custom aliases
alias reload="exec zsh"
alias cdm="cd ~/dev/setup/"
alias dps='docker ps -a --format="table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
