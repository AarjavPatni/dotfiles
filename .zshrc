# For debugging startup time, uncomment these lines:
# zmodload zsh/zprof

alias dot='/usr/bin/git --git-dir=/Users/aarjav/.dotfiles/ --work-tree=/Users/aarjav'

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

function write_message () {
  if [[ "$#" -eq 0 ]]; then
    echo "write_message: please provide a message"
    return
  fi

  local message="${*}  "

  local reset=$(tput sgr0)
  local set_fg_green=$(tput setaf 2)
  local set_fg_yellow=$(tput setaf 3)
  
  # Choose color based on message content
  local color
  if [[ $message == *"❌"* ]]; then
    color=$set_fg_yellow
  elif [[ $message == *"✅"* ]]; then
    color=$set_fg_green
  else
    color=$set_fg_green
  fi
  
  echo -n "${color}${message}${reset}"
  echo
}

check_dot_status() {
  # Use a lock file to prevent concurrent execution
  local lock_file="/tmp/dot_status.lock"
  
  # Exit if lock exists (another process is running)
  if [ -f "$lock_file" ]; then
    # Check if the lock is stale (older than 1 minute)
    if test "$(find "$lock_file" -mmin +1)"; then
      rm -f "$lock_file"
    else
      return
    fi
  fi

  # Create lock file
  touch "$lock_file"

  # Ensure lock file is removed when function exits
  trap "rm -f $lock_file" EXIT

  # Pull and rebase from the remote repository
  if dot pull --rebase &>/dev/null; then
    write_message "✅ Dotfiles synced." &
  else
    write_message "❌ Dotfiles failed to sync." &
    return 1
  fi

  # Check if there are local changes to push
  if ! dot diff --quiet &>/dev/null; then
    # Generate a commit message
    commit_message="Update $(date '+%Y-%m-%d %H:%M:%S')"
    dot commit -am "$commit_message" &>/dev/null

    if dot push &>/dev/null; then
      write_message "✅ Dotfiles pushed." &
    else
      write_message "❌ Dotfiles failed to push." &
      return 1
    fi
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
