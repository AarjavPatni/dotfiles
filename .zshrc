# For debugging startup time, uncomment these lines:
# zmodload zsh/zprof

if [[ "$(uname)" == "Darwin" ]]; then

export PATH="/opt/homebrew/bin:/usr/local/bin:/Users/aarjav/.local/bin:/usr/local/opt/python@3.12/bin:$PATH"
export HOMEBREW_AUTO_UPDATE_SECS="86400"
alias things3-reset="cd ~ && fd 'thingsmac' -0 | xargs -0 rm -rf"

fi

eval "$(starship init zsh)"

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Completion system
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump && -n $(find ${ZDOTDIR}/.zcompdump -mtime +1 2>/dev/null) ]]; then
  compinit
else
  compinit -C
fi

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

check_dot_status() {
  # Function to display a message in the top right corner
  display_message() {
    local message="$1"
    local cols=$(tput cols)
    local lines=$(tput lines)
    tput cup 0 $((cols - ${#message}))
    echo -n "$message"
    tput cup $lines 0  # Move cursor back to the bottom
  }

  # Pull and rebase from the remote repository
  if git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" pull --rebase &>/dev/null; then
    display_message "Dotfiles Updated: Changes pulled and rebased from remote."
  else
    display_message "Dotfiles Sync Warning: Failed to pull and rebase from remote."
    return 1
  fi

  # Check if there are local changes to push
  if ! git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" diff --quiet; then
    if git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" push &>/dev/null; then
      display_message "Dotfiles Updated: Local changes pushed to remote."
    else
      display_message "Dotfiles Sync Warning: Failed to push local changes to remote."
      return 1
    fi
  else
    display_message "Dotfiles Status: No local changes to push."
  fi
}

(check_dot_status &)

if [[ "$(uname)" == "Darwin" ]]; then

# Load plugins (keep these last, syntax highlighting must be last)
eval "$(fzf --zsh)"
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
autoload -U +X bashcompinit && bashcompinit # Bash completion compatibility layer

fi

# Load aliases
[ -f ~/.aliases.zsh ] && source ~/.aliases.zsh

# Load machine-specific configuration
if [[ -f "$HOME/.dot_id" ]]; then
    machine_id=$(cat "$HOME/.dot_id")
    machine_config="$HOME/.${machine_id}.zsh"
    [ -f "$machine_config" ] && source "$machine_config"
fi

# Package-specific configs
# pnpm
export PNPM_HOME="/Users/aarjav/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Uncomment to see startup profiling results
# zprof
