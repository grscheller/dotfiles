# Configuration Files "my dotfiles"

This project contains the infrastructure I use to
maintain and install my Fish, Neovim and Alacrittty
configurations.  I also maintain minimal bash and
POSIX shell configurations.

The same configuration files are designed to be
shared across multiple, more or less, POSIX like
environments.  These config files get installed
into the `$HOME` directiors from the cloned repo.

## Design Choices

Modern Linux desktop environments don't reliably source, or not
source, either `~/.profile` or `~/.bash_profile`.  Therefore,
while in a terminal or at the console, I must take care to
ensure that a sane initial shell environment gets set up.

* Same POSIX `.profile` used by all POSIX compliant shells
* Fish is not a POSIX compliant shell
* Designed for maximum portability
* Not designed for maximum security for a specific Shell or OS

## Shell Scripts

### Installation Script

* [installDotfiles](installDotfiles) installation script
  * installs everything into `$HOME`
  * run `./installDotfiles` from repo
  * Installs other various configuration files

### Shell Scripts for POSIX Shell Configs

These are installed into `~/.local/bin`.

* [digpath](bin/digpath)
  * finds files on $PATH
  * like the ksh whence builtin
  * does not stop after finding first one
  * required by various rc scripts
  * POSIX complient script
* [pathtrim](bin/pathtrim)
  * cleans up $PATH
  * removes non-existing directories
  * removes duplicate path elements
  * edge cases
    * correctly handles white space
    * correctly handles newlines in directory names
    * will have issues with colens in directory names
  * POSIX complient script
  
Fish & Bash  have a similarly named functions.

### Other Bash/POSIX Scripts

These are installed into `~/bin`.

* [bsPaq](bin/bsPaq)
  * bootstraps Paq infrastructure for Neovim
  * after bootstrap, run `:PaqSync` from within nvim 
  * POSIX complient script
* [buArch](bin/buArch)
  * backup script for my Arch Linux laptop home directory
  * basically a wrapped for rsync
  * bash script
* [monitor](bin/monitor)
  * maintain a log of who is on the system
  * bash script
* [rt](bin/rt)
  * launch rtorrent Bit-Torrent peer-to-peer ncurses based CLI program
  * POSIX complient script
* [spin](bin/spin)
  * spin a curser around
  * handy to keep ssh connections alive
  * hit any key to terminate, except `<space>` or `<enter>`
  * bash script
* [viewJarManifest](bin/viewJarManifest)
  * view the manifest list of a jar file
  * usage: viewJarManifest someJarFile.jar
  * POSIX complient script
