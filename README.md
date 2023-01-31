# Dotfiles

Contains my configuration files for

* Neovim
* Fish and Bash
* Sway and Alacritty
* Software development
* Arch Linux system configuration

## Scripts

* [dfInstall](dfInstall) installs home directory configuration files
  * Usage: `dfInstall [-c {install|repo|target}]`
    * Install configs to user's home directory: `dfInstall`
    * Check config against git working directory: `dfInstall -c repo`
    * Check installed files against git working directory: `dfInstall -c target`
  * POSIX compliant shell scpript
* [sudo sfInstall](sfInstall) installs Arch Linux system configuration files
  * Usage: `sudo sfInstall`
    * No configuraion needed
    * Parses `root/` directory strucucture and installs into `/`
  * Fish shell script

## License Summary

<p xmlns:dct="http://purl.org/dc/terms/"
   xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#">
  <a rel="license"
     href="http://creativecommons.org/publicdomain/zero/1.0/">
     <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png"
          style="border-style: none;"
          alt="CC0"></a>

  To the extent possible under law,
  [Geoffrey R. Scheller](https://github.com/grscheller)
  has waived all copyright and related or neighboring rights
  to [dotfiles](https://github.com/grscheller/dotfiles).
  This work is published from the United States of America.
</p>

See [LICENSE](LICENSE) for details.
