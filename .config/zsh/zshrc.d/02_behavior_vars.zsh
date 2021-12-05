#!/usr/bin/env zsh
export EDITOR=$(which nvim)
export VISUAL=$(which nvim)
export FORCE_COLOR=true # for yarn workspace colors
export CLICOLOR=YES
#export PAGER='vimpager'
export PAGER='less'
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

