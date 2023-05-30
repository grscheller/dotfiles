# dotfiles

Installs my configuration files for my Arch Linux based systems.  This
GIT superproject wraps 4 other standalone repos as submodules:

* grscheller/fish - Fish shell (my main interactive shell) config files
* grscheller/home - Bash shell & other $HOME based configuration files
* grscheller/nvim - Neovim configuration files
* grscheller/sway - Sway tiling WM configuration files

## Steps to clone

First enable recursion so that many (but not all) regular commands will
recurse into submodules by default.

```
   $ git config --global submodules.recurse true
```

Now clone the grscheller/dotfiles GitHub repo.

```
   $ git clone --recurse https://github.com/grscheller/dotfiles
   $ cd dotfiles
```

Get to know the code.

```
   $ git grep foobar
   $ git  ls-files --recurse-submodules
```

When you update dotfiles,

```
   $ git fetch
   $ git pull --rebase
```

## Steps to maintain dotfiles repo

When maintaining the dotfiles repo itself, I check it out so I can push
my changes back to GitHub.

```
   $ git clone --recurse git@github.com:grscheller/dotfiles
```

I usually make changes to each submodules by directly cloning their
repos and not working with them as submodules of dotfiles.

To update the submodules to their latest versions,

```
   $ git submodule update --remote --rebase
```

this will create changes needing to be added/committed to the dotfiles repo.

## Scripts

* [dfInstall](dfInstall)
  * Installs "dotfiles" to "$HOME"
  * Usage: `./dfInstall [-s {install|check|repo}]`
* [sudo sfInstall](sfInstall)
  * Installs "root/" files to "/"
  * Usage: `sudo ./sfInstall`

## Public Domain Declaration

<p xmlns:dct="http://purl.org/dc/terms/"
   xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#">
  <a rel="license"
     href="http://creativecommons.org/publicdomain/zero/1.0/">
     <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png"
          style="border-style: none;"
          alt="Unlicense"></a>

  To the extent possible under law,
  [Geoffrey R. Scheller](https://github.com/grscheller)
  has waived all copyright and related or neighboring rights
  to [grscheller/dotfiles](https://github.com/grscheller/dotfiles).
  This work is published from the United States of America.
</p>

See [LICENSE](LICENSE) for details.
