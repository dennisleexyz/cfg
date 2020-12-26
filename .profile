#!/bin/sh
export BROWSER=lynx

export SHELL=/usr/bin/zsh
export XDG_CONFIG_HOME="$HOME/.config"
	export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# pidof syncthing >/dev/null || syncthing -no-browser >/dev/null &

[ $SSH_CONNECTION ] && [ -n "$PS1" ] && {
	if type dvtm; then exec dvtm
	elif type tmux; then tmux a || exec tmux && exit
	fi
}
exec $SHELL
