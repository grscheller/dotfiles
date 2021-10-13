# Configuration Files "dotfiles"

This project contains the infrastructure I use to
maintain and install my Fish, Neovim and Alacrittty
configurations.  I also maintain minimal Bash and
POSIX shell configurations.

## Design Choices

These configuration files are designed for maximum portability,
not necessarily maximum security, across multiple, more or less,
POSIX like environments.

Modern Linux desktop environments don't reliably source, nor not
source, either `~/.profile` or `~/.bash_profile`.  Therefore, I
must take care to ensure that a sane initial shell environments
get set up.

## Shell Scripts

### Installation Script

* [installDotfiles](installDotfiles) installation script
  * run `./installDotfiles` from repo
  * installs everything into `$HOME`

### Shell Scripts for POSIX Shell Configs

These are installed into `~/.local/bin`.  Both Fish and Bash
have fuction equivalents to these.  These versions are used
to configurate my other POSIX shells.

* [digpath](bin/digpath)
  * finds files on $PATH
  * like the ksh whence builtin
  * does not stop after finding first one
* [pathtrim](bin/pathtrim)
  * cleans up $PATH
  * removes non-existing directories
  * removes duplicate path elements
  * edge cases
    * correctly handles white space
    * correctly handles newlines in directory names
    * will have issues with colens in directory names
  
### Other Bash/POSIX Scripts

These scripts are installed into `~/bin`.

* [bsPaq](bin/bsPaq)
  * bootstraps Paq infrastructure for Neovim
  * after bootstrap, run `:PaqSync` from within nvim 
  * POSIX complient script
* [buArch](bin/buArch)
  * backup script for my Arch Linux laptop home directory
  * basically a wrapped for rsync
  * Bash script
* [monitor](bin/monitor)
  * maintain a log of who is on the system
  * Bash script
* [rt](bin/rt)
  * launch rtorrent Bit-Torrent peer-to-peer ncurses based CLI program
  * POSIX complient script
* [spin](bin/spin)
  * spin a curser around
  * handy to keep ssh connections alive
  * hit any key to terminate, except `<space>` or `<enter>`
  * Bash script
* [viewJarManifest](bin/viewJarManifest)
  * view the manifest list of a jar file
  * usage: viewJarManifest someJarFile.jar
  * POSIX complient script
