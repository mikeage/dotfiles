# Custom .bashrc; collected from quite a few places on the internet. Not even going to attempt to list them all..
# shellcheck disable=SC2001,SC1091,SC1090

[[ -d /opt/homebrew/bin ]] && export PATH="/opt/homebrew/bin:$PATH"

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

#################
# General stuff #
#################

shopt -s checkwinsize

if which nvim >/dev/null; then
	export EDITOR=nvim
	alias nvimdiff='nvim -d'
else
	export EDITOR=vim
fi

if which thefuck >/dev/null; then
	eval "$(thefuck --alias oof)"
fi

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

#
if [[ "$(set -o | grep 'emacs\|\bvi\b' | cut -f2 | tr '\n' ':')" != 'off:off:' ]]; then
	# Immediately add a trailing slash when autocompleting symlinks to directories
	bind "set mark-symlinked-directories on"

	# Enable history expansion with space
	# E.g. typing !!<space> will replace the !! with your last command
	bind Space:magic-space
fi

###################
# History options #
###################

export HISTSIZE=100000000
export HISTCONTROL=ignorespace:ignoredups # erasedups -- this messes with chronology
shopt -s histappend

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
if [ "$(uname)" == "Darwin" ]; then
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
if [ "$(uname)" == "Darwin" ]; then
	export CLICOLOR=YES
else
	DIRCOLORSDB="$(dirname "$(readlink -f ~/.bashrc)")/dircolors-solarized/dircolors.ansi-universal"
	if [ ! -f "$DIRCOLORSDB" ]; then
		export LS_COLORS='di=01;33:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'
	else
		DIRCOLORS=$(dircolors "$DIRCOLORSDB" 2>/dev/null)
		if [ "$DIRCOLORS" == "" ]; then
			DIRCOLORS="$(dircolors --sh "$DIRCOLORSDB")"
		fi
		eval "$DIRCOLORS"
	fi
fi

############
# Homebrew #
############
if which brew >/dev/null; then
	HOMEBREW_PREFIX="$(brew --prefix)"
	export PATH=${HOMEBREW_PREFIX}/coreutils/libexec/gnubin:$PATH
	export PATH=${HOMEBREW_PREFIX}/sbin:$PATH
fi

##################
# Autocompletion #
##################
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f /usr/local/share/bash-completion/bash_completion ] && . /usr/local/share/bash-completion/bash_completion
[ -r /usr/local/etc/profile.d/bash_completion.sh ] && . /usr/local/etc/profile.d/bash_completion.sh

for COMPLETION in "/usr/local/etc/bash_completion.d/"*; do
	[[ -r "$COMPLETION" ]] && source "$COMPLETION"
done

if [ -n "${HOMEBREW_PREFIX}" ]; then
	[ -r "${HOMEBREW_PREFIX}/etc/bash_completion" ] && . "${HOMEBREW_PREFIX}/etc/bash_completion"
	source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
	[ -r "${HOMEBREW_PREFIX}/share/bash-completion/bash_completion" ] && . "${HOMEBREW_PREFIX}/share/bash-completion/bash_completion"
	for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
		[[ -r "$COMPLETION" ]] && source "$COMPLETION"
	done
	[ -r "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc" ] && . "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
	[ -f "${HOMEBREW_PREFIX}/share/google-cloud-sdk/path.bash.inc" ] && source "${HOMEBREW_PREFIX}/share/google-cloud-sdk/path.bash.inc"
	source "${HOMEBREW_PREFIX}/Cellar/modules"/*/init/bash_completion
fi

###########################
# Prompt related goodness #
###########################

# In case we don't have the __git_ps1 available, for any reason, at least print the branch
__local_git_ps1() {
	local b
	b="$(git symbolic-ref HEAD 2>/dev/null)"
	if [ -n "$b" ]; then
		printf " (%s)" "${b##refs/heads/}"
	fi
}

get_CLOUDSDK_ACTIVE_CONFIG_NAME() {
	echo "${CLOUDSDK_ACTIVE_CONFIG_NAME}"
}

if [[ "$(set -o | grep 'emacs\|\bvi\b' | cut -f2 | tr '\n' ':')" != 'off:off:' ]]; then
	# shellcheck disable=SC2016
	command -v __git_ps1 >/dev/null 2>&1 && GITPS1='$(__git_ps1 " {%s}")' || GITPS1='$(__local_git_ps1 " {%s}")'
	GIT_PS1_SHOWDIRTYSTATE=1
	GIT_PS1_SHOWUNTRACKEDFILES=1
	GIT_PS1_SHOWSTASHSTATE=1
	GIT_PS1_SHOWUPSTREAM="verbose"
	GREEN="$(tput setaf 2)"
	RED="$(tput setaf 1)"
	#YELLOW="$(tput setaf 3)"
	CYAN="$(tput setaf 6)"
	GRAY="$(tput setaf 7)"
	# export PS1="\`_ret=\$?; if [ \$_ret = 0 ]; then echo -en \"${GREEN}\"; else echo -en \"${RED}\"; fi; printf "%3d" \$_ret\` ${CYAN}\u@\h ${RED}\w${CYAN}${GITPS1}\\\$${GRAY} \[\`printf "\\\e[?1004l"\`\]"
	#export PS1='$(_ret=$?; if [ $_ret = 0 ]; then echo -en "\[${GREEN}\]"; else echo -en "\[${RED}\]"; fi; printf "%3d" $_ret)\[${CYAN}\] \u@\h $(if [ $KUBECONFIG ]; then echo -en "\[${GREEN}\](k:$(basename $KUBECONFIG | rev | cut -d'-' -f1 | rev)) "; fi)$(if [ $CLOUDSDK_ACTIVE_CONFIG_NAME ]; then echo -en "\[${YELLOW}\](g:$(basename $CLOUDSDK_ACTIVE_CONFIG_NAME)) "; fi)\[${RED}\]\w\[${CYAN}\]'${GITPS1}'\$\[${GRAY}\] '
	# shellcheck disable=SC2154
	export PS1='$(_ret=$?; if [ $_ret = 0 ]; then echo -en "\[${GREEN}\]"; else echo -en "\[${RED}\]"; fi; printf "%3d" $_ret)\[${CYAN}\] \u@\h $(if [ $HYPERSCALE_ENV ]; then echo -en "\[${GREEN}\](e:$HYPERSCALE_ENV) "; fi)\[${RED}\]\w\[${CYAN}\]'${GITPS1}'\$\[${GRAY}\] '
fi

##############
# tmux stuff #
##############
# Open the given command in a new tmux session. If the session already exists, re-open it, and don't rerun the command
function tmuxify() {
	tmux new-session -A -s "$*" "exec $*"
} # End function tmuxify

# When reconnecting a tmux session, the DISPLAY variable will retain it's previous value. This fixes that.
alias fix_display="eval export \`tmux show-environment | grep DISPLAY\`"
if [[ $- =~ "i" ]]; then
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
if [ "$(uname)" == "Darwin" ]; then
	BASHRC_DIR="$(dirname "$(greadlink -f "${BASH_SOURCE[0]}")")"
else
	BASHRC_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
fi
# Originally, we called this from .bashrc directly. However, when running in xquartz, it passes /Applications/Utilities/XQuartz.app/Contents/MacOS/X11.bin as the first argument, which caused this script to exit on the exit 1 on or about line 46. So now we'll do it within a function so there's no $1
fzf_without_args() {
	source "$BASHRC_DIR/fzf-git.sh/fzf-git.sh"
}
fzf_without_args

# export FZF_TMUX=1
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.iterm2_shell_integration.bash ] && source ~/.iterm2_shell_integration.bash
[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash
[ -f /usr/local/opt/modules/init/bash ] && source /usr/local/opt/modules/init/bash
[ -f /opt/homebrew/opt/modules/init/bash ] && source /opt/homebrew/opt/modules/init/bash
export MODULEPATH=$BASHRC_DIR/modules:$MODULEPATH

if [[ -f $BASHRC_DIR/.bashrc.local ]]; then
	source "$BASHRC_DIR/.bashrc.local"
fi

function akeyless_cert() {
	CERT_PATH="$*"
	AKEYLESS_TOKEN=$(akeyless auth --access-type ldap --access-id "$AKEYLESS_ACCESS_ID" --ldap_proxy_url "$AKEYLESS_LDAP_PROXY_URL" --username "$(whoami)" --password "$(cat ~/.ldappassword)" | grep -o 't-[^"]*')
	SUFFIX=$(echo "$CERT_PATH" | sed 's/\//_/g')
	SSH_PUBLIC_KEY="$HOME/.ssh/id_ed25519.${SUFFIX}.pub"
	if [ ! -f "$SSH_PUBLIC_KEY" ]; then
		cp ~/.ssh/id_ed25519.pub "$SSH_PUBLIC_KEY"
	fi
	akeyless get-ssh-certificate --cert-username centos --cert-issuer-name "${AKEYLESS_CERT_ISSUER_PREFIX}/${CERT_PATH}/${AKEYLESS_CERT_ISSUER_SUFFIX}" --public-key-file-path "$SSH_PUBLIC_KEY" --legacy-signing-alg-name --token "$AKEYLESS_TOKEN"
}

listening() {
	if [ $# -eq 0 ]; then
		sudo lsof -iTCP -sTCP:LISTEN -n -P
	elif [ $# -eq 1 ]; then
		sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color "$1"
	else
		echo "Usage: listening [pattern]"
	fi
}

export PATH="$PATH:$HOME/.local/bin"
export LC_ALL=en_US.UTF-8
export GOPATH=$HOME/go
export PATH="$PATH:$GOPATH/bin"
export PATH="/usr/local/sbin:$PATH"
# Add .NET Core SDK tools
export PATH="$PATH:/Users/mikemi/.dotnet/tools"
export DOTNET_ROOT="/usr/local/opt/dotnet/libexec"
