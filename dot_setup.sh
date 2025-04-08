#!/bin/bash

echo "Welcome to machine setup!"
echo "------------------------"

# Prompt for machine alias
read -p "Enter machine alias: " machine_alias

# Define config file paths
machine_config="$HOME/.${machine_alias}.zsh"
dot_id="$HOME/.dot_id"

# List and prompt for each machine-specific config file
echo -e "\nDeleting existing machine-specific config files...\n"
find "$HOME" -maxdepth 1 -type f -name ".*\.zsh" ! -name ".${machine_alias}.zsh" ! -name ".aliases.zsh" ! -name ".zshrc" | while read -r file; do
  if [[ -f "$file" ]]; then
    printf "Delete %s? (Y/n) " "$file"
    read -r confirm </dev/tty
    if [[ "$confirm" =~ ^[Nn]$ ]]; then
      echo "❌ $file"
    else
      git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" update-index --assume-unchanged "$file"
      rm -f "$file"
      echo "🗑️ $file"
    fi
  fi
done

# Create empty machine-specific config file if it doesn't exist
[[ -f "$machine_config" ]] || touch "$machine_config"

# Save machine identifier
echo "$machine_alias" >"$dot_id"

# Configure git to track only this machine's config
git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" add ".${machine_alias}.zsh"
git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" update-index --no-assume-unchanged ".${machine_alias}.zsh"

echo -e "\nMachine configuration has been set up!"
echo "✅ Machine alias: $machine_alias"
echo "✅ Configuration files created:"
echo -e "  - Machine ID: $dot_id"
echo -e "  - Machine-specific config: $machine_config\n"
echo "Please add your machine-specific configurations to: $machine_config"

# Run init-system.sh upon prompt
read -p "Run init-system.sh? (y/N) " run_init
if [[ "$run_init" =~ ^[Yy]$ ]]; then
  # create a brewfile if it's not already there
  [[ ! -f "$HOME/$machine_alias.brewfile" ]] || touch "$HOME/$machine_alias.brewfile"
  "$HOME/init-system.sh" "$machine_alias"
fi

git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" add "$machine_alias.brewfile"
git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" commit -m "Add machine-specific config: $machine_alias"

# Delete all other brewfiles other than core.brewfile and machine-specific brewfile
for file in "$HOME"/*.brewfile; do
  if [[ "$file" != "$HOME/core.brewfile" && "$file" != "$HOME/$machine_alias.brewfile" ]]; then
    rm -f "$file"
  fi
done

echo "✅ Machine setup complete!"
