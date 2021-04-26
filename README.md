# LINUX/UNIX/POSIX dotfiles

This project contains the infrastructure I use to
track and install my POSIX based shell environments
on the computers I use.  The same configuration files are
designed to be shared across multiple computers and operating
systems. Installs into `$HOME` from cloned repository directory.

## Features and Design Choices

* Use `dotfiles/` directory as template to customize your own version
* Clone and install on the computers you use
* Will work on most, more or less, POSIX compliant systems
* Same POSIX `.profile` used by all shells
* Re-initialize any shell by sourcing .profile
* Designed for maximum portability
* Not designed for maximum security on some specific Shell or OS

### Initial Shell Configuration

Modern Linux desktop environments typically don't source
`~/.profile` nor ` ~/.bash_profile` by default.  These files
are the traditional tools for users to tweak their initial
shell environments.  Login shells source these files.  Shells
in terminal emulators are not descendant from login shells.

The various `.*rc` files determine whether or not an initial shell
environment was properly configured.  If not, they source
a POSIX shell script `~/.envrc` to do an initial configuration.

Another approach would be to have the terminal emulator invoke
a login shell.  A login shell may not always be wanted for a new
terminal window.  For example, my shell function `tm` will launch
a new terminal window whose shell inherits the environment of
the involking shell.  Just spawning a login shell will not
necessarily give you the same "virgin" initial environment you
get when you log in via ssh or the console.

## Shell Configuration

* [installDotfiles](installDotfiles) installation script
  * installs everything into $HOME
  * run `./installDotfiles --help` to see options
  * script backups existing configuration files with .old extension
  * installs config files with correct names
    * `profile.sh` -> `~/.profile`
    * `bashrc.bash` -> `~/.bashrc`
* All shells share the same POSIX compliant .profile
* Installs varous `$XDG_CONFIG_HOME` configurations
  * installs `$XDG_CONFIG_HOME/nvim\init.vim` for neovim
  * installs `$XDG_CONFIG_HOME/alacritty/alacritty.yml` for alacritty
* Readline library configuration
  * `~/.inputrc`
  * vi editing mode
  * allows emacs style forward & reverse shell history searches via arrow keys
  * still allows `<esc>/` text history searches

## Shell Scripts Installed in ~/.local/bin

* [bsPlug](bin/bsPlug)
  * bootstraps Plug infrastructure for Neovim
  * installs Plug into correct location
  * then from within nvim run `:PlugInstall`
* [buArch](bin/buArch)
  * backup script for my Arch Linux laptop home directory
  * basically a wrapped for rsync
  * bash script
* [digpath.bash](bin/digpath.bash)
  * finds files on the $PATH
  * like the ksh whence builtin
  * does not stop after finding first one
  * required by various rc scripts
  * script version of digpath shell function
  * bash script (ksh compatible)
* [digpath.sh](bin/digpath.sh)
  * POSIX complient version of above script
  * does not support extended file globbing patterns
* [monitor](bin/monitor)
  * maintain a log of who is on the system
  * bash script
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
* POSIX shells first source `/etc/profile`
* POSIX shells then source `~/.profile`
* POSIX shells then source `$ENV` if it exists as a file
* If $ENV unset, some versions of Korn Shell will source `~/.kshrc`

### For non-login interactive shells and non-interactive shells

* Bash sources `$BASH_ENV` if it exists as a file, otherwise sources ~/.bashrc
* POSIX shells source `$ENV` if it exists as a file

This is what these shells do.  What you do with it, is up to you.

I have recently noticed, as of April 2021, that for Gnome Shell 3.38.4
and later, Gnome Display Manager (gdm) was __NON-INTERACTIVELY__
sourcing ~/.profile with sh, even when my login shell was fish.
