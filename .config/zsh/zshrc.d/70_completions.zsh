# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

EXTERNAL_COMPLETIONS="$ZDOTDIR/zshrc.d/external_completions"
[[ ! -d "$EXTERNAL_COMPLETIONS" ]]          && mkdir -p $EXTERNAL_COMPLETIONS
[[ "$(command -v kubectl)" ]] && [[ ! -f "$EXTERNAL_COMPLETIONS/_kubectl" ]] && kubectl completion zsh > "$EXTERNAL_COMPLETIONS/_kubectl.zsh"
[[ "$(command -v pip)" ]] && [[ ! -f "$EXTERNAL_COMPLETIONS/_pip" ]]     && pip completion --zsh >  "$EXTERNAL_COMPLETIONS/_pip.zsh"
[[ "$(command -v fzf)" ]] && [[ ! -f "$EXTERNAL_COMPLETIONS/_fzf" ]]     && curl "https://raw.githubusercontent.com/junegunn/fzf/master/shell/completion.zsh" -o "$EXTERNAL_COMPLETIONS/_fzf.zsh" > /dev/null 2>&1

