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
alias vim='nvim'
alias vimdiff='nvim -d'
# Make My Own Command Aliases
# alias icat="kitty +kitten icat"
# alias d="kitty +kitten diff"
alias n="note"
[[ "$(command -v xclip)" ]] && alias pbcopy="xclip -selection clipboard"
[[ "$(command -v xclip)" ]] && alias pbpaste="xclip -selection clipboard -o"
alias less="$PAGER"
alias bp='bpython'
alias tolower='tr "[:upper:]" "[:lower:]"'
alias toupper='tr "[:lower:]" "[:upper:]"'
alias fd='fd --hidden'
alias git-root='cd $(git rev-parse --show-toplevel)'

#alias emacs='swallow emacs'
#alias demacs='swallow emacs --with-profile doom'
#alias lua='rlwrap luajit'
# Shortcut Aliases
alias g="git"
alias gs='git status -sb'
alias k="kubectl"
alias l='ls -lFh'        #size,show type,human readable
alias la='ls -lAFh'      #long list,show almost all,show type,human readable
alias lr='ls -tRFh'      #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'      #long list,sorted by date,show type,human readable
alias ll='ls -l'         #long list
alias lld='ls -ld -- */' # long list only dir
alias ld='ls -d -- */'   # only dir
alias gr='cd $(git rev-parse --show-cdup)'
alias gitroot='cd $(git rev-parse --show-cdup)'
alias git-root='cd $(git rev-parse --show-cdup)'
alias lf='ls -pA  | grep -v "/"'
alias llf='ls -lpA  | grep -v "/"'
