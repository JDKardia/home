#!/usr/bin/env bash

git submodule init
git submodule update
# relocate necessary files
cp .config/logid.cfg /etc/logid.cfg

# add ppas and sources
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | tee -a /etc/apt/sources.list.d/signal-xenial.list
sudo add-apt-repository ppa:appimagelauncher-team/stable
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo add-apt-repository ppa:berglh/pulseaudio-a2dp
sudo add-apt-repository ppa:regolith-linux/release
sudo add-apt-repository universe
apt update
apt install $(cat /home/kardia/.debendencies)
npm install --global sql-formatter yarn prettier

# greenclip
wget https://github.com/erebe/greenclip/releases/download/v4.2/greenclip -O /usr/bin/greenclip
chmod +x /usr/bin/greenclip
echo "installed greenclip"

# nordvpn
sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)
echo "installed nordvpn"

# logiops
mkdir /home/kardia/OthersCode/logiops/build
cd /home/kardia/OthersCode/logiops/build
cmake ..
make
make install
echo "installed logiops"

# i3-swallow
python3 -m pip install -r /home/kardia/OthersCode/i3-swallow/requirements.txt
cp /home/kardia/OthersCode/i3-swallow/swallow.py /usr/bin/swallow
chmod 770 /usr/bin/swallow
echo "installed swallow"

# gitwatch
cp /home/kardia/OthersCode/gitwatch/gitwatch.sh /usr/bin/gitwatch
echo "installed gitwatch"

# deezer
cd /home/kardia/OthersCode/deezer
sed -i 's/curl .*//g' /home/kardia/OthersCode/deezer/install.sh
./install.sh
echo "installed deezer"

# nerd-fonts
cd /home/kardia/OthersCode/nerd-fonts
./install.sh --install-to-system-path
echo "installed nerd fonts"

# nvimpager
cd /home/kardia/OthersCode/nvimpager
make install
echo "installed nvimpager"

# enable systemd services:
sudo -i -u kardia bash <<BLOCK
systemctl --user --now enable gitwatch@$(systemd-escape "'-r origin' /home/kardia/notes").service)
BLOCK
systemctl --now enable logid.service
echo "enabled systemd"

# make neovim into vim
mv /bin/vi /bin/vi.old
ln -s /bin/nvim /bin/vi
echo "neovim turned into vim"

echo "all set up! don't forget to install discord, slack, zoom, obsidian, and hyperfine."



