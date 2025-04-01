# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# private command
alias ll='ls -la'

# direnv
eval "$(direnv hook zsh)"

# local pc environment
export EDITOR=vim

# python environment
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# go environment
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# java
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

# postgresql
export PATH="/usr/local/opt/postgresql@16/bin:$PATH"

# alias
alias avk='aws-vault exec kazuya --'
alias avw='aws-vault exec wanrun --no-session --'
alias tp='terraform plan'
alias ti='terraform init'
alias ta='terraform apply'
alias tf='terraform'
