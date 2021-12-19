precmd () { print -Pn "\e]1;%2~\a" ; print -Pn "\e]2;zsh|%~\a" }
preexec () { print -Pn "\e]1;$1\a" ; print -Pn "\e]2;zsh|%~|$1\a" }
setopt prompt_subst
