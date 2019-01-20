#!/usr/bin/env bash
#### Shell options, history settings, etc.
unset HISTFILE
set -o noclobber		# use >| to overwrite files
# shopt -s cdable_vars
shopt -s cdspell
shopt -s checkhash
shopt -s failglob
shopt -s histreedit
shopt -s lithist
shopt -s nocaseglob
shopt -s no_empty_cmd_completion
shopt -s shift_verbose

if (("$BASH_VERSINFO" == 4)); then
	shopt -s autocd
	shopt -s checkjobs
	shopt -s dirspell
	shopt -s globstar
fi

CDPATH=".:~:.."
#### General
# ls
alias l="ls -F"
alias la="l -A"
alias ll="l -lh"
alias lla="ll -A"
alias lr="l -R"
alias lra="lr -A"
# dir stack manipulation (inspired by Forth)
swap () { pushd "$@" >/dev/null; }
drop () { popd "$@" >/dev/null; }
pick () { swap "${DIRSTACK[$1]}"; }
roll () {
	local -i i="$1"
	pick "$i" && let 'i++' && drop "+${i}"
}
alias p="pushd"; complete -o nospace -F _cd p
alias d="dirs -v"
alias over="pick 1 && dirs"
alias nip="drop +1 && dirs"
alias tuck="swap && over"
alias rot="roll 2 && dirs"
alias tor="swap && swap +1 && swap && swap -0 && dirs"
ndrop () {
	local -i i=0 bound="${1:-1}"
	for ((; i<bound; i++)); do
		drop
		(($?)) && break
	done
	dirs
}

#### PERL
# alias newpm="h2xs -AX --skip-exporter --use-new-tests -n"
alias pd="perldoc"

#### NETWORK
alias exip='dig +short myip.opendns.com @resolver1.opendns.com'
alias inip='ipconfig getifaddr en0'

#### WRAPPERS
alias rlwrap='rlwrap -np red -H /dev/null'
alias dc='rlwrap dc'
alias ed='rlwrap ed -p "ed> "'
alias sbcl='rlwrap sbcl --noinform'
alias top='top -o cpu'

#### OTHER
alias ct='VISUAL=vim crontab'
alias rc="git --git-dir=$HOME/.files/ --work-tree=$HOME"
alias h='history'
alias ihr='du -hcd0'
alias j='jobs'
alias kmax='emacsclient -e "(kill-emacs)"'
alias mptest='mpv --input-test --force-window --idle'
alias n='nnn -lc6'
alias scat='source-highlight -f esc -o /dev/stdout -i'
alias serve='python3 -m http.server 8000'
alias x='chmod u+x'
#### SILLY
alias wheniseaster='ncal -e'

#### FUNCTIONS
# crude dictionary search
# function dct() { grep -Ei '$*\W' ~/Documents/wb.txt; }
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
	((! bound && bound++))

	local opwd="$PWD"
	for ((; i<bound; i++)); do
		cd ../
		if [[ "$PWD" == / ]]; then
			break
		fi
	done
	OLDPWD="$opwd"
}

# resize terminal; escape \rs to use rs(1)
rs () {
	local cols="${1:-80}" lines="${2:-24}"
	printf "\e[8;%d;%dt" "$lines" "$cols"
}

#### BEGIN MacOS
## BREW RELATED
alias bccl='brew cask cleanup'
alias bch='brew cask home'
alias bci='brew cask info'
alias brau='brew update && brew upgrade --ignore-pinned && brcl'
alias brcl='brew cleanup -s && brew prune'
alias bd='brew deps --tree --installed'
alias bh='brew home'
alias bi='brew info'
alias bls='brew leaves'
alias bs='brew search'

alias a='open -a'
alias ffx='/Applications/Firefox.app/Contents/MacOS/firefox-bin'
alias hs='o /usr/local/opt/hyperspec/share/doc/hyperspec/HyperSpec/Front/index.htm'
# function lprun() { perl -e "$(pbpaste | perl -pe 'tr/\015/\n/' | vipe)"; }
alias pbcl='echo | pbcopy'
alias pbed='pbpaste | vipe | pbcopy'
alias shuf='perl -MList::Util -e "print List::Util::shuffle <>;"'
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

# coordinates of mouse cursor
alias maus='cliclick p'
# RGB color value of pixel at cursor point
rgb () { cliclick "cp:$(maus)"; }
#### END MacOS

#### Temps
hh () {
	eval "$(history | fzf --tac +s \
				| awk '{$1=""; print substr($0,2);}')"
}

fk () {
	ps -axo pid,%cpu,command \
		| fzf --header-lines=1 --query="$1" \
		| awk '{print $1}' | xargs kill -"${2:-9}"
}

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
					printf \
						"\tnot a function/alias/variable: %s\n" "$1"
				fi
		esac
		shift
	done
}; complete -afv save

funced () { eval "$(declare -f "$1" | vipe)"; }
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

# alias cl='clisp -norc -q'
alias nuke='history -c; hash -r'
