# Custom .bashrc; collected from quite a few places on the internet. Not even going to attempt to list them all..
# shellcheck disable=SC2001,SC1091,SC1090

# Helper functions for better cross-platform compatibility
command_exists() {
	command -v "$1" >/dev/null 2>&1
}

safe_source() {
	[[ -r "$1" ]] && source "$1"
}

# Platform detection
if [[ "$(uname)" == "Darwin" ]]; then
	is_mac=true
else
	is_mac=false
fi

# Use the right readlink command
get_real_path() {
	if $is_mac; then
		# shellcheck disable=SC2015
		command_exists greadlink && greadlink -f "$1" || readlink -f "$1"
	else
		readlink -f "$1"
	fi
}

# PATH manipulation functions
prepend_path() {
	if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
		export PATH="$1:$PATH"
	fi
}

append_path() {
	if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
		export PATH="$PATH:$1"
	fi
}

# Add Homebrew paths
if [[ -d /opt/homebrew/bin ]]; then
	prepend_path "/opt/homebrew/bin"
elif [[ -d /usr/local/Homebrew/bin ]]; then
	prepend_path "/usr/local/Homebrew/bin"
fi

#######################
# Work specific stuff #
#######################

# For some reason, some systems forcibly set this to /etc/inputrc
if [ -f "$HOME/.inputrc" ]; then
	export INPUTRC=$HOME/.inputrc
fi

# Source global definitions
safe_source /etc/bashrc

#################
# General stuff #
#################

shopt -s checkwinsize

if command_exists nvim; then
	export EDITOR=nvim
	alias nvimdiff='nvim -d'
else
	export EDITOR=vim
fi

if command_exists thefuck; then
	eval "$(thefuck --alias oof)"
fi

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Shell mode detection for enhanced capabilities
if [[ "$(set -o | grep 'emacs\|\bvi\b' | cut -f2 | tr '\n' ':')" != 'off:off:' ]]; then
	# Immediately add a trailing slash when autocompleting symlinks to directories
	bind "set mark-symlinked-directories on"

	# Enable history expansion with space
	# E.g. typing !!<space> will replace the !! with your last command
	bind Space:magic-space
fi

shopt -s cdspell  # Auto-correct typos in cd commands
shopt -s dirspell # Auto-correct directory names during completion

###################
# History options #
###################

export HISTSIZE=100000000
# export HISTCONTROL=ignorespace:ignoredups # erasedups -- this messes with chronology
export HISTTIMEFORMAT="%F %T "
export HISTIGNORE="ls:cd:pwd:exit:date:* --help:clear"

shopt -s histappend # Append to the history file, don't overwrite it
shopt -s cmdhist # Save multi-line commands as one line

export PROMPT_COMMAND='history -a; history -n'
#; echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'

######################
# Colors everywhere! #
######################

# Generic colorizer
safe_source /usr/local/etc/grc.bashrc

export LS_OPTIONS='-F'
# Mac OS X used to use -G, but now it also respects --color=auto
export LS_OPTIONS="$LS_OPTIONS --color=auto"

alias ls='ls $LS_OPTIONS'
alias grep='grep --color=auto'

# Pass colors, don't clear the screen, and don't use LESS if there's less than one screenful
export LESS='-R -X -F'

alias vim='vim -X'

# Check for dircolors-solarized
if $is_mac; then
	export CLICOLOR=YES
	if command_exists gls; then
		alias ls='gls $LS_OPTIONS'
	fi
fi

if command_exists vivid; then
	LS_COLORS="$(vivid generate molokai)"
else
	# Cached on 2024-12-26 (long LS_COLORS definition unchanged)
	LS_COLORS='*~=0;38;2;122;112;112:bd=0;38;2;102;217;239;48;2;51;51;51:ca=0:cd=0;38;2;249;38;114;48;2;51;51;51:di=0;38;2;102;217;239:do=0;38;2;0;0;0;48;2;249;38;114:ex=1;38;2;249;38;114:fi=0:ln=0;38;2;249;38;114:mh=0:mi=0;38;2;0;0;0;48;2;255;74;68:no=0:or=0;38;2;0;0;0;48;2;255;74;68:ow=0:pi=0;38;2;0;0;0;48;2;102;217;239:rs=0:sg=0:so=0;38;2;0;0;0;48;2;249;38;114:st=0:su=0:tw=0:*.1=0;38;2;226;209;57:*.a=1;38;2;249;38;114:*.c=0;38;2;0;255;135:*.d=0;38;2;0;255;135:*.h=0;38;2;0;255;135:*.m=0;38;2;0;255;135:*.o=0;38;2;122;112;112:*.p=0;38;2;0;255;135:*.r=0;38;2;0;255;135:*.t=0;38;2;0;255;135:*.v=0;38;2;0;255;135:*.z=4;38;2;249;38;114:*.7z=4;38;2;249;38;114:*.ai=0;38;2;253;151;31:*.as=0;38;2;0;255;135:*.bc=0;38;2;122;112;112:*.bz=4;38;2;249;38;114:*.cc=0;38;2;0;255;135:*.cp=0;38;2;0;255;135:*.cr=0;38;2;0;255;135:*.cs=0;38;2;0;255;135:*.db=4;38;2;249;38;114:*.di=0;38;2;0;255;135:*.el=0;38;2;0;255;135:*.ex=0;38;2;0;255;135:*.fs=0;38;2;0;255;135:*.go=0;38;2;0;255;135:*.gv=0;38;2;0;255;135:*.gz=4;38;2;249;38;114:*.ha=0;38;2;0;255;135:*.hh=0;38;2;0;255;135:*.hi=0;38;2;122;112;112:*.hs=0;38;2;0;255;135:*.jl=0;38;2;0;255;135:*.js=0;38;2;0;255;135:*.ko=1;38;2;249;38;114:*.kt=0;38;2;0;255;135:*.la=0;38;2;122;112;112:*.ll=0;38;2;0;255;135:*.lo=0;38;2;122;112;112:*.ma=0;38;2;253;151;31:*.mb=0;38;2;253;151;31:*.md=0;38;2;226;209;57:*.mk=0;38;2;166;226;46:*.ml=0;38;2;0;255;135:*.mn=0;38;2;0;255;135:*.nb=0;38;2;0;255;135:*.nu=0;38;2;0;255;135:*.pl=0;38;2;0;255;135:*.pm=0;38;2;0;255;135:*.pp=0;38;2;0;255;135:*.ps=0;38;2;230;219;116:*.py=0;38;2;0;255;135:*.rb=0;38;2;0;255;135:*.rm=0;38;2;253;151;31:*.rs=0;38;2;0;255;135:*.sh=0;38;2;0;255;135:*.so=1;38;2;249;38;114:*.td=0;38;2;0;255;135:*.ts=0;38;2;0;255;135:*.ui=0;38;2;166;226;46:*.vb=0;38;2;0;255;135:*.wv=0;38;2;253;151;31:*.xz=4;38;2;249;38;114:*FAQ=0;38;2;0;0;0;48;2;230;219;116:*.3ds=0;38;2;253;151;31:*.3fr=0;38;2;253;151;31:*.3mf=0;38;2;253;151;31:*.adb=0;38;2;0;255;135:*.ads=0;38;2;0;255;135:*.aif=0;38;2;253;151;31:*.amf=0;38;2;253;151;31:*.ape=0;38;2;253;151;31:*.apk=4;38;2;249;38;114:*.ari=0;38;2;253;151;31:*.arj=4;38;2;249;38;114:*.arw=0;38;2;253;151;31:*.asa=0;38;2;0;255;135:*.asm=0;38;2;0;255;135:*.aux=0;38;2;122;112;112:*.avi=0;38;2;253;151;31:*.awk=0;38;2;0;255;135:*.bag=4;38;2;249;38;114:*.bak=0;38;2;122;112;112:*.bat=1;38;2;249;38;114:*.bay=0;38;2;253;151;31:*.bbl=0;38;2;122;112;112:*.bcf=0;38;2;122;112;112:*.bib=0;38;2;166;226;46:*.bin=4;38;2;249;38;114:*.blg=0;38;2;122;112;112:*.bmp=0;38;2;253;151;31:*.bsh=0;38;2;0;255;135:*.bst=0;38;2;166;226;46:*.bz2=4;38;2;249;38;114:*.c++=0;38;2;0;255;135:*.cap=0;38;2;253;151;31:*.cfg=0;38;2;166;226;46:*.cgi=0;38;2;0;255;135:*.clj=0;38;2;0;255;135:*.com=1;38;2;249;38;114:*.cpp=0;38;2;0;255;135:*.cr2=0;38;2;253;151;31:*.cr3=0;38;2;253;151;31:*.crw=0;38;2;253;151;31:*.css=0;38;2;0;255;135:*.csv=0;38;2;226;209;57:*.csx=0;38;2;0;255;135:*.cxx=0;38;2;0;255;135:*.dae=0;38;2;253;151;31:*.dcr=0;38;2;253;151;31:*.dcs=0;38;2;253;151;31:*.deb=4;38;2;249;38;114:*.def=0;38;2;0;255;135:*.dll=1;38;2;249;38;114:*.dmg=4;38;2;249;38;114:*.dng=0;38;2;253;151;31:*.doc=0;38;2;230;219;116:*.dot=0;38;2;0;255;135:*.dox=0;38;2;166;226;46:*.dpr=0;38;2;0;255;135:*.drf=0;38;2;253;151;31:*.dxf=0;38;2;253;151;31:*.eip=0;38;2;253;151;31:*.elc=0;38;2;0;255;135:*.elm=0;38;2;0;255;135:*.epp=0;38;2;0;255;135:*.eps=0;38;2;253;151;31:*.erf=0;38;2;253;151;31:*.erl=0;38;2;0;255;135:*.exe=1;38;2;249;38;114:*.exr=0;38;2;253;151;31:*.exs=0;38;2;0;255;135:*.fbx=0;38;2;253;151;31:*.fff=0;38;2;253;151;31:*.fls=0;38;2;122;112;112:*.flv=0;38;2;253;151;31:*.fnt=0;38;2;253;151;31:*.fon=0;38;2;253;151;31:*.fsi=0;38;2;0;255;135:*.fsx=0;38;2;0;255;135:*.gif=0;38;2;253;151;31:*.git=0;38;2;122;112;112:*.gpr=0;38;2;253;151;31:*.gvy=0;38;2;0;255;135:*.h++=0;38;2;0;255;135:*.hda=0;38;2;253;151;31:*.hip=0;38;2;253;151;31:*.hpp=0;38;2;0;255;135:*.htc=0;38;2;0;255;135:*.htm=0;38;2;226;209;57:*.hxx=0;38;2;0;255;135:*.ico=0;38;2;253;151;31:*.ics=0;38;2;230;219;116:*.idx=0;38;2;122;112;112:*.igs=0;38;2;253;151;31:*.iiq=0;38;2;253;151;31:*.ilg=0;38;2;122;112;112:*.img=4;38;2;249;38;114:*.inc=0;38;2;0;255;135:*.ind=0;38;2;122;112;112:*.ini=0;38;2;166;226;46:*.inl=0;38;2;0;255;135:*.ino=0;38;2;0;255;135:*.ipp=0;38;2;0;255;135:*.iso=4;38;2;249;38;114:*.jar=4;38;2;249;38;114:*.jpg=0;38;2;253;151;31:*.jsx=0;38;2;0;255;135:*.jxl=0;38;2;253;151;31:*.k25=0;38;2;253;151;31:*.kdc=0;38;2;253;151;31:*.kex=0;38;2;230;219;116:*.kra=0;38;2;253;151;31:*.kts=0;38;2;0;255;135:*.log=0;38;2;122;112;112:*.ltx=0;38;2;0;255;135:*.lua=0;38;2;0;255;135:*.m3u=0;38;2;253;151;31:*.m4a=0;38;2;253;151;31:*.m4v=0;38;2;253;151;31:*.mdc=0;38;2;253;151;31:*.mef=0;38;2;253;151;31:*.mid=0;38;2;253;151;31:*.mir=0;38;2;0;255;135:*.mkv=0;38;2;253;151;31:*.mli=0;38;2;0;255;135:*.mos=0;38;2;253;151;31:*.mov=0;38;2;253;151;31:*.mp3=0;38;2;253;151;31:*.mp4=0;38;2;253;151;31:*.mpg=0;38;2;253;151;31:*.mrw=0;38;2;253;151;31:*.msi=4;38;2;249;38;114:*.mtl=0;38;2;253;151;31:*.nef=0;38;2;253;151;31:*.nim=0;38;2;0;255;135:*.nix=0;38;2;166;226;46:*.nrw=0;38;2;253;151;31:*.obj=0;38;2;253;151;31:*.obm=0;38;2;253;151;31:*.odp=0;38;2;230;219;116:*.ods=0;38;2;230;219;116:*.odt=0;38;2;230;219;116:*.ogg=0;38;2;253;151;31:*.ogv=0;38;2;253;151;31:*.orf=0;38;2;253;151;31:*.org=0;38;2;226;209;57:*.otf=0;38;2;253;151;31:*.otl=0;38;2;253;151;31:*.out=0;38;2;122;112;112:*.pas=0;38;2;0;255;135:*.pbm=0;38;2;253;151;31:*.pcx=0;38;2;253;151;31:*.pdf=0;38;2;230;219;116:*.pef=0;38;2;253;151;31:*.pgm=0;38;2;253;151;31:*.php=0;38;2;0;255;135:*.pid=0;38;2;122;112;112:*.pkg=4;38;2;249;38;114:*.png=0;38;2;253;151;31:*.pod=0;38;2;0;255;135:*.ppm=0;38;2;253;151;31:*.pps=0;38;2;230;219;116:*.ppt=0;38;2;230;219;116:*.pro=0;38;2;166;226;46:*.ps1=0;38;2;0;255;135:*.psd=0;38;2;253;151;31:*.ptx=0;38;2;253;151;31:*.pxn=0;38;2;253;151;31:*.pyc=0;38;2;122;112;112:*.pyd=0;38;2;122;112;112:*.pyo=0;38;2;122;112;112:*.qoi=0;38;2;253;151;31:*.r3d=0;38;2;253;151;31:*.raf=0;38;2;253;151;31:*.rar=4;38;2;249;38;114:*.raw=0;38;2;253;151;31:*.rpm=4;38;2;249;38;114:*.rst=0;38;2;226;209;57:*.rtf=0;38;2;230;219;116:*.rw2=0;38;2;253;151;31:*.rwl=0;38;2;253;151;31:*.rwz=0;38;2;253;151;31:*.sbt=0;38;2;0;255;135:*.sql=0;38;2;0;255;135:*.sr2=0;38;2;253;151;31:*.srf=0;38;2;253;151;31:*.srw=0;38;2;253;151;31:*.stl=0;38;2;253;151;31:*.stp=0;38;2;253;151;31:*.sty=0;38;2;122;112;112:*.svg=0;38;2;253;151;31:*.swf=0;38;2;253;151;31:*.swp=0;38;2;122;112;112:*.sxi=0;38;2;230;219;116:*.sxw=0;38;2;230;219;116:*.tar=4;38;2;249;38;114:*.tbz=4;38;2;249;38;114:*.tcl=0;38;2;0;255;135:*.tex=0;38;2;0;255;135:*.tga=0;38;2;253;151;31:*.tgz=4;38;2;249;38;114:*.tif=0;38;2;253;151;31:*.tml=0;38;2;166;226;46:*.tmp=0;38;2;122;112;112:*.toc=0;38;2;122;112;112:*.tsx=0;38;2;0;255;135:*.ttf=0;38;2;253;151;31:*.txt=0;38;2;226;209;57:*.typ=0;38;2;226;209;57:*.usd=0;38;2;253;151;31:*.vcd=4;38;2;249;38;114:*.vim=0;38;2;0;255;135:*.vob=0;38;2;253;151;31:*.vsh=0;38;2;0;255;135:*.wav=0;38;2;253;151;31:*.wma=0;38;2;253;151;31:*.wmv=0;38;2;253;151;31:*.wrl=0;38;2;253;151;31:*.x3d=0;38;2;253;151;31:*.x3f=0;38;2;253;151;31:*.xlr=0;38;2;230;219;116:*.xls=0;38;2;230;219;116:*.xml=0;38;2;226;209;57:*.xmp=0;38;2;166;226;46:*.xpm=0;38;2;253;151;31:*.xvf=0;38;2;253;151;31:*.yml=0;38;2;166;226;46:*.zig=0;38;2;0;255;135:*.zip=4;38;2;249;38;114:*.zsh=0;38;2;0;255;135:*.zst=4;38;2;249;38;114:*TODO=1:*hgrc=0;38;2;166;226;46:*.avif=0;38;2;253;151;31:*.bash=0;38;2;0;255;135:*.braw=0;38;2;253;151;31:*.conf=0;38;2;166;226;46:*.dart=0;38;2;0;255;135:*.data=0;38;2;253;151;31:*.diff=0;38;2;0;255;135:*.docx=0;38;2;230;219;116:*.epub=0;38;2;230;219;116:*.fish=0;38;2;0;255;135:*.flac=0;38;2;253;151;31:*.h264=0;38;2;253;151;31:*.hack=0;38;2;0;255;135:*.heif=0;38;2;253;151;31:*.hgrc=0;38;2;166;226;46:*.html=0;38;2;226;209;57:*.iges=0;38;2;253;151;31:*.info=0;38;2;226;209;57:*.java=0;38;2;0;255;135:*.jpeg=0;38;2;253;151;31:*.json=0;38;2;166;226;46:*.less=0;38;2;0;255;135:*.lisp=0;38;2;0;255;135:*.lock=0;38;2;122;112;112:*.make=0;38;2;166;226;46:*.mojo=0;38;2;0;255;135:*.mpeg=0;38;2;253;151;31:*.nims=0;38;2;0;255;135:*.opus=0;38;2;253;151;31:*.orig=0;38;2;122;112;112:*.pptx=0;38;2;230;219;116:*.prql=0;38;2;0;255;135:*.psd1=0;38;2;0;255;135:*.psm1=0;38;2;0;255;135:*.purs=0;38;2;0;255;135:*.raku=0;38;2;0;255;135:*.rlib=0;38;2;122;112;112:*.sass=0;38;2;0;255;135:*.scad=0;38;2;0;255;135:*.scss=0;38;2;0;255;135:*.step=0;38;2;253;151;31:*.tbz2=4;38;2;249;38;114:*.tiff=0;38;2;253;151;31:*.toml=0;38;2;166;226;46:*.usda=0;38;2;253;151;31:*.usdc=0;38;2;253;151;31:*.usdz=0;38;2;253;151;31:*.webm=0;38;2;253;151;31:*.webp=0;38;2;253;151;31:*.woff=0;38;2;253;151;31:*.xbps=4;38;2;249;38;114:*.xlsx=0;38;2;230;219;116:*.yaml=0;38;2;166;226;46:*stdin=0;38;2;122;112;112:*v.mod=0;38;2;166;226;46:*.blend=0;38;2;253;151;31:*.cabal=0;38;2;0;255;135:*.cache=0;38;2;122;112;112:*.class=0;38;2;122;112;112:*.cmake=0;38;2;166;226;46:*.ctags=0;38;2;122;112;112:*.dylib=1;38;2;249;38;114:*.dyn_o=0;38;2;122;112;112:*.gcode=0;38;2;0;255;135:*.ipynb=0;38;2;0;255;135:*.mdown=0;38;2;226;209;57:*.patch=0;38;2;0;255;135:*.rmeta=0;38;2;122;112;112:*.scala=0;38;2;0;255;135:*.shtml=0;38;2;226;209;57:*.swift=0;38;2;0;255;135:*.toast=4;38;2;249;38;114:*.woff2=0;38;2;253;151;31:*.xhtml=0;38;2;226;209;57:*Icon\r=0;38;2;122;112;112:*LEGACY=0;38;2;0;0;0;48;2;230;219;116:*NOTICE=0;38;2;0;0;0;48;2;230;219;116:*README=0;38;2;0;0;0;48;2;230;219;116:*go.mod=0;38;2;166;226;46:*go.sum=0;38;2;122;112;112:*passwd=0;38;2;166;226;46:*shadow=0;38;2;166;226;46:*stderr=0;38;2;122;112;112:*stdout=0;38;2;122;112;112:*.bashrc=0;38;2;0;255;135:*.config=0;38;2;166;226;46:*.dyn_hi=0;38;2;122;112;112:*.flake8=0;38;2;166;226;46:*.gradle=0;38;2;0;255;135:*.groovy=0;38;2;0;255;135:*.ignore=0;38;2;166;226;46:*.matlab=0;38;2;0;255;135:*.nimble=0;38;2;0;255;135:*COPYING=0;38;2;182;182;182:*INSTALL=0;38;2;0;0;0;48;2;230;219;116:*LICENCE=0;38;2;182;182;182:*LICENSE=0;38;2;182;182;182:*TODO.md=1:*VERSION=0;38;2;0;0;0;48;2;230;219;116:*.alembic=0;38;2;253;151;31:*.desktop=0;38;2;166;226;46:*.gemspec=0;38;2;166;226;46:*.mailmap=0;38;2;166;226;46:*Doxyfile=0;38;2;166;226;46:*Makefile=0;38;2;166;226;46:*TODO.txt=1:*setup.py=0;38;2;166;226;46:*.DS_Store=0;38;2;122;112;112:*.cmake.in=0;38;2;166;226;46:*.fdignore=0;38;2;166;226;46:*.kdevelop=0;38;2;166;226;46:*.markdown=0;38;2;226;209;57:*.rgignore=0;38;2;166;226;46:*.tfignore=0;38;2;166;226;46:*CHANGELOG=0;38;2;0;0;0;48;2;230;219;116:*COPYRIGHT=0;38;2;182;182;182:*README.md=0;38;2;0;0;0;48;2;230;219;116:*bun.lockb=0;38;2;122;112;112:*configure=0;38;2;166;226;46:*.gitconfig=0;38;2;166;226;46:*.gitignore=0;38;2;166;226;46:*.localized=0;38;2;122;112;112:*.scons_opt=0;38;2;122;112;112:*.timestamp=0;38;2;122;112;112:*CODEOWNERS=0;38;2;166;226;46:*Dockerfile=0;38;2;166;226;46:*INSTALL.md=0;38;2;0;0;0;48;2;230;219;116:*README.txt=0;38;2;0;0;0;48;2;230;219;116:*SConscript=0;38;2;166;226;46:*SConstruct=0;38;2;166;226;46:*.cirrus.yml=0;38;2;230;219;116:*.gitmodules=0;38;2;166;226;46:*.synctex.gz=0;38;2;122;112;112:*.travis.yml=0;38;2;230;219;116:*INSTALL.txt=0;38;2;0;0;0;48;2;230;219;116:*LICENSE-MIT=0;38;2;182;182;182:*MANIFEST.in=0;38;2;166;226;46:*Makefile.am=0;38;2;166;226;46:*Makefile.in=0;38;2;122;112;112:*.applescript=0;38;2;0;255;135:*.fdb_latexmk=0;38;2;122;112;112:*.webmanifest=0;38;2;166;226;46:*CHANGELOG.md=0;38;2;0;0;0;48;2;230;219;116:*CONTRIBUTING=0;38;2;0;0;0;48;2;230;219;116:*CONTRIBUTORS=0;38;2;0;0;0;48;2;230;219;116:*appveyor.yml=0;38;2;230;219;116:*configure.ac=0;38;2;166;226;46:*.bash_profile=0;38;2;0;255;135:*.clang-format=0;38;2;166;226;46:*.editorconfig=0;38;2;166;226;46:*CHANGELOG.txt=0;38;2;0;0;0;48;2;230;219;116:*.gitattributes=0;38;2;166;226;46:*.gitlab-ci.yml=0;38;2;230;219;116:*CMakeCache.txt=0;38;2;122;112;112:*CMakeLists.txt=0;38;2;166;226;46:*LICENSE-APACHE=0;38;2;182;182;182:*pyproject.toml=0;38;2;166;226;46:*CODE_OF_CONDUCT=0;38;2;0;0;0;48;2;230;219;116:*CONTRIBUTING.md=0;38;2;0;0;0;48;2;230;219;116:*CONTRIBUTORS.md=0;38;2;0;0;0;48;2;230;219;116:*.sconsign.dblite=0;38;2;122;112;112:*CONTRIBUTING.txt=0;38;2;0;0;0;48;2;230;219;116:*CONTRIBUTORS.txt=0;38;2;0;0;0;48;2;230;219;116:*requirements.txt=0;38;2;166;226;46:*package-lock.json=0;38;2;122;112;112:*CODE_OF_CONDUCT.md=0;38;2;0;0;0;48;2;230;219;116:*.CFUserTextEncoding=0;38;2;122;112;112:*CODE_OF_CONDUCT.txt=0;38;2;0;0;0;48;2;230;219;116:*azure-pipelines.yml=0;38;2;230;219;116'
fi
export LS_COLORS

############
# Homebrew #
############
if command_exists brew; then
	HOMEBREW_PREFIX="$(brew --prefix)"
	prepend_path "${HOMEBREW_PREFIX}/coreutils/libexec/gnubin"
	prepend_path "${HOMEBREW_PREFIX}/sbin"
fi

##################
# Autocompletion #
##################
# Function to source all completion scripts in a directory
source_completion_dir() {
	if [[ -d "$1" ]]; then
		for completion in "$1"/*; do
			[[ -r "$completion" ]] && source "$completion"
		done
	fi
}

# Common completion paths to try
completion_paths=(
	"/usr/local/etc/bash_completion"
	"/usr/local/share/bash-completion/bash_completion"
	"/usr/local/etc/profile.d/bash_completion.sh"
	"/etc/bash_completion"
)

# Source the first available main completion file
for completion_path in "${completion_paths[@]}"; do
	if [[ -r "$completion_path" ]]; then
		source "$completion_path"
		break
	fi
done

# Source completions from standard directories
source_completion_dir "/usr/local/etc/bash_completion.d"

# Homebrew completions
if [[ -n "${HOMEBREW_PREFIX}" ]]; then
	safe_source "${HOMEBREW_PREFIX}/etc/bash_completion"
	safe_source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
	safe_source "${HOMEBREW_PREFIX}/share/bash-completion/bash_completion"
	source_completion_dir "${HOMEBREW_PREFIX}/etc/bash_completion.d"

	# GCP specific completions
	safe_source "${HOMEBREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
	safe_source "${HOMEBREW_PREFIX}/share/google-cloud-sdk/path.bash.inc"

	# Modules completion
	if [[ -d "${HOMEBREW_PREFIX}/Cellar/modules" ]]; then
		safe_source "${HOMEBREW_PREFIX}/Cellar/modules"/*/init/bash_completion
	fi
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
	# Use the built-in __git_ps1 if available, otherwise use our local version
	if command -v __git_ps1 >/dev/null 2>&1; then
		# shellcheck disable=SC2016
		GITPS1='$(__git_ps1 " {%s}")'
	else
		# shellcheck disable=SC2016
		GITPS1='$(__local_git_ps1 " {%s}")'
	fi

	export GIT_PS1_SHOWDIRTYSTATE=1
	export GIT_PS1_SHOWUNTRACKEDFILES=1
	export GIT_PS1_SHOWSTASHSTATE=1
	export GIT_PS1_SHOWUPSTREAM="verbose"
	GREEN="$(tput setaf 2)"
	RED="$(tput setaf 1)"
	#YELLOW="$(tput setaf 3)"
	CYAN="$(tput setaf 6)"
	GRAY="$(tput setaf 7)"

	# shellcheck disable=SC2154
	export PS1='$(_ret=$?; if [ $_ret = 0 ]; then echo -en "\[${GREEN}\]"; else echo -en "\[${RED}\]"; fi; printf "%3d" $_ret)\[${CYAN}\] \u@\h $(if [ $HYPERSCALE_ENV ]; then echo -en "\[${GREEN}\](e:$HYPERSCALE_ENV) "; fi)\[${RED}\]\w\[${CYAN}\]'${GITPS1}'\$\[${GRAY}\] '
fi

##############
# tmux stuff #
##############
# Only define tmux functions if tmux is available
if command_exists tmux; then
	# Open the given command in a new tmux session. If the session already exists, re-open it, and don't rerun the command
	tmuxify() {
		if [[ $# -eq 0 ]]; then
			echo "Usage: tmuxify <command>" >&2
			return 1
		fi
		tmux new-session -A -s "$*" "exec $*"
	}

	# When reconnecting a tmux session, the DISPLAY variable will retain it's previous value. This fixes that.
	if [[ -n "$TMUX" ]]; then
		alias fix_display="eval export \$(tmux show-environment | grep DISPLAY)"
	fi
fi

# Load tmuxifier if available (only in interactive shells)
if [[ $- =~ "i" ]]; then
	for tmuxifier_dir in "/usr/local/tmuxifier" "$HOME/.tmuxifier"; do
		if [[ -d "$tmuxifier_dir" ]]; then
			prepend_path "${tmuxifier_dir}/bin"
			eval "$(tmuxifier init -)" 2>/dev/null
			break
		fi
	done
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
# Get the directory of this script in a cross-platform way
BASHRC_DIR="$(dirname "$(get_real_path "${BASH_SOURCE[0]}")")"

# Set default options with the appropriate preview command
# Set file finder command based on available tools
if command_exists bat; then
	export FZF_PREVIEW_COMMAND="bat --color=always --style=numbers --line-range=:500 {}"
else
	export FZF_PREVIEW_COMMAND="cat {}"
fi
if command_exists fd; then
	export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --exclude node_modules"
	export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git --exclude node_modules"
else
	export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/\.git/*' -not -path '*/node_modules/*' -not -path '*/\.*/' 2>/dev/null"
	export FZF_ALT_C_COMMAND="find . -type d -not -path '*/\.git/*' -not -path '*/node_modules/*' -not -path '*/\.*/' 2>/dev/null"
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--height 40% --border"
export FZF_CTRL_T_OPTS="--preview '$FZF_PREVIEW_COMMAND' --preview-window=right:60%"
export FZF_ALT_C_OPTS="--preview 'ls -la {}'"

# Source fzf-git.sh safely
safe_source "${BASHRC_DIR}/fzf-git.sh/fzf-git.sh"
safe_source ~/.fzf.bash
safe_source ~/.iterm2_shell_integration.bash
safe_source /usr/share/doc/fzf/examples/key-bindings.bash

# Source modules
for modules_path in "/usr/local/opt/modules/init/bash" "/opt/homebrew/opt/modules/init/bash"; do
	safe_source "$modules_path"
done

# Set module path
if [[ -d "$BASHRC_DIR/modules" ]]; then
	export MODULEPATH=$BASHRC_DIR/modules:${MODULEPATH:-}
fi

# Source local config
if [[ -f "$BASHRC_DIR/.bashrc.local" ]]; then
	source "$BASHRC_DIR/.bashrc.local"
fi

# Improved akeyless_cert function with better error handling
akeyless_cert() {
	if [[ $# -eq 0 ]]; then
		echo "Error: Certificate path required" >&2
		return 1
	fi

	if ! command_exists akeyless; then
		echo "Error: akeyless command not found" >&2
		return 1
	fi

	if [[ ! -f ~/.ldappassword ]]; then
		echo "Error: LDAP password file not found" >&2
		return 1
	fi

	CERT_PATH="$*"
	AKEYLESS_TOKEN=$(akeyless auth --access-type ldap --access-id "$AKEYLESS_ACCESS_ID" --ldap_proxy_url "$AKEYLESS_LDAP_PROXY_URL" --username "$(whoami)" --password "$(cat ~/.ldappassword)" | grep -o 't-[^"]*')

	if [[ -z "$AKEYLESS_TOKEN" ]]; then
		echo "Error: Failed to get Akeyless token" >&2
		return 1
	fi

	SUFFIX=$(echo "$CERT_PATH" | sed 's/\//_/g')
	SSH_PUBLIC_KEY="$HOME/.ssh/id_ed25519.${SUFFIX}.pub"
	if [ ! -f "$SSH_PUBLIC_KEY" ]; then
		cp ~/.ssh/id_ed25519.pub "$SSH_PUBLIC_KEY"
	fi
	akeyless get-ssh-certificate --cert-username centos --cert-issuer-name "${AKEYLESS_CERT_ISSUER_PREFIX}/${CERT_PATH}/${AKEYLESS_CERT_ISSUER_SUFFIX}" --public-key-file-path "$SSH_PUBLIC_KEY" --legacy-signing-alg-name=true --token "$AKEYLESS_TOKEN"
}

# Improved listening function
listening() {
	if [ $# -eq 0 ]; then
		sudo lsof -iTCP -sTCP:LISTEN -n -P
	elif [ $# -eq 1 ]; then
		sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color "$1"
	else
		echo "Usage: listening [pattern]" >&2
		return 1
	fi
}

# Path additions
append_path "$HOME/.local/bin"
export LC_ALL=en_US.UTF-8

# Go settings
if [[ -d "$HOME/go" ]]; then
	export GOPATH="$HOME/go"
	append_path "$GOPATH/bin"
fi

# Additional paths
prepend_path "/usr/local/sbin"

# .NET Core settings
if [[ -d "$HOME/.dotnet/tools" ]]; then
	append_path "$HOME/.dotnet/tools"
fi

if [[ -d "/usr/local/opt/dotnet/libexec" ]]; then
	export DOTNET_ROOT="/usr/local/opt/dotnet/libexec"
fi

# LM Studio CLI
if [[ -d "$HOME/.cache/lm-studio/bin" ]]; then
	append_path "$HOME/.cache/lm-studio/bin"
fi

# GNU binutils
if [[ -d ${HOMEBREW_PREFIX}/opt/binutils ]]; then
	append_path "${HOMEBREW_PREFIX}/opt/binutils/bin"
fi
#
# Lazy load nvm
nvm() {
	unset -f nvm
	export NVM_DIR="$HOME/.nvm"
	safe_source "$NVM_DIR/nvm.sh"
	safe_source "$NVM_DIR/bash_completion"
	nvm "$@"
}

if [[ -n "${HOMEBREW_PREFIX}" ]]; then
	safe_source "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"
	safe_source "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm"
fi

# Use yazi to change directories
y() {
	if ! command_exists yazi; then
		echo "Error: yazi is not installed" >&2
		return 1
	fi

	# shellcheck disable=SC2155
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		# shellcheck disable=SC2164
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
