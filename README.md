# Configuration files "my dotfiles"

This project contains the infrastructure I use to
maintain and install my Fish, Bash, and Shell based
environments.  The same configuration files are
designed to be shared across multiple, more or
less, POSIX like environments.  Also used to
maintain Neovim and Alacritty configuration files.

Installs config files into your `$HOME` directiors from
the cloned repo.

## Design Choices

* Same POSIX `.profile` used by all POSIX compliant shells
* Fish is not a POSIX compliant shell
* Designed for maximum portability
* Not designed for maximum security for a specific Shell or OS

### Initial Shell Configuration

Modern Linux desktop environments don't reliably source, or not source,
either `~/.profile` or `~/.bash_profile`.

* CentOS 7 does not
* Arch Linux running GNOME Shell via GDM sources `./profile` with sh

Therefore, my various POSIX `.*rc` files determine whether or
not an initial shell environment was properly configured.
If not, they source a POSIX shell script `~/.environment_rc`
to do an initial configuration.

## Installation Script

* [installDotfiles](installDotfiles) installation script
  * installs everything into `$HOME`
  * run `./installDotfiles` from repo
  * Installs other various configuration files

## Shell Scripts Installed in ~/.local/bin

* [digpath](bin/digpath)
  * finds files on $PATH
  * like the ksh whence builtin
  * does not stop after finding first one
  * required by various rc scripts
  * POSIX complient script
  * fish & bash  have a similarly named functions
* [pathtrim](bin/pathtrim)
  * cleans up $PATH
  * removes non-existing directories
  * removes duplicate path elements
  * edge cases
    * correctly handles white space
    * correctly handles newlines in directory names
    * will have issues with colens in directory names
  * POSIX complient script
  * fish & bash  have a similarly named functions

## Shell Scripts Installed in ~/bin

* [bsPaq](bin/bsPaq)
  * bootstraps Paq infrastructure for Neovim
  * then from within nvim run `:PaqSync`
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

## Shell Startup Behavior Facts for POSIX shells

### Login shells

* Bash first sources `/etc/profile`
* Bash then sources `~/.bash_profile`
  * if not found, sources `~/.bash_login`
  * if not found, sources `~/.profile`
* Other POSIX shells first source `/etc/profile`
* Other POSIX shells then source `~/.profile`
* Other POSIX shells source `$ENV` if it exists both in environment and as file

### Non-login interactive shells and non-interactive shells

* Bash sources `$BASH_ENV` if it exists as a file, otherwise sources ~/.bashrc
* Other POSIX shells source `$ENV` if it exists both in environment and as file
