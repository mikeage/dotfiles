dotfiles
========

All of my (public) complete dotfiles.

Because of the use of submodules, the initial clone should be done via:

    git clone --recursive ...

Enjoy

```bash
cd ~
git clone --recursive https://github.com/mikeage/dotfiles.git
ln -s ~/dotfiles/{.inputrc,.bashrc,.cvsignore,.rsync-exclude,.pylintrc,.zshrc} ~/ -f
rm .bash_profile
ln -s .bashrc .bash_profile
mkdir -p ~/.config
ln -s ~/dotfiles/config/{nvim,alacritty,tmux,yazi} ~/.config/

```

## Font(s)

### Building locally

```bash
mkdir ~/fonts-to-patch
cp /System/Library/Fonts/Monaco.ttf ~/fonts-to-patch/
docker run --rm -v $HOME/fonts-to-patch:/in -v $HOME/Library/Fonts/:/out nerdfonts/patcher --complete
rm -rf ~/fonts-to-patch
```

### Download prebuilt (better, because Monospaced and with Bold/Italic/BoldItalic)

Download from https://github.com/thep0y/monaco-nerd-font, and choose MonacoNerdFontMono.zip

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
