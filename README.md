# `$HOME`, Sweet `$HOME`

## What is this?

I came across [Drew Devault's blog post](https://drewdevault.com/2019/12/30/dotfiles.html "Managing my dotfiles as a git repository") about managing dot files and configs by just making the `$HOME` directory a git repo. And oh man was that an eye opener, so I reorganized my everything with that article in mind, and it's made so much of my organization smoother.

## Setup
1. run `sudo apt install <$(cat ~/debendencies.txt)`
2. install the things I like that are not available in apt
   ```
   sudo add-apt-repository ppa:berglh/pulseaudio-a2dp
   sudo add-apt-repository ppa:regolith-linux/release # i3 with some GNOME-Chrome
   sudo apt install \
     pulseaudio-modules-bt \
     libldac \
     regolith-desktop-complete \
     regolith-look-gruvbox \
     mellowplayer \
     docker-ce \
     docker-ce-cli \
     containerd.io
   ```
   then go manually install from debs:
   - zoom
   - vscode
   - discord (if not work machine)
   - pyenv
   - nvm
   - slack
   - signal
   - intellij
   - Lens IDE
   - greenclip
   - yq

## General

Mixed use of bash, python, zsh:

- Bash and Python for scripts
- Zsh as Daily Driver Shell

---

There are some python scripts within `~/bin/` and while it's not suggested, I use the system python3 for this since setting up a virtual environment for these scripts and running it via shebang is a fucking mess and I want something tidier. Plus I never use the system's python, so why not?

---

Most bash files I've written start with some variation of [Aaron Maxwell's 'Bash Strict Mode'](http://redsymbol.net/articles/unofficial-bash-strict-mode/ "Unofficial Bash Strict Mode"):

```bash
#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
```

Simple explanation of what that is and why:

- `-e` opt stops the script on errors.
- `-u` opt makes bash throw an error when undefined variables are accessed.
- `-o pipefail` opt propagates an error in a pipeline out, preventing pipes from masking errors.
- `$IFS` or 'Internal Field Separator' set to `$'\n\t'` separates only on newlines and tabs, preventing overeager default of `$' \n\t'`
