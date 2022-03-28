#  Overriding defaults
alias ls="ls -hFG"
alias grep="grep -i"
alias mkdir="mkdir -p"
alias systemctl="sudo systemctl"

# Custom aliases
alias reload="source ~/.zshrc && echo 'Profiles reloaded correctly' || echo 'Syntax Errors'"
alias cdm="cd ~/dev/setup/"
alias dps='docker ps -a --format="table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias stats="docker stats --format='table {{.Name}}\t{{.MemUsage}}'"

# functions
function pip_install {
    pip install $1 && pip freeze | grep $1 >> requirements.txt
}
