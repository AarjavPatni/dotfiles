# Basic aliases
alias ..='cd ..'
alias grep='grep --color=auto'
alias cp='cp'
alias du='du -h'
alias la='ls -a'
alias ll='ls -l'
alias ls='ls --color=auto'
alias mv='mv -iv'
alias rm='rm -i'
alias vim="nvim"
alias v=nvim
alias v.="nvim ."
alias vv="cd ~/.config/nvim && v. && cd - > /dev/null"
alias vd="cd ~ && v. && cd - > /dev/null"
alias nv="nvim"
alias cat="bat -pp"
alias success='osascript -e '\''display notification "Your command ran successfully." with title "Success"'\'''
alias zc='nvim ~/.zshrc'
alias zcc='cursor ~/.zshrc'
alias zs='source ~/.zshrc'

# Git aliases
alias ga='git add'
alias gc='git commit'
alias gcnv='git commit --no-verify'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcom='git checkout main'
alias gd='git diff'
alias gs='git status'
alias gl='git log'
alias gb='git branch'
alias gpl='git pull'
alias gplm='git pull origin master'
alias gpu='git push'
alias gr='git remote -v'
alias gcl='git clone'
alias gcf='git config --list'
alias gst='git stash'
alias gsa='git stash apply'
alias lg='lazygit'

# tmux aliases
alias tmux='tmux -2'
alias tn='tmux new-session -s'
alias tls='tmux ls'
alias ta='tmux attach-session'
alias tat='tmux attach-session -t'
alias tkill='tmux kill-session -t'
alias tkillall='tmux kill-server'
alias ts='tmux source-file ~/.tmux.conf'

# terraform
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfaa='terraform apply -auto-approve'
alias tfip='terraform init && terraform plan'
alias tfpa='terraform plan && terraform apply'
alias tfia='terraform init && terraform apply'
alias tfiaa='terraform init && terraform apply -auto-approve'

# MacOS specific
if [[ "$(uname)" == "Darwin" ]]; then
  alias upgrade-all='brew update && brew upgrade && brew cleanup && brew autoremove && brew doctor'
  alias bi='brew install'
  alias bu='brew uninstall'
  alias bri='brew reinstall'
  alias c.='cursor .'
fi

# Useful Functions
notify() { osascript -e "display notification \"$1\" with title \"$2\""; }
mkcd() { mkdir -p "$1" && cd "$1"; }
