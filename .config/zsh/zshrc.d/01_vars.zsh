#!/usr/bin/env zsh
# Print a greeting message when shell is started
#echo "$USER@$HOST" "$(uname -srm)"
#Brew Path Modificcations
BREW_PATH="/opt/homebrew/bin"
BREW_PATH="$BREW_PATH:/opt/homebrew/opt/gnu-time/libexec/gnubin"
BREW_PATH="$BREW_PATH:/opt/homebrew/opt/gnu-sed/libexec/gnubin"
BREW_PATH="$BREW_PATH:/opt/homebrew/opt/gnu-units/libexec/gnubin"
BREW_PATH="$BREW_PATH:/opt/homebrew/opt/gnu-tar/libexec/gnubin"

BREW_FPATH="/opt/homebrew/share/zsh/site-functions"

#Personal
MY_PATH="$HOME/bin"
MY_PATH="$MYPATH:$HOME/.local/bin"
MY_PATH="$MYPATH:$HOME/go/bin"
MY_PATH="$MYPATH:$HOME/.cargo/bin"

MY_FPATH="$HOME/completions"

# Exporting Path Mods
export PATH="$MY_PATH:$BREW_PATH:$PATH"
export FPATH="$MY_FPATH:$BREW_FPATH:$FPATH"

export EDITOR=$(which nvim)
export VISUAL=$(which nvim)
export FORCE_COLOR=true # for yarn workspace colors
export CLICOLOR=YES
export PAGER='vimpager'
#export PAGER='less'
export FZF_COMPLETION_TRIGGER='~~'
export DOCKERHOST='localhost'
# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS='FRX --mouse -j 8'

## Options section
setopt nobeep      # No beep
setopt nocheckjobs # Don't warn about running processes when exiting

setopt nocaseglob      # Case insensitive globbing
setopt numericglobsort # Sort filenames numerically when it makes sense

HISTFILE=~/.zhistory
HISTSIZE=1000000
SAVEHIST=1000000
setopt EXTENDED_HISTORY       # save timestamp and elapsed time to history
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST # trim duplicate commands first
setopt SHARE_HISTORY          # allows terminals to share their history

autoload -U colors && colors
