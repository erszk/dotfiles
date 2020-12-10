#!/usr/bin/env bash
#### Shell options, history settings, etc.
unset HISTFILE
set -o noclobber		# use >| to overwrite files
# shopt -s cdable_vars
shopt -s cdspell
shopt -s checkhash
shopt -s extglob
shopt -s failglob
shopt -s histreedit
shopt -s lithist
shopt -s nocaseglob
shopt -s no_empty_cmd_completion
shopt -s shift_verbose
# REQUIRES BASH 4
shopt -s autocd
shopt -s checkjobs
shopt -s dirspell
shopt -s globstar

#### General
# ls
alias l="ls -F"
alias la="l -A"
alias ll="l -lSh"
# dir stack manipulation (inspired by Forth)
cd () { builtin cd "$@" && update_terminal_cwd; }
pushd () { builtin pushd "$@" && update_terminal_cwd; }
popd () { builtin popd "$@" && update_terminal_cwd; }
pick () { pushd "${DIRSTACK[$1]}"; }
alias p="pushd"
alias d="dirs -v"
alias nip="popd +1"
alias over="pick 1"
alias tuck="pushd >/dev/null && over"
alias rot="pick 2 >/dev/null && popd +3"

#### NETWORK
alias exip='dig +short myip.opendns.com @resolver1.opendns.com'
alias inip='ipconfig getifaddr en0'

#### WRAPPERS
alias clisp='clisp -norc -q'
alias dc='rlwrap dc'
alias rlwrap='rlwrap -np red -H /dev/null'
alias sbcl='rlwrap sbcl --noinform'
alias sftp='rlwrap sftp'
alias top='top -o cpu'

#### OTHER
alias h='history'
alias j='jobs'
alias lm='latexmk -pdf -pv'
alias nuke='history -c; hash -r; LINENO=1'
alias pd="perldoc"
alias rc="git --git-dir=$HOME/.files/ --work-tree=$HOME"
alias scat='source-highlight -f esc -o /dev/stdout -i'
alias serve='python3 -m http.server'
alias x='chmod u+x'

#### FUNCTIONS
m () { mpv "$(pbpaste)"; }
# prevent computer from falling asleep while bash/pid running
woke () {
	local pid
	if (($# == 0)); then
		pid="$$"
	else
		pid="$(pgrep -in "$1")"
	fi
	caffeinate -disuw "$pid"
}
pstat () { echo "${PIPESTATUS[@]}"; }
# quickly traverse up directories
u () {
	local -i i=0 bound="${1:-1}"
	((! bound && bound++)) # default to 1 if bad user input

	local opwd="$PWD"
	for ((; i<bound; i++)); do
		cd ../
		if [[ "$PWD" == / ]]; then
			break # don't go above root
		fi
	done
	OLDPWD="$opwd"
}

# resize terminal.app; \rs or command rs for rs(1)
rs () {
	local cols="${1:-80}" lines="${2:-24}"
	printf "\e[8;%d;%dt" "$lines" "$cols"
}

#### BEGIN MacOS
## BREW RELATED
alias b='brew'
alias brau='brew update; brew upgrade --ignore-pinned; brew upgrade --cask; brcl'
alias brcl='brew cleanup -s; brew cleanup --prune-prefix'

alias a='open -a'
alias bt='blueutil --power toggle'
alias pbcl='echo | pbcopy'
alias pbed='pbpaste | vipe | pbcopy'
alias t='trash'
alias tac='tail -r'

# cd to directory open in *topmost* Finder window
cdf () {
	cd -- "$(osascript -e \
		"tell application \"Finder\"
			POSIX path of (target of window 1 as alias)
		end tell")"
}

o () {
	if ((! $#)); then
		open ./
	else
		open "$@"
	fi
}

# RGB color value of pixel at cursor point
rgb () { cliclick "cp:$(cliclick p)"; }
#### END MacOS

hh () {
	eval "$(history | fzf --tac +s | awk '{$1=""; print substr($0,2);}')"
}

fk () {
	ps -axo pid,%cpu,command \
		| fzf --header-lines=1 --query="$1" \
		| awk '{print $1}' | xargs kill -"${2:-9}" 2>/dev/null
}

# TODO: allow for different file other than .bashrc?
save () {
	while (($#)); do
		case "$(type -t "$1")" in
			alias)
				alias "$1" | tee -a ~/.bashrc;;
			function)
				declare -f "$1" | tee -a ~/.bashrc;;
			*)
				if declare -p "$1" >/dev/null; then
					declare -p "$1" | tee -a ~/.bash_profile
				else
					printf "\tnot a function/alias/variable: %s\n" "$1"
				fi
		esac
		shift
	done
}; complete -afv save

# funced () { eval "$(declare -f "$1" | vipe)"; }
pp () {
	while (($#)); do
		case "$(type -t "$1")" in
			alias)
				echo "${BASH_ALIASES[$1]}";;
			function)
				declare -f "$1";;
			builtin|keyword)
				help "$1";;
			file)
				file "$(type -p "$1")";;
			*)
				declare -p "$1" 2>/dev/null
		esac

		if (("$#" > 1)); then
			printf "########################################\n"
		fi
		shift
	done
}; complete -afbcv pp
