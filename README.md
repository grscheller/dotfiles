# dotfiles

Installs my configuration files for my Arch Linux based systems.  This
GIT superproject wraps 4 other standalone repos as submodules:

* grscheller/fish - Fish shell (my main interactive shell) config files
* grscheller/home - Bash shell & other $HOME based configuration files
* grscheller/nvim - Neovim configuration files
* grscheller/sway - Sway tiling WM configuration files

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
   $ git  ls-files --recurse-submodules
```

then, with the above config changes, to update dotfiles,

```
   $ git fetch
   $ git pull
   $ git submodule update
```

should be safe since I try to keep the default branches very
fastforwardable.

## Steps to maintain a dotfiles like repo

When maintaining the dotfiles repo, I check it out in a way so
my changes can be pushed back to GitHub.

```
   $ git clone --recurse-submodules git@github.com:grscheller/dotfiles
```

I usually make changes to the submodules by directly cloning their
repos, not working with them as submodules.  Anyway, pushing them
up to GitHub as submodules would be irksome since they are cloned
with http protocol and not git protocol.  

To update the submodules to their latest versions,

```
   $ git submodule update --remote --merge
```

this will create changes needing to be added/committed to the dotfiles
repo.  Should be safe if submodules default branches are kept linear in
their commit history.  In that case, the merge will just be a fast
forward.

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
