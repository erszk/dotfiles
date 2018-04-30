#!/usr/bin/env bash
#### Shell options, history settings, etc.
unset HISTFILE
set -o noclobber		# use >| to overwrite files
shopt -s cdable_vars
shopt -s cdspell
shopt -s checkhash
shopt -s histreedit
shopt -s lithist
shopt -s no_empty_cmd_completion
shopt -s nullglob
shopt -s shift_verbose

if [ "$BASH_VERSINFO" -eq 4 ]; then
    shopt -s autocd
    shopt -s checkjobs
    shopt -s dirspell
    shopt -s globstar
fi

#### cdable_vars
c="$HOME/code"
d="$HOME/Desktop"
dl="$HOME/Downloads"
doc="$HOME/Documents"
m="$HOME/Music"

#### General
# ls
alias l="ls -F"
alias la="l -A"
alias ll="l -lh"
alias lla="ll -A"
alias lr="l -R"
alias lra="lr -A"
# dir stack manipulation (inspired by Forth)
function swap() { pushd "$@" >/dev/null; }
function drop() { popd "$@" >/dev/null; }
function pick() { eval "swap $(dirs "$1")"; }
function roll() {
    local i="$1"
    pick "$i" && let 'i++' && drop +"$i"
}
alias p="pushd"
alias d="dirs -v"
alias over="pick +1"
alias nip="drop +1"
alias tuck="swap && over"
alias rot="roll +2"
alias tor="swap && swap +1 && swap && swap -0"
alias 2drop="drop && drop" # ndrop function?
# alias 2dup="over && over"
# alias 2nip="drop +2 && drop +2"
# alias 2over="pick +3 && pick +3"
# alias 2swap="2over && drop +4 && drop +4"
# alias 2rot="roll +5 && roll +5"

#### PERL
# alias newpm="h2xs -AX --skip-exporter --use-new-tests -n"
alias pd="perldoc"

#### NETWORK
alias exip='dig +short myip.opendns.com @resolver1.opendns.com'
alias inip='ipconfig getifaddr en0'

#### OTHER
alias dot="git --git-dir=$HOME/.files/ --work-tree=$HOME"
alias g="git"
alias h="history"
alias ihr="du -hcd0"
alias j="jobs"
alias n="nnn -lc6"
alias rlwrap="rlwrap -np red -H /dev/null"
alias scat='source-highlight -f esc -o /dev/stdout -i'
alias serve="python3 -m http.server 8000"
alias top="top -o cpu"
alias x='chmod u+x'
#### SILLY
alias wheniseaster="ncal -e"

#### FUNCTIONS
# crude dictionary search
# function dct() { grep -Ei "$*\W" ~/Documents/wb.txt; }
# prevent computer from falling asleep while bash/pid running
function woke() {
    local pid
    if [ "$#" -eq 0 ]; then
	pid="$$"
    else
	pid="$(pgrep -in "$1")"
    fi
    caffeinate -disuw "$pid"
}
function pstat() { echo "${PIPESTATUS[@]}"; }
# quickly add a *permanent* alias
function pals() {
    eval "$(printf 'alias %s="%s"' "$1" "$2")"
    alias "$1" >> ~/.bashrc
}
function pdfcat() {
    # use last arg as outfile and rest as inputs
    local out="${!#}"
    gs -q -sPAPERSIZE=a4 -dNOPAUSE -dBATCH \
       -sDEVICE=pdfwrite -sOutputFile="$out" "${@:1:$(($#-1))}"
}
# quickly traverse up directories
function u() {
    local i
    for (( i=0; i<${1:-1}; i++ )); do
	cd ../
    done
}

# resize terminal; escape \rs to use rs(1)
function rs() {
    local cols="${1:-80}"
    local lines="${2:-24}"
    printf "\e[8;%d;%dt" "$lines" "$cols"
}

#### SOURCE EXTRAS
# [ -d ~/code/sourced ] && . ~/code/sourced/*
[ -d /usr/local/etc/bash_completion.d ] \
    && . /usr/local/etc/bash_completion.d/*

#### BEGIN MacOS
## BREW RELATED
alias bccl="brew cask cleanup"
alias bch="brew cask home"
alias bci="brew cask info"
alias bcs="brew cask search"
alias brau="brew update && brew upgrade && brcl"
alias brcl="brew cleanup -s && brew prune"
alias brdp="brew deps --tree --installed"
alias brh="brew home"
alias bri="brew info"
alias brls="brew leaves"
alias brs="brew search"

alias a="open -a"
alias ffx="/Applications/Firefox.app/Contents/MacOS/firefox-bin"
# alias hs="o '/usr/local/Cellar/hyperspec/7.0/share/doc/hyperspec/HyperSpec/Front/index.htm'"
# function lprun() { perl -e "$(pbpaste | perl -pe 'tr/\015/\n/' | vipe)"; }
alias pbcl="echo '' | pbcopy"
alias shuf="perl -MList::Util -e 'print List::Util::shuffle <>;'"
alias t="trash"
alias tac="tail -r"

# cd to directory open in *topmost* Finder window
function cdf() {
    cd "$(osascript -e "tell application \"Finder\" to POSIX path of (target of window 1 as alias)")"
}

function o() {
    if [ "$#" -eq 0 ]; then
	open ./
    else
	open "$@"
    fi
}

# coordinates of mouse cursor
alias maus="cliclick p | cut -c 25-"
# RGB color value of pixel at cursor point
function rgb() { cliclick "cp:$(maus)"; }
#### END MacOS

#### Temps
