# Custom .bashrc; collected from quite a few places on the internet. Not even going to attempt to list them all..

###########################
# Solarized related stuff #
###########################
# We use a fake terminal type to signal that the terminal emulator is configured with solarized colors. The proper thing to do would be to pass an environment variable directly, but the servers don't accept this
if [[ "$TERM" == *-solarized* ]]
then
	ORIGTERM="$TERM"
	export TERM=`echo $ORIGTERM | sed "s/-solarized.*$//"`
	export SOLARIZED=`echo $ORIGTERM | sed "s/^.*-solarized//"`
	unset ORIGTERM
fi

# Support solarized mintty's
if [[ -f ~/.minttyrc ]]
then
	export SOLARIZED=$(grep -i solarized .minttyrc | cut -d"=" -f2)
fi

#######################
# Work specific stuff #
#######################

# For some reason, some systems forcibly set this to /etc/inputrc
if [ -f "$HOME/.inputrc" ]; then
	export INPUTRC=$HOME/.inputrc
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Legacy xNDS Linux server config
if [[ -f /mnt/Fusion/mmiller/common/bin/_bashrc ]]; then
	source /mnt/Fusion/mmiller/common/bin/_bashrc
fi

# Cygwin, by default, does not include DOMAINNAME.
command -v domainname > /dev/null 2>&1 && DOMAINNAME=`domainname`

alias sshcpe='sshpass -p erdk ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -l root'
alias sshhe='sshpass -p Nat0d12 ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -l root'

# Override github status checks
function approve() {
	REPO="$1"
	COMMIT="$2"
	CHECK="$3"
	curl -XPOST https://github3.cisco.com/api/v3/repos/$REPO/statuses/$COMMIT?access_token=$CSWCI_ACCESS_TOKEN --data '{"state": "success", "context": "'$CHECK'"}'
}

#################
# General stuff #
#################

shopt -s checkwinsize
export EDITOR=vim
# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Immediately add a trailing slash when autocompleting symlinks to directories
bind "set mark-symlinked-directories on"

###################
# History options #
###################
export HISTSIZE=100000000
shopt -s histappend

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

#export PROMPT_COMMAND='history -a ; history -n'
export PROMPT_COMMAND='history -a'


######################
# Colors everywhere! #
######################

# Generic colorizer
if [[ -f /usr/local/etc/grc.bashrc ]]; then
	source /usr/local/etc/grc.bashrc
fi

export LS_OPTIONS='-F'
if [ "$(uname)" == "Darwin" ]
then
	export LS_OPTIONS="$LS_OPTIONS -G"
else
	export LS_OPTIONS="$LS_OPTIONS --color=auto"
fi

alias ls='ls $LS_OPTIONS'
alias grep='grep --color=auto'

# Pass colors, don't clear the screen, and don't use LESS if there's less than one screenful
export LESS='-R -X -F'

alias vim='vim -X'

# Check for dircolors-solarized
if [ "$(uname)" == "Darwin" ]
then
	export CLICOLOR=YES
else
	DIRCOLORSDB=`dirname \`readlink -f ~/.bashrc\``/dircolors-solarized/dircolors.ansi-universal
	if [ ! -f $DIRCOLORSDB ]
	then
		export LS_COLORS='di=01;33:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
	else
		DIRCOLORS=$(dircolors $DIRCOLORSDB 2>/dev/null)
		if [ "x$DIRCOLORS" == "x" ]; then
			DIRCOLORS=$(dircolors --sh $DIRCOLORSDB)
		fi
		eval $DIRCOLORS
	fi
fi

############
# Homebrew #
############
if $(which brew > /dev/null)
then
	export PATH=/usr/local/coreutils/libexec/gnubin:$PATH
	# Keep python2 in the path, since homebrew breaks the python convention
	export PATH="/usr/local/opt/python@2/bin:$PATH"
fi

##################
# Autocompletion #
##################
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f /usr/local/share/bash-completion/bash_completion ] && . /usr/local/share/bash-completion/bash_completion
[ -f /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc ] && . /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc

if type brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
    [[ -r "$COMPLETION" ]] && source "$COMPLETION"
  done
fi
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

if [ -f /usr/local/etc/bash_completion.d/git-prompt.sh ]; then
	source /usr/local/etc/bash_completion.d/git-prompt.sh
fi

###########################
# Prompt related goodness #
###########################

# In case we don't have the __git_ps1 available, for any reason, at least print the branch
__local_git_ps1 ()
{
	local b="$(git symbolic-ref HEAD 2>/dev/null)";
	if [ -n "$b" ]; then
		printf " (%s)" "${b##refs/heads/}";
	fi
}

command -v __git_ps1 > /dev/null 2>&1 && GITPS1='$(__git_ps1 " {%s}")' || GITPS1='$(__local_git_ps1 " {%s}")'
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUPSTREAM="verbose"
GREEN="$(tput setaf 2)"
RED="$(tput setaf 1)"
CYAN="$(tput setaf 6)"
GRAY="$(tput setaf 7)"
# export PS1="\`_ret=\$?; if [ \$_ret = 0 ]; then echo -en \"${GREEN}\"; else echo -en \"${RED}\"; fi; printf "%3d" \$_ret\` ${CYAN}\u@\h ${RED}\w${CYAN}${GITPS1}\\\$${GRAY} \[\`printf "\\\e[?1004l"\`\]"
export PS1='$(_ret=$?; if [ $_ret = 0 ]; then echo -en "\[${GREEN}\]"; else echo -en "\[${RED}\]"; fi; printf "%3d" $_ret)\[${CYAN}\] \u@\h \[${RED}\]\w\[${CYAN}\]'${GITPS1}'\$\[${GRAY}\] '

##############
# tmux stuff #
##############
# Open the given command in a new tmux session. If the session already exists, re-open it, and don't rerun the command
function tmuxify() {
	tmux new-session -A -s "$*" "exec $*"
} # End function tmuxify

# When reconnecting a tmux session, the DISPLAY variable will retain it's previous value. This fixes that.
alias fix_display="eval export \`tmux show-environment | grep DISPLAY\`"
if [[ $- =~ "i" ]]
then
	if [[ -d /usr/local/tmuxifier ]]; then
		export PATH="/usr/local/tmuxifier/bin:$PATH"
		eval "$(tmuxifier init -)"
	fi
	if [[ -d $HOME/.tmuxifier ]]; then
		export PATH="$HOME/.tmuxifier/bin:$PATH"
		eval "$(tmuxifier init -)"
	fi
fi

##########
# Python #
##########
# Only allow pip within a virtual environment
export PIP_REQUIRE_VIRTUALENV=true
alias gpip='PIP_REQUIRE_VIRTUALENV="" pip'
alias gpip3='PIP_REQUIRE_VIRTUALENV="" pip3'
alias gpip2='PIP_REQUIRE_VIRTUALENV="" pip2'

#########################
# fzf for fuzzy finding #
#########################
if [ "$(uname)" == "Darwin" ]
then
	BASHRC_DIR="$(dirname "$(greadlink -f ${BASH_SOURCE[0]})")"
else
	BASHRC_DIR="$(dirname "$(readlink -f ${BASH_SOURCE[0]})")"
fi
source $BASHRC_DIR/fzf-git/functions.sh
source $BASHRC_DIR/fzf-git/key-binding.bash
export FZF_TMUX=1
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.iterm2_shell_integration.bash ] && source ~/.iterm2_shell_integration.bash

safari_history() {
	local cols sep
	cols=$(( COLUMNS / 3 ))
	sep='{::}'

	sqlite3 -separator $sep ~/Library/Safari/History.db "SELECT substr(title, 1, $cols), url FROM history_visits INNER JOIN history_items ON history_items.id = history_visits.history_item ORDER BY history_items.id;" |
		awk -F '{::}' '{printf "%-'$cols's \x1b[36m%s\x1b[m\n", $1, $2}' |
		fzf --ansi --multi |
		sed 's#.*\(https*://\)#\1#' |
		xargs open > /dev/null 2>/dev/null
}

export LPASS_AGENT_TIMEOUT=0
lastpass() {
	local cols sep
	cols=$(( COLUMNS / 3 ))
	sep='{::}'

	lpass ls --format="%ai${sep}%/as%/ag%/an${sep}%al" |
		awk -F "$sep" '{printf "%s %s %s\n", $1, $2, $3}' |
		fzf --ansi
}
#alias lastpass='lpass show -c --password $(lpass ls | fzf | awk '\''{print $NF}'\'' | sed '\''s/\]//g'\'')'

function rain() {
	curl --silent "https://api.weather.com/v2/pws/observations/current?apiKey=6532d6454b8aa370768e63d6ba5a832e&stationId=$1&numericPrecision=decimal&format=json&units=m" | jq '.observations[0].metric.precipRate, .observations[0].metric.precipTotal'
}

if [[ -f $BASHRC_DIR/.bashrc.local ]]; then
	source $BASHRC_DIR/.bashrc.local
fi

listening() {
	if [ $# -eq 0 ]; then
		sudo lsof -iTCP -sTCP:LISTEN -n -P
	elif [ $# -eq 1 ]; then
		sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
	else
		echo "Usage: listening [pattern]"
	fi
}

export PATH="$PATH:/Users/mikemi/.local/bin"
export LC_ALL=en_US.UTF-8
export GOPATH=$HOME/go
export PATH="$PATH:$GOPATH/bin"
export PATH="/usr/local/sbin:$PATH"
# Add .NET Core SDK tools
export PATH="$PATH:/Users/mikemi/.dotnet/tools"
export DOTNET_ROOT="/usr/local/opt/dotnet/libexec"
