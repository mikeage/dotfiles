dotfiles
========

All of my (public) complete dotfiles. Includes my .vim plugins and customizations

Because of the use of submodules, the initial clone should be done via:

    git clone --recursive ...

Enjoy

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
