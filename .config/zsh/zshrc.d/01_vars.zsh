#!/usr/bin/env zsh

# Print a greeting message when shell is started
echo "$USER@$HOST" "$(uname -srm)"
export PATH=~/bin:$PATH
export FPATH=~/completions:$FPATH
export VISUAL=$(which nvim)
export FORCE_COLOR=true # for yarn workspace colors
export CLICOLOR=YES
export PAGER='nvimpager'
#export PAGER='less'
export FZF_COMPLETION_TRIGGER='~~'
export GOOGLE_APPLICATION_CREDENTIALS='/home/kardia/.gcp/build-240615-afa84fe6be7a.json'
export DOCKERHOST='localhost'
export SDKMAN_DIR="/home/kardia/.sdkman"
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
