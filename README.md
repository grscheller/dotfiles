# Dotfiles

Contains my user configuation files.

* Neovim configuration
* Fish and Bash configurations
* Sway and Alacritty configurations
* Other miscellaneous configurations

Also, contains my Arch Linux system configuration tweaks.

## Installation Scripts

Installs dotfiles into home directory.

* [dotfilesInstall](dotfilesInstall)
* From the base of the cloned repo run

  ```sh
     $ ./dotfilesInstall

     Make sure fish & nvim environments get properly updated.

     $
  ```

* Above needs to be done from the root of the dotfiles repo

Installs system tweaks into system directories (Arch Linux Only!).

* [systemfilesInstall](systemfilesInstall)
* From the base of the cloned repo run

  ```sh
     $ sudo ./systemfilesInstall
     $
  ```

* Above needs to be done from the root of the dotfiles repo

## Editing Neovim Config with LSP

To edit one version of Neovim using nvim running another version of the
configuration can be tricky.  To help with this, the `grsSwap` script toggles
a symlink `~/.config/nvim/lua/grs/`->`dotfiles/config/nvime/lua/grs/` with
a directory in the installed code base.

* [grsSwap](grsSwap)
* From the base of the cloned repo run

  ```sh
     $ ./grsSwap
     ...
  ```

* Fish abriviation `grsSway` exists, so you don't have to this from the repo
* Running `.dotfilesInstall` will fail if symlink is toggled in place

## Repo's purposes is to

1. maintain my own personal configuration files
1. help quickly configure new systems for myself
1. preserve this information for myself
1. provide others useful examples for their own configuration files
1. allow others to use as a starting point for their own version of this repo

## License information

<p xmlns:dct="http://purl.org/dc/terms/" xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#">
  <a rel="license"
     href="http://creativecommons.org/publicdomain/zero/1.0/">
    <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
  </a>
  <br />
  To the extent possible under law,
  <a rel="dct:publisher"
     href="https://github.com/grscheller">
    <span property="dct:title">Geoffrey R. Scheller</span></a>
  has waived all copyright and related or neighboring rights to
  <span property="dct:title">dotfiles</span>.
This work is published from:
<span property="vcard:Country" datatype="dct:ISO3166"
      content="US" about="https://github.com/grscheller">
  United States</span>.
</p>

### Patent claims clarification regarding licence

* To the best of my knowledge, there is nothing patentable in this repo
* I have no intention to attempt to patent anything from this repo
* I do not support the concept of software patents
* I do support software being copyrightable
