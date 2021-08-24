#setup completion
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z-_}={A-Za-z-_}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' rehash true # automatically find new executables in path

# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on zstyle ':completion:*' cache-path ~/.zsh/cache WORDCHARS=${WORDCHARS//\/[&.;]/} # Don't consider certain characters part of the word
# set up colors
zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”
