#!/bin/ksh
#shellcheck disable=1091,2034,2164

autoload -U compinit
compinit -d "$XDG_CACHE_HOME/zcompdump"

autoload -U promptinit
promptinit
prompt adam1

setopt autocd

HISTSIZE=2147483647
SAVEHIST=$HISTSIZE
HISTFILE="$XDG_DATA_HOME/histfile"
setopt hist_ignore_all_dups
setopt hist_ignore_space

bindkey -s '^r' '. "${ZDOTDIR:-$HOME}/.zshrc"\n'
bindkey -s '^o' 'ranger_cd\n'

pushd >/dev/null && cd /usr/share/zsh && [ -d plugins ] && cd plugins
	. zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
	. zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
popd >/dev/null

. /usr/share/doc/ranger/examples/shell_automatic_cd.sh 2>/dev/null

alias c='cfg'
if type nvim >/dev/null; then
	alias \
	ex='nvim -e' \
	vi='nvim' \
	vim='nvim' \

else
	alias \
	ex='vim -e' \
	vi='vim' \

fi
alias ls='ls --color=auto'
[ $TERM = xst-256color ] && TERM=st-256color
