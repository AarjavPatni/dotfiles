# Replicating Dotfiles
⚠️ This will overwrite local dotfiles
```
git clone --bare git@github.com:AarjavPatni/dotfiles.git $HOME/.dotfiles
alias dot='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
dot checkout -f
dot config --local status.showUntrackedFiles no
bash $HOME/dot_setup.sh
```

# Usage
```
dot add .vimrc
dot pull --rebase
dot push
```
