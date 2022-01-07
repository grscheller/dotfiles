# Configuration Files "dotfiles"

This repo contains the infrastructure I use to
maintain and install my Fish, Neovim, and Alacritty
configurations.  Also contains more minimal Bash and
POSIX shell configurations.

## Design Choices

The same configuration files are designed for use across multiple,
more or less, POSIX like operating systems.  Care is taken to
ensure that sane initial shell environments are set up.

## Shell Scripts

### Installation Script

* [installDotfiles](installDotfiles) installation script
  * run `./installDotfiles` from cloned repo
  * installs everything into `$HOME`

### Scripts Used in POSIX Shell Configurations

These POSIX shell scripts get installed into `~/.local/bin`.  Both
Fish and Bash use function based versions of these.

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
    * will have issues with colons in directory names
  
### Other Bash/POSIX Scripts

These scripts get installed into `~/bin`

* [bsPaq](bin/bsPaq)
  * bootstraps Paq infrastructure for Neovim
  * after bootstrap, run `:PaqSync` from within nvim 
  * POSIX compliant script
* [buArch](bin/buArch)
  * backup script for my Arch Linux laptop home directory
  * wrapper for rsync
  * Bash script
* [monitor](bin/monitor)
  * maintain a log of who logs on the system
  * Bash script
* [rt](bin/rt)
  * launch rtorrent Bit-Torrent peer-to-peer ncurses based CLI program
  * POSIX compliant script
* [spin](bin/spin)
  * spin the cursor around
  * handy to keep ssh connections alive
  * hit any key to terminate, except `<space>` or `<return>`
  * Bash script
* [viewJarManifest](bin/viewJarManifest)
  * view the manifest list of a jar file
  * POSIX compliant script
