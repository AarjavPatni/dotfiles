#!/bin/bash

# Get machine alias
machine_alias=$1

# Caps -> Control
defaults write com.apple.keyboard.modifiermapping.1452-630-0 -array-add '{"HIDKeyboardModifierMappingSrc"=0x700000039;"HIDKeyboardModifierMappingDst"=0x7000000E0;}'

# Instant hide dock and window manager
defaults write com.apple.dock autohide-delay -float 0; killall Dock
defaults write com.apple.dock autohide-time-modifier -float 0.5; killall Dock
defaults write com.apple.WindowManager AutoHideDelay -int 0

# Enable Natural Scrolling
defaults write -g com.apple.swipescrolldirection -bool true

# Disable auto-correct and auto-capitalization
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Shorten key repeat delay and speed
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 15

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Run Brewfiles
echo "Installing Homebrew packages..."
brew bundle --file="$HOME/core.brewfile"
brew bundle --file="$HOME/$machine_alias.brewfile"
echo "✅ Homebrew packages installed."

if grep -q "cursor" "$HOME/core.brewfile" || grep -q "cursor" "$HOME/$machine_alias.brewfile"; then
    mkdir -p "$HOME/Library/Application Support/Cursor/User"
    ln -sf "$HOME/cursor-config.json" "$HOME/Library/Application Support/Cursor/User/settings.json"
    echo "\n✅ Cursor successfully configured.\n\n"
fi

