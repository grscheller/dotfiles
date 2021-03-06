# LINUX/UNIX/POSIX dotfiles

This project contains the infrastructure I use to
maintain and install my Fish, Bash, and Sh based
environments.  The same configuration files are
designed to be shared across multiple POSIX based
operating systems.

Installs into `$HOME` from cloned repo.

## Features and Design Choices

* Clone and install on the computers you use
* Use as a starting point for your own version
* Will work on most, more or less, POSIX compliant computers
* Same POSIX `.profile` used by all POSIX compliant shells
* Fish is not POSIX compliant shell
* Designed for maximum portability
* Not designed for maximum security for a specific Shell or OS

### Initial Shell Configuration

Some modern Linux desktop environments source neither
`~/.profile` nor `~/.bash_profile`.  CentOs 7
doesn't.  Arch Linux running GNOME Shell via GDM does.

The various POSIX `.*rc` files determine whether or not an
initial shell environment was properly configured.  If not,
they source a POSIX shell script `~/.environment_rc` to do
an initial configuration.  Also, .profile sources this file.

## Installation Script

* [installDotfiles](installDotfiles) installation script
  * installs everything into $HOME
  * run `./installDotfiles
  * script backups existing configuration files with .old extension
  * Installs other various configuration files

## Shell Scripts Installed in ~/.local/bin

* [digpath](bin/digpath)
  * finds files on $PATH
  * like the ksh whence builtin
  * does not stop after finding first one
  * required by various rc scripts
  * POSIX complient script
  * bash & fish have a similarly named functions
* [pathtrim](bin/pathtrim)
  * cleans up $PATH
  * removes non-existing directories
  * removes duplicate path elements
  * edge cases
    * correctly handles white space
    * correctly handles newlines in directory names
    * will have issues with colens in directory names
  * required by .envrc
  * POSIX complient script
  * bash & fish have a similarly named functions

## Shell Scripts Installed in ~/bin

* [bsPlug](bin/bsPlug)
  * bootstraps Plug infrastructure for Neovim
  * installs Plug into correct location
  * then from within nvim run `:PlugInstall`
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

## Shell Startup Behavior Facts

### For login shells

* Bash first sources `/etc/profile`
* Bash then sources `~/.bash_profile`
  * if not found, sources `~/.bash_login`
  * if not found, sources `~/.profile`
* Other POSIX shells first source `/etc/profile`
* Other POSIX shells then source `~/.profile`
* Other POSIX shells source `$ENV` if it exists in the environment and as a file

### For non-login interactive shells and non-interactive shells

* Bash sources `$BASH_ENV` if it exists as a file, otherwise sources ~/.bashrc
* Other POSIX shells source `$ENV` if it exists in the environment and as a file

This is what these shells do.  What you do with it, is up to you.
