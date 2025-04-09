#!/bin/bash

echo "Welcome to machine setup!"
echo "------------------------"

# Prompt for machine alias with confirmation
while true; do
    read -p "Enter machine alias: " machine_alias
    read -p "You entered '$machine_alias'. Is this correct? (y/n): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        break
    fi
done

# Define config file paths
machine_config="$HOME/.${machine_alias}.zsh"
dot_id="$HOME/.dot_id"

# List and prompt for each machine-specific config file
echo "\nDeleting existing machine-specific config files..."
find "$HOME" -maxdepth 1 -type f -name ".*\.zsh" ! -name ".${machine_alias}.zsh" ! -name ".aliases.zsh" ! -name ".zshrc" | while read -r file; do
  if [[ -f "$file" ]]; then
    git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" update-index --assume-unchanged "$file"
    rm -f "$file"
    echo "🗑️ $file"
  fi
done

# Create empty machine-specific config file if it doesn't exist
[[ -f "$machine_config" ]] || touch "$machine_config"

# Save machine identifier
echo "$machine_alias" >"$dot_id"

# Configure git to track only this machine's config
git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" add ".${machine_alias}.zsh"
git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" update-index --no-assume-unchanged ".${machine_alias}.zsh"

echo "\nMachine configuration has been set up!"
echo "✅ Machine alias: $machine_alias"
echo "✅ Configuration files created:"
echo "  - Machine ID: $dot_id"
echo "  - Machine-specific config: $machine_config\n"
echo "Please add your machine-specific configurations to: $machine_config"

# Run init-system.sh upon prompt
read -p "Run init-system.sh? (y/N) " run_init
if [[ "$run_init" =~ ^[Yy]$ ]]; then
  [[ ! -f "$HOME/$machine_alias.brewfile" ]] || touch "$HOME/$machine_alias.brewfile"
  /bin/bash "$HOME/init-system.sh" "$machine_alias"
  rm -f "$HOME/init-system.sh"
fi

# Configure git to track machine-specific brewfile
git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" add "$machine_alias.brewfile"
git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" commit -m "Add machine-specific config: $machine_alias"

# Delete all other brewfiles other than core.brewfile and machine-specific brewfile
find "$HOME" -maxdepth 1 -type f -name ".${machine_alias}.brewfile" ! -name ".core.brewfile" | while read -r file; do
  if [[ -f "$file" ]]; then
    git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" update-index --assume-unchanged "$file"
    rm -f "$file"
    echo "🗑️ $file"
  fi
done

echo "🎉 Machine setup complete!"

# Ask the user if they want to open all the casks installed from core and machine-specific brewfiles
read -p "\nOpen all installed casks? (y/N) " open_casks
if [[ "$open_casks" =~ ^[Yy]$ ]]; then
  for app in $(brew list --cask); do
      found_paths=$(find /Applications -maxdepth 1 -iname "*${app}*.app" 2>/dev/null)

      if [ -z "$found_paths" ]; then
        first_part=$(echo "$app" | cut -d'-' -f1)
        if [[ "$app" == *-* ]]; then
          found_paths=$(find /Applications -maxdepth 1 -iname "*${first_part}*.app" 2>/dev/null)
        fi
      fi

      if [ -n "$found_paths" ]; then
        echo "Found app(s) for cask: $app"

        echo "Opening $path..."


      else
        echo "No app found for cask: $app"
      fi
  done

  echo "✅ All installed casks opened."
fi

echo "Don't forget to import the Raycast config!"

