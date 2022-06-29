emulate -L zsh; setopt local_options extended_glob null_glob

local confdir="$HOME/.config/zsh/zshrc.d"

# make sure we found the conf dir
[[ ! -d "$confdir" ]] && echo "source_conf_dir: config dir not found $confdir" >&2 && return 1

# source all files in confdir
local files=("$confdir"/*.{sh,zsh})
local f; for f in ${(o)files}; do
  # ignore files that begin with a tilde
  case ${f:t} in '~'*) continue;; esac
  source "$f"
done

autoload -Uz compinit; compinit
autoload -Uz bashcompinit; bashcompinit
source ~/.bash_profile
source ~/.bashrc
eval "$(nodenv init -)"
compdef _git stripe-git=git
