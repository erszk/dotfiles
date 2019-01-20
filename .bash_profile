#!/usr/bin/env bash
#### prompts
function prompt() {
	local BOLD CYAN GREEN RED R LAMBDA
	BOLD="\[$(tput bold)\]"
	CYAN="\[$(tput setaf 6)\]"
	GREEN="\[$(tput setaf 2)\]"
	RED="\[$(tput setaf 9)\]"
	R="\[$(tput sgr0)\]" # reset
	printf -v LAMBDA "%s\u03bb%s" "$RED" "$R"
	echo "$GREEN\!$R $BOLD<\A>$R $CYAN\u$R@\h $RED\W$R\n$LAMBDA "
}
export PS1="$(prompt)" PS2="-> "
unset prompt

#### the way, the truth and the light
export PATH
if command -v go >/dev/null && [ -d "$HOME/code/go" ]; then
	export GOPATH="$HOME/code/go"
	PATH="$GOPATH/bin:$PATH"
fi
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
test -d /usr/local/opt/gnu-getopt/bin \
	&& PATH="/usr/local/opt/gnu-getopt/bin:$PATH"

#### Perl - bootstrap @INC
if [ -d "$HOME/pkg/perl5" ]; then
	eval "$(perl -I "$HOME/pkg/perl5/lib/perl5" \
				 -Mlocal::lib="$HOME/pkg/perl5")"
fi

#### core user variables
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"
export PAGER="less"
export VISUAL="emacsclient -c"

#### locale
export LANG="de_DE.UTF-8"
export LC_ALL="$LANG"
# export LC_COLLATE="C" LC_CTYPE="C"

#### misc
export LESS="-iR"		# smart case
export LESSHISTFILE="/dev/null"
export GREP_OPTIONS="--color=auto"
export FZF_DEFAULT_OPTS="--border --inline-info --exact --multi
	--bind ctrl-j:page-down,ctrl-k:page-up,alt-j:jump-accept
	--bind ctrl-i:select-all,ctrl-o:deselect-all,ctrl-t:top
	--filepath-word --tiebreak=length,end,begin"

#### BEGIN MacOS
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export SHELL_SESSION_HISTORY=0
export NNN_COPIER="copier"
export NNN_OPENER="open"
export NNN_DE_FILE_MANAGER="open"

# For BSD-style ls
export CLICOLOR=1
export LSCOLORS="GxFxHxHxCxdgedabagacad"

# ensure US keyboard is being used
if command -v issw >/dev/null; then
	issw com.apple.keylayout.USExtended >/dev/null
fi
#### END MacOS

# won't run for vim shell escape etc
if [ "$SHLVL" -eq 1 ]; then
	welcome
fi

#### source other startup files
[ -r ~/.env ] && . ~/.env
[ -r ~/.bashrc ] && . ~/.bashrc
# completion
if [ -f /usr/local/share/bash-completion/bash_completion ]; then
	. /usr/local/share/bash-completion/bash_completion
fi
