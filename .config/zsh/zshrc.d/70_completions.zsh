# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# add asdf completion function to fpath
fpath=(${ASDF_DIR}/completions $fpath)

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

local completions_to_source=(
  "/usr/share/doc/fzf/examples/completion.zsh"
  "/usr/share/google-cloud-sdk/completion.zsh.inc"
)

#source all necessary file supplements
for file in $completions_to_source; do
  if [ -f $file ]; then
    source "$file"
  else
    echo "cannot source '$file' as it does not exist"
  fi
done

local commands_to_source=(
  "kubectl completion zsh"
  "pip completion --zsh"
)
GENERATED_COMPLETIONS_DIR="$HOME/.config/zsh/zshrc.d/generated_completions"
if [ ! -d $GENERATED_COMPLETIONS_DIR ]; then
  mkdir -p $GENERATED_COMPLETIONS_DIR
fi
#source all necessary file supplements
for command in $commands_to_source; do
  local command_completion_file="$GENERATED_COMPLETIONS_DIR/_$(echo $command | cut -d ' ' -f 1).zsh"
  if [ -f $command_completion_file ]; then
    zsh-defer source "$command_completion_file"
  else
    echo "adding new completion into $command_completion_file"
    local init_command="eval $command > $command_completion_file"
    zsh-defer -c "$init_command"
    zsh-defer source $command_completion_file
  fi
done
autoload -U compinit
compinit
