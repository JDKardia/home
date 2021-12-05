#!/usr/bin/env zsh
emulate -L zsh; setopt local_options extended_glob null_glob

# make sure we found the conf dir
[[ ! -d "$ZCONFDIR" ]] && echo "source_conf_dir: config dir not found $confdir" >&2 && return 1

# source all files in ZCONFDIR
local files=("$ZCONFDIR"/*)
local f; for f in ${(o)files}; do
  # ignore files that begin with a tilde
  case ${f:t} in '~'*) continue;; esac
  source "$f"
done

