# dotfiles

Installs my configuration files for my Arch Linux based systems.

## Steps to Clone

First clone the grscheller/dotfiles GitHub repo.  Then initialize and
update the submodules.  Currently, grscheller/nvim is the only GitHub
submodule used.


```
   $ git clone https://github.com/grscheller/dotfiles
   $ cd dotfiles
   $ git submodule init
   $ git submodule update
```

When you update dotfiles, you also need to update the submodules.

```
   $ git pull
   $ git submodule update
```

## Scripts

* [dfInstall](dfInstall)
  * Installs "dotfiles" to "$HOME"
  * Usage: `./dfInstall [-s {install|target|repo}]`
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
