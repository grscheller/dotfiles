# dotfiles

Installs my configuration files for my Arch Linux based systems.  This
GIT superproject wraps 4 other standalone repos as submodules:

* grscheller/fish - Fish shell (my main interactive shell) config files
* grscheller/home - Bash shell & other $HOME based configuration files
* grscheller/nvim - Neovim configuration files
* grscheller/sway - Sway tiling WM configuration files

## BREAKING CHANGE

I wish to see if I can put the submodules onto different
branches of the dotfiles repo instead of their own independent repos.
Will use the new, circa 2019, `set-branch` sub-sub-command:

```fish
    $ git submodule [--quiet] set-branch [<options>] [--] <path>
```

**Advantages:**

* one repo with multiple branches
* instead of 5 separate repos 
* no longer will have to keep in sync separate .installSource.sh

**Disadvantages:**

* each submodule no longer its own totally independent project

## Steps to clone

First enable recursion so that many regular commands (but not clone)
will recurse into submodules by default.

```
   $ git config --global submodules.recurse true
   $ git config --global diff.submodule log
```

Now clone the grscheller/dotfiles GitHub repo,

```
   $ git clone --recurse-submodules https://github.com/grscheller/dotfiles
   $ cd dotfiles
   $ git submodule update --init --recursive
```

Get to know the code,

```
   $ git grep foobar
   $ git ls-files --recurse-submodules
```

then, after making the above config changes, to update dotfiles,

```
   $ git fetch
   $ git pull
   $ git submodule update
```

## Steps to maintain a dotfiles like repo

When maintaining the dotfiles repo, I check it out in a way so
my changes can be pushed back to GitHub.

```
   $ git clone --recurse-submodules git@github.com:grscheller/dotfiles
```

I usually make changes to the submodules by directly cloning their
repos, not working with them as submodules.  Anyway, pushing them up to
GitHub as submodules would be irksome since they are cloned with http
protocol and not git protocol.  

To update the submodules to their latest versions,

```
   $ git submodule update --remote --merge
```

this will create changes needing to be added and committed to the repo.
Should be safe if submodules default branches are kept linear in their
commit history.  In that case, the merges will just be a fast forwards.

## Scripts

* [dfInstall](dfInstall)
  * Installs "dotfiles" to "$HOME"
  * Usage: `./dfInstall [-s {install|check|repo}]`
* [sudo sfInstall](sfInstall)
  * Installs "root/" files to "/"
  * Usage: `sudo ./sfInstall`

## Public Domain Declaration

  To the extent possible under law,
  [Geoffrey R. Scheller](https://github.com/grscheller)
  has waived all copyright and related or neighboring rights
  to [grscheller/dotfiles](https://github.com/grscheller/dotfiles).
  This work is published from the United States of America.
</p>

See [LICENSE](LICENSE) for details.
