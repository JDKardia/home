#!/usr/bin/env zsh

###############
# XDG Dir Setup
###############
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_PUBLICSHARE_DIR="$HOME/Public"
export XDG_TEMPLATES_DIR="$HOME/Templates"
export XDG_VIDEOS_DIR="$HOME/Videos"

################
# System Context
################
if [[ -f /etc/os-release ]]; then
	# freedesktop.org and systemd
	. /etc/os-release
	OS="$NAME"
	VER="$VERSION_ID"
elif [[ "$(command -v lsb_release)" ]]; then
	# linuxbase.org
	OS="$(lsb_release -si)"
	VER="$(lsb_release -sr)"
elif [[ -f /etc/lsb-release ]]; then
	# For some versions of Debian/Ubuntu without lsb_release command
	. /etc/lsb-release
	OS="$DISTRIB_ID"
	VER="$DISTRIB_RELEASE"
elif [[ -f /etc/debian_version ]]; then
	# Older Debian/Ubuntu/etc.
	OS="Debian"
	VER="$(cat /etc/debian_version)"
else
	# Fall back to uname, picks up darwin
	OS="$(uname -s)"
	VER="$(uname -r)"
fi
OS="${OS:l}" # lowercase
VER="${VER:l}" # lowercase

IS_LINUX="$([[ $(uname -s) == 'Linux' ]] && echo 'true' || echo "false")"
IS_DARWIN="$([[ $(uname -s) == 'Darwin' ]] && echo 'true' || echo "false")"
IS_UBUNTU="$([[ $OS == 'ubuntu' ]] && echo 'true' || echo "false")"
IS_ARCH="$([[ $OS == 'arch linux' ]] && echo 'true' || echo "false")"

export OS
export VER

export IS_LINUX
export IS_DARWIN
export IS_UBUNTU
export IS_ARCH

# editor
export EDITOR="nvim"
export VISUAL="nvim"

###################
# zsh configuration
###################
export ZCONFDIR="$XDG_CONFIG_HOME/zsh/zshrc.d"
export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file

###########
# PATH MODS
###########
if [[ $PATHED != 'TRUE' ]]; then
	# Personal
	MY_PATH="$HOME/bin"
	MY_PATH="$MY_PATH:$HOME/.local/bin"
	MY_PATH="$MY_PATH:$HOME/go/bin"
	MY_PATH="$MY_PATH:$HOME/.cargo/bin"
	MY_PATH="$MY_PATH:$HOME/stripe/work/exe"
	MY_FPATH="$HOME/completions"
	MY_FPATH="$MY_FPATH:$ZDOTDIR/zshrc.d/external_completions/"

	# Mac Specific
	BREW_PATH=""
	BREW_FPATH=""

	if [[ $IS_DARWIN == "true" ]]; then
		# Brew Path Additions
		BREW_PATH="/opt/homebrew/bin"
		BREW_PATH="$BREW_PATH:/opt/homebrew/opt/gnu-time/libexec/gnubin"
		BREW_PATH="$BREW_PATH:/opt/homebrew/opt/gnu-xargs/libexec/gnubin"
		BREW_PATH="$BREW_PATH:/opt/homebrew/opt/gnu-sed/libexec/gnubin"
		BREW_PATH="$BREW_PATH:/opt/homebrew/opt/grep/libexec/gnubin"
		BREW_PATH="$BREW_PATH:/opt/homebrew/opt/gnu-units/libexec/gnubin"
		BREW_PATH="$BREW_PATH:/opt/homebrew/opt/gnu-tar/libexec/gnubin"
		BREW_FPATH="/opt/homebrew/share/zsh/site-functions"
		BREW_MANPATH="/opt/homebrew/share/man"
		BREW_INFOPATH="/opt/homebrew/share/info"
	fi

	# Exporting Path Mods
	export PATH="$MY_PATH:$BREW_PATH:$PATH"
	export FPATH="$MY_FPATH:$BREW_FPATH:$FPATH"
	export MANPATH="$BREW_MANPATH:${MANPATH}"
	export INFOPATH="$BREW_INFOPATH:${INFOPATH:-}"
	export PATHED='TRUE'
fi

# set to use XDG dirs
export GHCUP_USE_XDG_DIRS=true

# set XDG config dir
export ACKRC="$XDG_CONFIG_HOME/ack/ackrc"
export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME}/asdf/asdfrc"
export ASPELL_CONF="per-conf $XDG_CONFIG_HOME/aspell/aspell.conf; personal $XDG_CONFIG_HOME/aspell/en.pws; repl $XDG_CONFIG_HOME/aspell/en.prepl"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME"/bash-completion/bash_completion
export CD_BOOKMARK_FILE=$XDG_CONFIG_HOME/cd-bookmark/bookmarks
export CIN_CONFIG="$XDG_CONFIG_HOME"/bcast5
export CONAN_USER_HOME="$XDG_CONFIG_HOME"
export CONDARC="$XDG_CONFIG_HOME/conda/condarc"
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export DOT_SAGE="$XDG_CONFIG_HOME"/sage
export ELINKS_CONFDIR="$XDG_CONFIG_HOME"/elinks
export ELM_HOME="$XDG_CONFIG_HOME"/elm
export EM_CONFIG="$XDG_CONFIG_HOME"/emscripten/config
export FCEUX_HOME="$XDG_CONFIG_HOME"/fceux
export FFMPEG_DATADIR="$XDG_CONFIG_HOME"/ffmpeg
export GQRC="$XDG_CONFIG_HOME"/gqrc
export GRIPHOME="$XDG_CONFIG_HOME/grip"
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export GTK_RC_FILES="$XDG_CONFIG_HOME"/gtk-1.0/gtkrc
export IMAPFILTER_HOME="$XDG_CONFIG_HOME/imapfilter"
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc
export IRBRC="$XDG_CONFIG_HOME"/irb/irbrc
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter
export K9SCONFIG="$XDG_CONFIG_HOME"/k9s
export KDEHOME="$XDG_CONFIG_HOME"/kde
export LYNX_CFG_PATH="$XDG_CONFIG_HOME"/lynx.cfg
export MATHEMATICA_USERBASE="$XDG_CONFIG_HOME"/mathematica
export MAXIMA_USERDIR="$XDG_CONFIG_HOME"/maxima
export MEDNAFEN_HOME="$XDG_CONFIG_HOME"/mednafen
export MOST_INITFILE="$XDG_CONFIG_HOME"/mostrc
export MPLAYER_HOME="$XDG_CONFIG_HOME"/mplayer
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export OCTAVE_SITE_INITFILE="$XDG_CONFIG_HOME/octave/octaverc"
export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel
export PGPASSFILE="$XDG_CONFIG_HOME/pg/pgpass"
export PGSERVICEFILE="$XDG_CONFIG_HOME/pg/pg_service.conf"
export PSQLRC="$XDG_CONFIG_HOME/pg/psqlrc"
export PYLINTRC="$XDG_CONFIG_HOME"/pylint/pylintrc
export RECOLL_CONFDIR="$XDG_CONFIG_HOME/recoll"
export REDISCLI_RCFILE="$XDG_CONFIG_HOME"/redis/redisclirc
export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/ripgrep/config
export SCREENRC="$XDG_CONFIG_HOME"/screen/screenrc
export SPACEMACSDIR="$XDG_CONFIG_HOME"/spacemacs
export STARSHIP_CONFIG="$XDG_CONFIG_HOME"/starship.toml
export TEXMFCONFIG=$XDG_CONFIG_HOME/texlive/texmf-config
export TRAVIS_CONFIG_PATH=$XDG_CONFIG_HOME/travis
export TS3_CONFIG_DIR="$XDG_CONFIG_HOME/ts3client"
export UNCRUSTIFY_CONFIG="$XDG_CONFIG_HOME"/uncrustify/uncrustify.cfg
export WAKATIME_HOME="$XDG_CONFIG_HOME/wakatime"
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export XCOMPOSEFILE="$XDG_CONFIG_HOME"/X11/xcompose
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export XSERVERRC="$XDG_CONFIG_HOME"/X11/xserverrc
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

# set XDG state dir
export HISTFILE="$XDG_STATE_HOME"/bash/history
export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"
export TEXMACS_HOME_PATH=$XDG_STATE_HOME/texmacs

# set XDG runtime dir
export RXVT_SOCKET="$XDG_RUNTIME_DIR"/urxvtd
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority

# Setting XDG Data dir
export ASDF_DATA_DIR=${XDG_DATA_HOME}/asdf
export ATOM_HOME="$XDG_DATA_HOME"/atom
export AZURE_CONFIG_DIR=$XDG_DATA_HOME/azure
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export CRAWL_DIR="$XDG_DATA_HOME"/crawl/
export DVDCSS_CACHE="$XDG_DATA_HOME"/dvdcss
export ELECTRUMDIR="$XDG_DATA_HOME/electrum"
export EM_PORTS="$XDG_DATA_HOME"/emscripten/cache
export GDBHISTFILE="$XDG_DATA_HOME"/gdb/history
export GETIPLAYERUSERPREFS="$XDG_DATA_HOME"/get_iplayer
export GOPATH="$XDG_DATA_HOME"/go
export GQSTATE="$XDG_DATA_HOME"/gq/gq-state
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export IPFS_PATH="$XDG_DATA_HOME"/ipfs
export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH"
export LEDGER_FILE="$XDG_DATA_HOME"/hledger.journal
export LEIN_HOME="$XDG_DATA_HOME"/lein
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME"/docker-machine
export MINIKUBE_HOME="$XDG_DATA_HOME"/minikube
export MYSQL_HISTFILE="$XDG_DATA_HOME"/mysql_history
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export NVM_DIR="$XDG_DATA_HOME"/nvm
export N_PREFIX=$XDG_DATA_HOME/n
export OPAMROOT="$XDG_DATA_HOME/opam"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass
export PLTUSERHOME="$XDG_DATA_HOME"/racket
export PYENV_ROOT=$XDG_DATA_HOME/pyenv
export RBENV_ROOT=XDG_DATA_HOME/rbenv
export REDISCLI_HISTFILE="$XDG_DATA_HOME"/redis/rediscli_history
export RLWRAP_HOME="$XDG_DATA_HOME"/rlwrap
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export SQLITE_HISTORY=$XDG_DATA_HOME/sqlite_history
export STACK_ROOT="$XDG_DATA_HOME"/stack
export TERMINFO="$XDG_DATA_HOME"/terminfo
export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo
export TEXMFHOME=$XDG_DATA_HOME/texmf
export UNISON="$XDG_DATA_HOME"/unison
export VAGRANT_ALIAS_FILE="$XDG_DATA_HOME"/vagrant/aliases
export VAGRANT_HOME="$XDG_DATA_HOME"/vagrant
export VSCODE_PORTABLE="$XDG_DATA_HOME"/vscode
export WINEPREFIX="$XDG_DATA_HOME"/wineprefixes/default
export WORKON_HOME="$XDG_DATA_HOME/virtualenvs"
export _Z_DATA="$XDG_DATA_HOME/z"

# set XDG cache dir
export CALCHISTFILE="$XDG_CACHE_HOME"/calc_history
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export EM_CACHE="$XDG_CACHE_HOME"/emscripten/cache
export HOUDINI_USER_PREF_DIR="$XDG_CACHE_HOME"/houdini__HVER__
export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority
export KSCRIPT_CACHE_DIR="$XDG_CACHE_HOME"/kscript
export MYPY_CACHE_DIR="$XDG_CACHE_HOME"/mypy
export NUGET_PACKAGES="$XDG_CACHE_HOME"/NuGetPackages
export OCTAVE_HISTFILE="$XDG_CACHE_HOME/octave-hsts"
export PYLINTHOME="$XDG_CACHE_HOME"/pylint
export PYTHON_EGG_CACHE="$XDG_CACHE_HOME"/python-eggs
export SOLARGRAPH_CACHE=$XDG_CACHE_HOME/solargraph
export STARSHIP_CACHE="$XDG_CACHE_HOME"/starship
export TEXMFVAR=$XDG_CACHE_HOME/texlive/texmf-var
export XCOMPOSECACHE="$XDG_CACHE_HOME"/X11/xcompose
