# For debugging startup time, uncomment these lines:
# zmodload zsh/zprof

bindkey -v

alias dot='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'

if [[ "$(uname)" == "Darwin" ]]; then

  export PATH="/opt/homebrew/bin:/usr/local/bin:/Users/aarjav/.local/bin:/usr/local/opt/python@3.12/bin:$PATH"
  export HOMEBREW_AUTO_UPDATE_SECS="86400"
  alias things3-reset="cd ~ && fd 'thingsmac' -0 | xargs -0 rm -rf"

fi

zmodload zsh/zle
autoload -z edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

bindkey '^O' forward-char

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

function write_message() {
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
  if ! dot diff --quiet &>/dev/null; then
    commit_message="Update $(date '+%Y-%m-%d %H:%M:%S')"
    dot add ~/.config/nvim/ ~/.config/kitty/
    dot commit -am "$commit_message" &>/dev/null

    # Update the nvim submodule reference
    dot submodule update --remote --rebase &>/dev/null
    dot add ~/.config/nvim
    dot commit -am "Update nvim submodule reference" &>/dev/null

    if dot pull --rebase &>/dev/null; then
      echo "" >/tmp/dot_status
    else
      echo "❌ ↓" >/tmp/dot_status
      return 1
    fi
    if dot push &>/dev/null; then
      echo "✅ ↑" >/tmp/dot_status
    else
      echo "❌ ↑" >/tmp/dot_status
      return 1
    fi
  else
    echo "" >/tmp/dot_status
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

export ERL_AFLAGS="-kernel shell_history enabled"
