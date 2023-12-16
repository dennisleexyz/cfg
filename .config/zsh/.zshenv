#!/bin/sh

#shellcheck disable=2155
export VISUAL=$(type nvim >/dev/null 2>&1 && echo nvim || echo vim)
export EDITOR=$VISUAL

#shellcheck disable=2046
export $(dbus-launch) #kdeconnect-indicator
export MOZ_USE_XINPUT2=1
# export QT_QPA_PLATFORMTHEME=gtk2
# export QT_QPA_PLATFORM_PLUGIN_PATH=/usr/lib/qt/plugins
export SUDO_ASKPASS="$HOME/.local/bin/dmenupass"
export TERMINAL=kitty
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

#https://wiki.contextgarden.net/Use_the_fonts_you_want#Fonts_location_on_your_computer
export OSFONTDIR=$HOME/.fonts:/usr/share/fonts

export SSB_HOME="$XDG_DATA_HOME"/zoom

export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npmrc

export XDG_DATA_HOME=$HOME/.local/share
	export LESSHISTFILE=$XDG_DATA_HOME/lesshst
	# export GNUPGHOME=$XDG_DATA_HOME/gnupg
	export PASSWORD_STORE_DIR=$XDG_DATA_HOME/password-store
	export GOPATH=$XDG_DATA_HOME/go

export PATH=$HOME/.local/bin:$HOME/bin:$XDG_DATA_HOME/npm/bin:$PATH

export PYTHONPATH=/usr/lib/python3.10/site-packages

export XDG_CACHE_HOME=$HOME/.cache

export XDG_DATA_DIRS=/usr/local/share/:/usr/share/:$XDG_DATA_HOME
