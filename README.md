dotfiles
========

All of my (public) complete dotfiles.

Because of the use of submodules, the initial clone should be done via:

    git clone --recursive ...

Enjoy

```bash
cd ~
git clone --recursive https://github.com/mikeage/dotfiles.git
ln -s ~/dotfiles/{.inputrc,.tmux.conf,.tmux.conf.local,.bashrc,.bash_profile,.alacritty,.cvsignore,.rsync-exclude,.pylintrc} ~/
mkdir -p ~/.config/nvim
ln -s ~/dotfiles/nvim/config/nvim/init.lua ~/.config/nvim/init.lua

```

## Git config

```bash
git config --global alias.tree "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global branch.autosetupmerge true
git config --global color.interactive auto
git config --global color.ui auto
git config --global core.preloadindex true
git config --global diff.mnemonicprefix true
git config --global merge.stat true
git config --global rerere.enabled 1
```

## Alacritty Config

```bash
wget https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info && tic -xe alacritty,alacritty-direct alacritty.info && rm alacritty.info
```
