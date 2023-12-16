#!/bin/ksh
##shellcheck disable=1091,2034,2164

#autoload -U compinit
#compinit -d "$XDG_CACHE_HOME/zcompdump"

#autoload -U promptinit
#promptinit
#prompt adam1

setopt autocd

bindkey -v
REPORTTIME=-1
unsetopt extendedglob

HISTFILE="$XDG_DATA_HOME/histfile"
HISTSIZE=2147483647
SAVEHIST=$HISTSIZE

#bindkey -v

#bindkey -s '^r' '. "${ZDOTDIR:-$HOME}/.zshrc"\n'
#bindkey -s '^o' 'ranger_cd\n'
#bindkey -s '^a' 'bc -lq\n'
#bindkey -s '^n' 'newsboat\n'

# plugins="/usr/share/zsh/plugins"

# . $plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# . $plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# pushd >/dev/null && cd /usr/share/zsh && [ -d plugins ] && cd plugins
# 	. zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
# 	. zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
# popd >/dev/null

#alias c='cfg'
#if type nvim >/dev/null; then
#	alias \
#	ex='nvim -e' \
#	vi='nvim' \
#	vim='nvim' \

#else
#	alias \
#	ex='vim -e' \
#	vi='vim' \

#fi
#alias diff='diff --color=always'
#alias ls='ls --color=always'
#alias grep='grep --color=always'
#alias less='less -FR --mouse'
#alias g=git
#alias s=sudo
#alias t=task
#alias y=yadm
#[ "$TERM" = xst-256color ] && TERM=st-256color

#eval "$(fasd --init auto)"

##https://github.com/Liupold/pidswallow#autostart
#[ -n "$DISPLAY" ]  && command -v xdo >/dev/null 2>&1 && xdo id > /tmp/term-wid-"$$"
#trap "( rm -f /tmp/term-wid-"$$" )" EXIT HUP

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# . /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
bindkey "^[[5~" history-beginning-search-backward
bindkey "^[[6~" history-beginning-search-forward
. /usr/share/doc/ranger/examples/shell_automatic_cd.sh 2>/dev/null || bindkey -s '^o' '^uranger_cd\n'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
