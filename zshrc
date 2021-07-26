# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/jmct/.zshrc'

autoload -Uz compinit promptinit
compinit
promptinit

export EDITOR=vim
export PATH=$HOME/.cabal/bin:$HOME/.local/bin:$PATH

prompt redhat

# Keybindings that are not part of zsh defaults:
bindkey "\e[3~" delete-char
