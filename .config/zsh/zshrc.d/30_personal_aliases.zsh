# Default Arg Aliases
alias rg='rg -i'
alias cp="cp -i" # Confirm before overwriting something
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias df='df -h'     # Human-readable sizes
alias free='free -m' # Show sizes in MB
alias ls="ls --color=auto"
alias grep='grep --color'
alias cat='batcat'
# Make My Own Command Aliases
alias icat="kitty +kitten icat"
alias d="kitty +kitten diff"
alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"
alias nb="git checkout -b"
alias less=$PAGER
alias bp='bpython'
alias tolower='tr "[:upper:]" "[:lower:]"'
alias toupper='tr "[:lower:]" "[:upper:]"'
alias fd='fdfind --hidden'
alias emacs='swallow emacs'
alias demacs='swallow emacs --with-profile doom'
alias lua='rlfe luajit'
# Shortcut Aliases
alias gc="git checkout"
alias gs="git status"
alias gr="git reset"
alias k="kubectl"
alias l='ls -lFh'        #size,show type,human readable
alias la='ls -lAFh'      #long list,show almost all,show type,human readable
alias lr='ls -tRFh'      #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'      #long list,sorted by date,show type,human readable
alias ll='ls -l'         #long list
alias lld='ls -ld -- */' # only dir
frg() {
  INITIAL_QUERY=""
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'"
  fzf --bind "change:reload:$RG_PREFIX {q} || true" \
    --ansi --query "$INITIAL_QUERY" \
    --height=50% --layout=reverse $@
}

lsgh() {
  ls -p | grep / | xargs -I {} sh -c 'echo "{}:\t$(cat {}.git/HEAD)"' | column -t
}

sapt(){
  local apt_path=$(which apt)
  if [ -x "$apt_path" ]; then
    local rg_search_string=$(local IFS='|';echo "$*")
    apt search $@ | rg $rg_search_string --context 1
  else
    echo "This system doesn't have 'apt' installed, so we cannot search with it."
  fi
}
