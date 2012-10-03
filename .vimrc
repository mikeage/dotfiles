set nocompatible
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin
