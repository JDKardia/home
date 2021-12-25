PZ_PLUGIN_HOME="$HOME/.config/zsh/plugins"
[[ -d $PZ_PLUGIN_HOME/pz ]] ||
  git clone https://github.com/mattmc3/pz.git $PZ_PLUGIN_HOME/pz
source $PZ_PLUGIN_HOME/pz/pz.zsh

export ASDF_DIR="$PZ_PLUGIN_HOME/.asdf"
[[ -d $ASDF_DIR ]] ||
  git clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR" --branch v0.9.0
source $ASDF_DIR/asdf.sh

export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
pz source romkatv/zsh-defer
pz source romkatv/powerlevel10k
pz source zsh-users/zsh-history-substring-search
pz source caarlos0/ports
pz source lukechilds/zsh-better-npm-completion
pz source softmoth/zsh-vim-mode
pz source ohmyzsh/ohmyzsh plugins/docker-compose
pz source ohmyzsh/ohmyzsh plugins/vi-mode
pz source ohmyzsh/ohmyzsh plugins/pip
pz source ohmyzsh/ohmyzsh plugins/systemd
pz source agkozak/zsh-z

zsh-defer pz source ohmyzsh/ohmyzsh plugins/docker
zsh-defer pz source zsh-users/zsh-autosuggestions
zsh-defer pz source zsh-users/zsh-syntax-highlighting
