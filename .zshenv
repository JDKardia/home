#!/usr/bin/env zsh

# # XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# go here for actual zsh configuration
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
# source the real .zshenv file
source "$ZDOTDIR/.zshenv"
