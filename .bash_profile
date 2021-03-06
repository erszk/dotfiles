#!/usr/bin/env bash
#### prompts
set_prompt () {
	local status="$?"
	local bold cyan green red r prompt fail=""
	bold='\[\e[1m\]' cyan='\[\e[36m\]'
	green='\[\e[32m\]' red='\[\e[91m\]'
	r='\[\e(B\e[m\]'

	if ((status)); then
		printf -v fail '\U274C %s%d%s ' "$red" "$status" "$r"
	fi
	printf -v PS1 '%b\\!%b %b[\\A]%b %b\\u%b %b\\w%b\n%b; ' \
		   "$green" "$r" "$bold" "$r" "$cyan" "$r" "$red" "$r" "$fail"
}
export PROMPT_COMMAND=set_prompt
export PROMPT_DIRTRIM=3
export PS2="-> "

#### the way, the truth and the light
export PATH
if command -v go >/dev/null && [ -d "$HOME/code/go" ]; then
	export GOPATH="$HOME/code/go"
	PATH="$GOPATH/bin:$PATH"
fi
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
[ -d /usr/local/opt/gnu-getopt/bin ] \
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

#### misc
export LESS="-iR"		# smart case
export LESSHISTFILE="/dev/null"
export GREP_OPTIONS="--color=auto"
export FZF_DEFAULT_OPTS="--border=bottom --inline-info
	--bind ctrl-j:page-down,ctrl-k:page-up,alt-j:jump-accept
	--bind ctrl-i:select-all,ctrl-o:deselect-all,ctrl-t:top
	--filepath-word --tiebreak=length,end,begin"

#### BEGIN MacOS
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export SHELL_SESSION_HISTORY=0
export NNN_COPIER="copier"

# For BSD-style ls
export CLICOLOR=1
export LSCOLORS="GxFxHxHxCxdgedabagacad"

# ensure US keyboard is being used
if command -v issw >/dev/null; then
	issw com.apple.keylayout.USExtended >/dev/null 2>&1
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
