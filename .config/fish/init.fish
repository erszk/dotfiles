set greeting

if command -sq go; and test -d $HOME/code/go
	set -x GOPATH $HOME/code/go
	set PATH $GOPATH/bin $PATH
end

if test -d $HOME/bin
	set PATH $HOME/bin $PATH
end

set -x EDITOR emacsclient -ca emacs
set -x PAGER less
set -x VISUAL $EDITOR

set -x EMAIL thompson.louis@gmail.com
set -x NAME Louis Thompson

set -x LC_ALL C

set -x LESS -iR
set -x LESSHISTFILE /dev/null
set -x GREP_OPTIONS --color=auto

# set -x FISH_HISTFILE /dev/null

switch (uname)
	case Darwin
		set -x HOMEBREW_CASK_OPTS --appdir=/Applications
		# set -x SHELL_SESSION_HISTORY 0
		set -x NNN_COPIER copier
		set -x NNN_OPENER open
		set -x NNN_DE_FILE_MANAGER open

		set -x CLICOLOR 1
		set -x LSCOLORS GxFxHxHxCxdgedabagacad
end

if test $SHLVL -eq 1
	welcome
end

### end of .bash_profile translation
### beginning of .bashrc translation

abbr -a ec emacsclient -n
abbr -a g git
abbr -a h history
abbr -a j jobs
abbr -a n nnn -lc6
abbr -a pd perldoc
abbr -a p pushd
abbr -a scat pygmentize

# alias dup="p ."

# Mac
abbr -a a open -a
abbr -a bccl brew cask cleanup
abbr -a bch brew cask home
abbr -a bci brew cask info
abbr -a bri brew info
abbr -a brdp brew deps --tree --installed
abbr -a brh brew home
abbr -a brls brew leaves
abbr -a brs brew search
abbr -a ffx /Applications/Firefox.app/Contents/MacOS/firefox-bin
abbr -a t trash

if command -sq issw
	issw com.apple.keylayout.USExtended >/dev/null
end

