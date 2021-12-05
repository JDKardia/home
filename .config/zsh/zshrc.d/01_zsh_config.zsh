#!/usr/bin/env zsh
HISTFILE="$XDG_CONFIG_HOME/.zhistory"
HISTSIZE=1000000
SAVEHIST=1000000

setopt EXTENDED_HISTORY       # save timestamp and elapsed time to history
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST # trim duplicate commands first
setopt SHARE_HISTORY          # allows terminals to share their history

setopt nobeep      # No beep
setopt nocheckjobs # Don't warn about running processes when exiting

setopt nocaseglob      # Case insensitive globbing
setopt numericglobsort # Sort filenames numerically when it makes sense


# setup tab completion
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z-_}={A-Za-z-_}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' rehash true # automatically find new executables in path

# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on zstyle ':completion:*' cache-path ~/.zsh/cache WORDCHARS=${WORDCHARS//\/[&.;]/} # Don't consider certain characters part of the word
# set up colors
zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”

autoload -U colors && colors
