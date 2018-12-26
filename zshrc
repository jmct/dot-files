# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/jmct/.zshrc'

autoload -Uz compinit promptinit
compinit
promptinit

export PATH=$HOME/root/bin:$HOME/.cabal/bin:$PATH

prompt walters
