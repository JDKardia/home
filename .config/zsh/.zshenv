#!/usr/bin/env zsh

################
# System Context
################
# {{{
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
# }}}

##########################
# iterm2 integration setup
##########################
#{{{
if [[ -o interactive ]]; then
	if [ "${ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX-}""$TERM" != "screen" -a "${ITERM_SHELL_INTEGRATION_INSTALLED-}" = "" -a "$TERM" != linux -a "$TERM" != dumb ]; then
		ITERM_SHELL_INTEGRATION_INSTALLED=Yes
		ITERM2_SHOULD_DECORATE_PROMPT="1"
		# Indicates start of command output. Runs just before command executes.
		iterm2_before_cmd_executes() {
			if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
				printf "\033]133;C;\r\007"
			else
				printf "\033]133;C;\007"
			fi
		}

		iterm2_set_user_var() {
			printf "\033]1337;SetUserVar=%s=%s\007" "$1" $(printf "%s" "$2" | base64 | tr -d '\n')
		}
		# Users can write their own version of this method. It should call
		# iterm2_set_user_var but not produce any other output.
		# e.g., iterm2_set_user_var currentDirectory $PWD
		# Accessible in iTerm2 (in a badge now, elsewhere in the future) as
		# \(user.currentDirectory).
		whence -v iterm2_print_user_vars >/dev/null 2>&1
		if [ $? -ne 0 ]; then
			iterm2_print_user_vars() {
				true
			}
		fi

		iterm2_print_state_data() {
			local _iterm2_hostname="${iterm2_hostname-}"
			if [ -z "${iterm2_hostname-}" ]; then
				_iterm2_hostname=$(hostname -f 2>/dev/null)
			fi
			printf "\033]1337;RemoteHost=%s@%s\007" "$USER" "${_iterm2_hostname-}"
			printf "\033]1337;CurrentDir=%s\007" "$PWD"
			iterm2_print_user_vars
		}

		# Report return code of command; runs after command finishes but before prompt
		iterm2_after_cmd_executes() {
			printf "\033]133;D;%s\007" "$STATUS"
			iterm2_print_state_data
		}

		# Mark start of prompt
		iterm2_prompt_mark() {
			printf "\033]133;A\007"
		}

		# Mark end of prompt
		iterm2_prompt_end() {
			printf "\033]133;B\007"
		}

		# There are three possible paths in life.
		#
		# 1) A command is entered at the prompt and you press return.
		#    The following steps happen:
		#    * iterm2_preexec is invoked
		#      * PS1 is set to ITERM2_PRECMD_PS1
		#      * ITERM2_SHOULD_DECORATE_PROMPT is set to 1
		#    * The command executes (possibly reading or modifying PS1)
		#    * iterm2_precmd is invoked
		#      * ITERM2_PRECMD_PS1 is set to PS1 (as modified by command execution)
		#      * PS1 gets our escape sequences added to it
		#    * zsh displays your prompt
		#    * You start entering a command
		#
		# 2) You press ^C while entering a command at the prompt.
		#    The following steps happen:
		#    * (iterm2_preexec is NOT invoked)
		#    * iterm2_precmd is invoked
		#      * iterm2_before_cmd_executes is called since we detected that iterm2_preexec was not run
		#      * (ITERM2_PRECMD_PS1 and PS1 are not messed with, since PS1 already has our escape
		#        sequences and ITERM2_PRECMD_PS1 already has PS1's original value)
		#    * zsh displays your prompt
		#    * You start entering a command
		#
		# 3) A new shell is born.
		#    * PS1 has some initial value, either zsh's default or a value set before this script is sourced.
		#    * iterm2_precmd is invoked
		#      * ITERM2_SHOULD_DECORATE_PROMPT is initialized to 1
		#      * ITERM2_PRECMD_PS1 is set to the initial value of PS1
		#      * PS1 gets our escape sequences added to it
		#    * Your prompt is shown and you may begin entering a command.
		#
		# Invariants:
		# * ITERM2_SHOULD_DECORATE_PROMPT is 1 during and just after command execution, and "" while the prompt is
		#   shown and until you enter a command and press return.
		# * PS1 does not have our escape sequences during command execution
		# * After the command executes but before a new one begins, PS1 has escape sequences and
		#   ITERM2_PRECMD_PS1 has PS1's original value.
		iterm2_decorate_prompt() {
			# This should be a raw PS1 without iTerm2's stuff. It could be changed during command
			# execution.
			ITERM2_PRECMD_PS1="$PS1"
			ITERM2_SHOULD_DECORATE_PROMPT=""

			# Add our escape sequences just before the prompt is shown.
			# Use ITERM2_SQUELCH_MARK for people who can't mdoify PS1 directly, like powerlevel9k users.
			# This is gross but I had a heck of a time writing a correct if statetment for zsh 5.0.2.
			local PREFIX=""
			if [[ $PS1 == *"$(iterm2_prompt_mark)"* ]]; then
				PREFIX=""
			elif [[ ${ITERM2_SQUELCH_MARK-} != "" ]]; then
				PREFIX=""
			else
				PREFIX="%{$(iterm2_prompt_mark)%}"
			fi
			PS1="$PREFIX$PS1%{$(iterm2_prompt_end)%}"
			ITERM2_DECORATED_PS1="$PS1"
		}

		iterm2_precmd() {
			local STATUS="$?"
			if [ -z "${ITERM2_SHOULD_DECORATE_PROMPT-}" ]; then
				# You pressed ^C while entering a command (iterm2_preexec did not run)
				iterm2_before_cmd_executes
				if [ "$PS1" != "${ITERM2_DECORATED_PS1-}" ]; then
					# PS1 changed, perhaps in another precmd. See issue 9938.
					ITERM2_SHOULD_DECORATE_PROMPT="1"
				fi
			fi

			iterm2_after_cmd_executes "$STATUS"

			if [ -n "$ITERM2_SHOULD_DECORATE_PROMPT" ]; then
				iterm2_decorate_prompt
			fi
		}

		# This is not run if you press ^C while entering a command.
		iterm2_preexec() {
			# Set PS1 back to its raw value prior to executing the command.
			PS1="$ITERM2_PRECMD_PS1"
			ITERM2_SHOULD_DECORATE_PROMPT="1"
			iterm2_before_cmd_executes
		}

		# If hostname -f is slow on your system set iterm2_hostname prior to
		# sourcing this script. We know it is fast on macOS so we don't cache
		# it. That lets us handle the hostname changing like when you attach
		# to a VPN.
		if [ -z "${iterm2_hostname-}" ]; then
			if [ "$(uname)" != "Darwin" ]; then
				iterm2_hostname=$(hostname -f 2>/dev/null)
				# Some flavors of BSD (i.e. NetBSD and OpenBSD) don't have the -f option.
				if [ $? -ne 0 ]; then
					iterm2_hostname=$(hostname)
				fi
			fi
		fi

		[[ -z ${precmd_functions-} ]] && precmd_functions=()
		precmd_functions=($precmd_functions iterm2_precmd)

		[[ -z ${preexec_functions-} ]] && preexec_functions=()
		preexec_functions=($preexec_functions iterm2_preexec)

		iterm2_print_state_data
		printf "\033]1337;ShellIntegrationVersion=13;shell=zsh\007"
	fi
fi
#}}}

########################################
# Enable XDG Dir Usage wherever Possible
########################################
# {{{
# XDG Dir Setup
# {{{
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
# }}}
# set to use XDG dirs
# {{{
export GHCUP_USE_XDG_DIRS=true
# }}}

# set XDG config dir
# {{{
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
# }}}

# set XDG state dir
# {{{
export HISTFILE="$XDG_STATE_HOME"/bash/history
export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"
export TEXMACS_HOME_PATH=$XDG_STATE_HOME/texmacs
# }}}

# set XDG runtime dir
# {{{
export RXVT_SOCKET="$XDG_RUNTIME_DIR"/urxvtd
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
# }}}

# Setting XDG Data dir
# {{{
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
export PYENV_ROOT="$XDG_DATA_HOME"/pyenv
# export RBENV_ROOT="$XDG_DATA_HOME"/rbenv
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
# }}}

# set XDG cache dir
# {{{
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
# }}}
# }}}

###########
# PATH MODS
###########
# {{{
if [[ $PATHED != 'true' ]]; then
	# Personal
	MY_PATH="$HOME/bin"
	MY_PATH="$MY_PATH:$HOME/.local/bin"
	MY_PATH="$MY_PATH:$GOPATH/bin"
	MY_PATH="$MY_PATH:$CARGO_HOME/bin"
	MY_PATH="$MY_PATH:$HOME/stripe/work/exe"
	MY_FPATH="$HOME/completions"
	MY_FPATH="$MY_FPATH:$ZDOTDIR/zshrc.d/external_completions/"

	# Mac Specific
	MAC_PATH=""
	MAC_FPATH=""

	if [[ $IS_DARWIN == "true" ]]; then
		# Brew Path Additions
		MAC_PATH="/opt/homebrew/bin"
		MAC_PATH="$MAC_PATH:/opt/homebrew/opt/gnu-time/libexec/gnubin"
		MAC_PATH="$MAC_PATH:/opt/homebrew/opt/gnu-xargs/libexec/gnubin"
		MAC_PATH="$MAC_PATH:/opt/homebrew/opt/gnu-sed/libexec/gnubin"
		MAC_PATH="$MAC_PATH:/opt/homebrew/opt/grep/libexec/gnubin"
		MAC_PATH="$MAC_PATH:/opt/homebrew/opt/gnu-units/libexec/gnubin"
		MAC_PATH="$MAC_PATH:/opt/homebrew/opt/gnu-tar/libexec/gnubin"
		MAC_PATH="$MAC_PATH:$HOME/.config/zsh/iterm2-integrations"
		MAC_FPATH="/opt/homebrew/share/zsh/site-functions"
		MAC_MANPATH="/opt/homebrew/share/man"
		MAC_INFOPATH="/opt/homebrew/share/info"

		# Exporting Path Mods
		export PATH="$MY_PATH:$MAC_PATH:$PATH"
		export FPATH="$MY_FPATH:$MAC_FPATH:$FPATH"
		export MANPATH="$MAC_MANPATH:${MANPATH}"
		export INFOPATH="$MAC_INFOPATH:${INFOPATH-}"
		export PATHED='true'
	fi
fi
# }}}

###################
# zsh configuration
###################
# {{{
# zsh itself
export ZCONFDIR="$XDG_CONFIG_HOME/zsh/zshrc.d"
export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file
# editor
export EDITOR="nvim"
export VISUAL="nvim"
# }}}
