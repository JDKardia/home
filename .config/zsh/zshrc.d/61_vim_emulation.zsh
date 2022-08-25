## Keybindings section
bindkey -v

#smash jk to enter vicmd mode
for combo in "jk" "kj" ; do
  bindkey -M viins "$combo" vi-cmd-mode
done

#smash sudo to prepend or un-prepend line with sudo
for combo in \
  "sudo" "usdo" "dsuo" "sduo" "udso" "duso" "ousd" "uosd" \
  "soud" "osud" "usod" "suod" "sdou" "dsou" "osdu" "sodu" \
  "dosu" "odsu" "odus" "dous" "uods" "ouds" "duos" "udos"; do
  bindkey -M viins "$combo" sudo-command-line
  bindkey -M vicmd "$combo" sudo-command-line
done

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
export KEYTIMEOUT=8

# bind UP and DOWN arrow keys to history substring search
#zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-search-up
bindkey "$terminfo[kcud1]" history-search-down
bindkey '^[[A' history-search-up
bindkey '^[[B' history-search-down
