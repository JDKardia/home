# `$HOME`, Sweet `$HOME`

## What is this?

I came across [Drew Devault's blog post](https://drewdevault.com/2019/12/30/dotfiles.html "Managing my dotfiles as a git repository") 
about managing dot files and configs by just making the `$HOME` directory a git
repo. This approach struck a chord with me, so I reorganized my everything with
that article in mind, and it's been smooth sailing since.

## Overlay Functionality
The script `./bin/togglegit` switches between 3 states:
- No git repo at user root
- Personal git repo at user root
- Work git repo at user root

this allows me to easily keep everything in expected locations while keeping 
work sensitive configurations and scripts strictly within a private context.

```
personal dot files: github.com/JDKardia/home
    work dot files: hah, i'm not sharing this in public
```

## Notes for readers

Mixed use of bash, python, zsh:

- Bash and Python for scripts
- Zsh as Daily Driver Shell

---

There are some python scripts within `~/bin/` and while it's not suggested, I
use the system python3 for this since setting up a virtual environment for
these scripts and running it via shebang is a fucking mess and I want something
tidier. Plus I never use the system's python, so why not?

---

Most bash files I've written start with some variation of 
[Aaron Maxwell's 'Bash Strict Mode'](http://redsymbol.net/articles/unofficial-bash-strict-mode/ "Unofficial Bash Strict Mode"):

```bash
#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
```

quick breakdown of what you just read:
- `-e` opt stops the script on errors.
- `-u` opt makes bash throw an error when undefined variables are accessed.
- `-o pipefail` opt propagates an error in a pipeline out, preventing pipes from masking errors.
- `$IFS` or 'Internal Field Separator' set to `$'\n\t'` separates only on newlines and tabs, preventing overeager default of `$' \n\t'`

--- 

I have a growing library of bash stuff that might be of interest at `~/lib/bash/`.
