PZ_PLUGIN_HOME="$HOME/.config/zsh/plugins"
[[ -d $PZ_PLUGIN_HOME/pz ]] ||
  git clone https://github.com/mattmc3/pz.git "$PZ_PLUGIN_HOME"/pz --branch pz
source "$PZ_PLUGIN_HOME"/pz/pz.zsh

export ASDF_DIR="$PZ_PLUGIN_HOME/.asdf"
[[ -d $ASDF_DIR ]] ||
  git clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR" --branch v0.9.0
source "$ASDF_DIR"/asdf.sh

export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
pz source romkatv/zsh-defer
pz source romkatv/powerlevel10k
pz source zsh-users/zsh-history-substring-search
pz source caarlos0/ports
pz source softmoth/zsh-vim-mode
pz source agkozak/zsh-z
pz source ohmyzsh/ohmyzsh plugins/vi-mode

zsh-defer pz source ohmyzsh/ohmyzsh plugins/docker-compose
zsh-defer pz source ohmyzsh/ohmyzsh plugins/pip
zsh-defer pz source ohmyzsh/ohmyzsh plugins/docker
zsh-defer pz source ohmyzsh/ohmyzsh plugins/ripgrep
zsh-defer pz source ohmyzsh/ohmyzsh plugins/brew
zsh-defer pz source ohmyzsh/ohmyzsh plugins/bazel
zsh-defer pz source ohmyzsh/ohmyzsh plugins/golang/_golang
zsh-defer pz source ohmyzsh/ohmyzsh plugins/docker
zsh-defer pz source ohmyzsh/ohmyzsh plugins/docker

zsh-defer pz source zsh-users/zsh-autosuggestions
zsh-defer pz source zsh-users/zsh-syntax-highlighting
if command -v "direnv" > /dev/null 2>&1; then
  zsh-defer eval "$(direnv hook zsh)"
else
  echo "direnv not present on system"
fi
