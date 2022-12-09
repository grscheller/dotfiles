# Dotfiles

Contains my user configuation files.

* Neovim configuration
* Fish and Bash configurations
* Sway and Alacritty configurations
* Other miscellaneous configurations
* Arch Linux system configuration tweaks

## Scripts

### Install Into Home Directory

Run the [dotfilesInstall](bin/dotfilesInstall) POSIX shell script.

### Install System Configurations (Arch Linux Only!)

Run the [systemfilesInstall](bin/systemfilesInstall) Fish shell script
as root.

### Toggle Installed/Repo Neovim Configs

Run the [grsNvimSwap](bin/grsNvimSwap) Fish shell script to toggle between
the installed ~/.config/nvim/lua/grs/ directory and a symlink to the
corresponding directory in the dotfiles repo.

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
