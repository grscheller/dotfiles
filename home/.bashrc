# shellcheck shell=bash
#
#  ~/.bashrc
#
#  Bash configuration across multiple,
#  more or or less, POSIX compliant systems.
#

## If not interactive, don't do anything.
[[ $- != *i* ]] && return

## Shell functions

#  Jump up multiple directories
ud () {
   local upDir=..
   local nDirs="$1"
   if [[ $nDirs == @([1-9])*([0-9]) ]]
   then
      until (( nDirs-- <= 1 ))
      do
         upDir=../$upDir
      done
   fi
   cd $upDir || return
}

# Similar to the DOS path command
pa () {
   if (( $# == 0 ))
   then
      PathWord="$PATH"
   else
      PathWord="$1"
   fi

   # shellcheck disable=SC2086
   ( IFS=':'; printf '%s\n' $PathWord )
}

# Drill down through $PATH to look for files or directories.
# Like the ksh builtin whence, except it does not stop
# after finding the first instance.  Handles spaces in both
# filenames and directories on $PATH.  Also, shell patterns
# are supported.
digpath () (
   usage_digpath () {
      printf 'Description:\n'                                           >&2
      printf "  Look for files on \$PATH, like \"type -P\" builtin,\\n" >&2
      printf '  but do not stop after finding the first one, also\n'    >&2
      printf '  files do not necessarily have to be executable.\n\n'    >&2
      printf '  Usage:\n'                                               >&2
      printf '    digpath [-q] [-x] file1 file2 ...\n'                  >&2
      printf "    digpath [-q] [-x] 'shell_pattern'\\n"                 >&2
      printf '    digpath [-h]\n\n'                                     >&2
      printf '  Output:\n'                                              >&2
      printf '    print any matches on PATH to stdout,\n'               >&2
      printf '      suppresses output if -q given,\n'                   >&2
      printf '      suppresses nonexecutables if -x given.\n'           >&2
      printf '    print help to stderr if -h given\n\n'                 >&2
      printf '  Exit Status:\n'                                         >&2
      printf "    0 (true) if match found on \$PATH\\n"                 >&2
      printf '    1 (false) if no match found\n'                        >&2
      printf '    2 an unknown option or -h was given\n'                >&2
   }

   local OPTIND opt
   local quiet_flag=
   while getopts :hqx opt
   do
      case $opt in
         q) quiet_flag=1
            ;;
         x) executable_flag=1
            ;;
         h) usage_digpath
            return 2
            ;;
         ?) printf 'digpath: -%s: unknown option\n' "$OPTARG" >&2
            printf '  for help type: digpath -h\n' >&2
            return 2
            ;;
      esac
   done

   IFS=':'

   local ii=0  # for array index
   local File Target
   local FileList=()

   for File in "$@"
   do
      [[ -z $File ]] && continue
      for Dir in $PATH
      do
         [[ ! -d $Dir ]] && continue
         for Target in $Dir/$File
         do
            if [[ -e $Target ]] || [[ -L $Target ]]
            then
               if [[ -z $executable_flag ]] || [[ -x $Target ]]
               then
                  FileList[ii++]="$Target"
               fi
            fi
         done
      done
   done

   [[ -z $quiet_flag ]] && printf '%s\n' "${FileList[@]}"

   if ((${#FileList[@]} > 0))
   then
      return 0
   else
      return 1
   fi
)

# Archive eXtractor: usage: ax <file>
ax () {
   if [[ -f $1 ]]
   then
      case $1 in
         *.tar)     tar -xvf "$1"               ;;
         *.tar.bz2) tar -xjvf "$1"              ;;
         *.tbz2)    tar -xjvf "$1"              ;;
         *.tar.gz)  tar -xzvf "$1"              ;;
         *.tgz)     tar -xzvf "$1"              ;;
         *.tar.Z)   tar -xZvf "$1"              ;;
         *.gz)      gunzip "$1"                 ;;
         *.bz2)     bunzip2 "$1"                ;;
         *.zip)     unzip "$1"                  ;;
         *.Z)       uncompress "$1"             ;;
         *.rar)     unrar x "$1"                ;;
         *.tar.xz)  xz -dc "$1" | tar -xvf -    ;;
         *.tar.7z)  7za x -so "$1" | tar -xvf - ;;
         *.7z)      7z x "$1"                   ;;
         *.tar.zst) zstd -dc "$1" | tar -xvf -  ;;
         *.zst)     zstd -d "$1"                ;;
         *.cpio)    cpio -idv < "$1"            ;;
         *) printf 'ax: error: "%s" unknown file type' "$1"  >&2 ;;
      esac
   else
      if [[ -n $1 ]]
      then
         printf 'ax: error: "%s" is not a file' "$1" >&2
      else
         printf 'ax: error: No file argument given' >&2
      fi
   fi
}

# Convert between various bases (use capital A-F for hex-digits)
#
#   Examples: h2d "AA + BB" -> 357
#             h2h "AA + BB" -> 165
#             d2h 357       -> 165
#
h2h () { printf 'ibase=16\nobase=10\n%s\n'   "$*" | /usr/bin/bc; }
h2d () { printf 'ibase=16\nobase=A\n%s\n'    "$*" | /usr/bin/bc; }
h2o () { printf 'ibase=16\nobase=8\n%s\n'    "$*" | /usr/bin/bc; }
h2b () { printf 'ibase=16\nobase=2\n%s\n'    "$*" | /usr/bin/bc; }
d2h () { printf 'ibase=10\nobase=16\n%s\n'   "$*" | /usr/bin/bc; }
d2d () { printf 'ibase=10\nobase=10\n%s\n'   "$*" | /usr/bin/bc; }
d2o () { printf 'ibase=10\nobase=8\n%s\n'    "$*" | /usr/bin/bc; }
d2b () { printf 'ibase=10\nobase=2\n%s\n'    "$*" | /usr/bin/bc; }
o2h () { printf 'ibase=8\nobase=20\n%s\n'    "$*" | /usr/bin/bc; }
o2d () { printf 'ibase=8\nobase=12\n%s\n'    "$*" | /usr/bin/bc; }
o2o () { printf 'ibase=8\nobase=10\n%s\n'    "$*" | /usr/bin/bc; }
o2b () { printf 'ibase=8\nobase=2\n%s\n'     "$*" | /usr/bin/bc; }
b2h () { printf 'ibase=2\nobase=10000\n%s\n' "$*" | /usr/bin/bc; }
b2d () { printf 'ibase=2\nobase=1010\n%s\n'  "$*" | /usr/bin/bc; }
b2o () { printf 'ibase=2\nobase=1000\n%s\n'  "$*" | /usr/bin/bc; }
b2b () { printf 'ibase=2\nobase=10\n%s\n'    "$*" | /usr/bin/bc; }

#  Open Desktop file manager
fm () {
   local DiR="$1"
   [[ -n $DiR ]] || DiR="$PWD"
   xdg-open "$DiR" 2>/dev/null &
}

# Terminal which inherits environment of parent shell
tm () {
   if [[ -x /usr/bin/alacritty ]]; then
      ( /usr/bin/alacritty -e bash & )
   elif [[ -x /usr/local/bin/alacritty ]]; then
      ( /usr/local/bin/alacritty -e bash & )
   elif [[ -x /usr/bin/gnome-terminal ]]; then
      ( /usr/bin/gnome-terminal >&- 2>&- )
   elif [[ -x /usr/bin/urxvt ]]; then
      ( /usr/bin/urxvt >/dev/null 2>&1 & )
   elif [[ -x /usr/bin/xterm ]]; then
      ( /usr/bin/xterm >/dev/null 2>&1 & )
   else
      printf "tm: error: terminal emulator not found\n" >&2
   fi
}

#  PDF Reader
ev () ( /usr/bin/evince "$@" >/dev/null 2>&1 & )

# Firefox Browser
ff () {
   if digpath -q firefox
   then
      ( firefox "$@" >&- 2>&- & )
   else
      printf 'firefox not found\n' >&2
   fi
}

# LibreOffice
lo () ( /usr/bin/libreoffice & )
low () ( /usr/bin/libreoffice --writer "$@" & )

# For non-Systemd systems - supply phony hostnamectl command
if ! digpath -q hostnamectl
then
   function hostnamectl { hostname; }
fi

#  Setup JDK on Arch
archJDK () {
   local version="$1"
   local jdir
   local jver

   if [[ -z $version ]]
   then
      printf "\nAvailable Java Versions:"
      for jdir in /usr/lib/jvm/java-*-openjdk
      do
         jver=${jdir%-*}
         jver=${jver#*-}
         printf ' %s' "$jver"
      done
      printf '\n'
      return 0
   fi

   if [[ ! $version == @([1-9])*([0-9]) ]]
   then
      printf 'Malformed JDK version number: "%s"\n' "$version" >&2
      return 1
   fi

   if [[ -d /usr/lib/jvm/java-${version}-openjdk ]]
   then
      export JAVA_HOME=/usr/lib/jvm/java-${version}-openjdk
      if [[ $PATH == /usr/lib/jvm/java-@([1-9])*([0-9])-openjdk/bin:* ]]
      then
         PATH=${PATH#[^:]*:}
      fi
      PATH=$JAVA_HOME/bin:$PATH
      return 0
   else
      printf '\nNo JDK found for Java version %s in the\n' "$version" >&2
      printf 'standard location on Arch Linux: /usr/lib/jvm/\n' >&2
      return 1
   fi
}

## Make sure the initial shell environment is sane
if ! [[ -v BASHVIRGINPATH ]] && [[ -v FISHVIRGINPATH ]]
then
   export BASHVIRGINPATH=$FISHVIRGINPATH
fi

if ! [[ -v BASHVIRGINPATH ]]
then
   # Save original PATH
   export BASHVIRGINPATH="$PATH"

   # Set locale so commandline tools & other programs default to unicode
   export LANG=en_US.utf8

   # Setup editors/pagers
   if digpath -q nvim
   then
      export EDITOR=nvim
      export VISUAL=nvim
      export PAGER='nvim -R'
      export MANPAGER='nvim +Man!'
      export DIFFPROG='nvim -d'
   elif digpath -q vim
   then
      export EDITOR=vim
      export VISUAL=vim
   else
      export EDITOR=vi
      export VISUAL=vi
   fi

   # Set up path to dotfiles repo
   export DOTFILE_GIT_REPO=~/devel/dotfiles

   # Construct the shell's PATH for all my different computers,
   # non-existent and duplicate path elements dealt with at end.

   # Ruby tool chain
   #   Mostly for the Ruby Markdown linter,
   #   to install linter: $ gem install mdl
   if [[ -d ~/.local/share/gem/ruby ]]
   then
      ((ii = 0, jj = 0))
      for gemDir in ~/.local/share/gem/ruby/*/bin
      do
          gemDirs[ii++]="$gemDir"
      done

      case $ii in
         0) ;;
         1) PATH="${gemDirs[0]}:$PATH" ;;
         *) PATH="${gemDirs[0]}:$PATH"
            printf '\n[bashrc] Warning: Multiple Ruby Gem directories found'
            while ((jj < ii))
            do
               printf '\n  %s' "${gemDirs[$((jj++))]}"
               ((jj == 1)) && printf '  <- using this one'
               ((jj == ii)) && printf '\n'
            done ;;
      esac
      unset ii, jj, gemDirs
   fi

   # Location Rust Toolchain
   PATH=~/.cargo/bin:"$PATH"

   # Haskell locations used by Cabal and Stack
   PATH=~/.cabal/bin:~/.local/bin:"$PATH"

   # Utilities I want to overide everything
   PATH=~/opt/bin:"$PATH"

   # If there is a ~/bin directory, put near end
   PATH="$PATH":~/bin

   # Initial Python configuration
   export PIP_REQUIRE_VIRTUALENV=true
   export PYENV_ROOT=~/.local/share/pyenv
   export PYTHONPATH=lib:../lib
   digpath -q pyenv && export has_pyenv_installed

   # Configure Java for latest LTS release
   if uname -r | grep -q arch
   then
      archJDK 17
   fi

   # Minimize Neovim lspconfig and mason internal coupling
   PATH="$PATH":~/.local/share/nvim/mason/bin

   ## Clean up PATH
   PATH="$(pathtrim)"
fi

## Aliases

# ls alias family
alias ls='ls --color=auto'
alias la='ls -a'
alias lh='ls -lh'
alias ll='ls -ltr'

# For current directory, takes no arguments
alias l.='ls -dA .*'

alias pst='ps -ejH'
alias nv=nvim

# Website scrapping - pull down a subset of a website
alias Wget='/usr/bin/wget -p --convert-links -e robots=off'
# Pull down more -- Not good for large websites
alias WgetM='/usr/bin/wget --mirror -p --convert-links -e robots=off'

# grscheller/dotfiles aliases
alias dfInstall='$DOTFILE_GIT_REPO/dfInstall'
alias sfInstall='$DOTFILE_GIT_REPO/sfInstall'

## Make Bash more Korn Shell like
set -o pipefail
shopt -s extglob
shopt -s checkwinsize
shopt -s checkhash
shopt -s cmdhist
shopt -s lithist
shopt -s histappend
PROMPT_COMMAND='history -a'
HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoredups

## Prompt and window decorations

# Adjust displayed hostnames - change cattle names to pet names
MyHostName=$(hostnamectl hostname); MyHostName=${MyHostName%%.*}
case $MyHostName in
   rvsllschellerg2) MyHostName=voltron ;;
   SpaceCAMP31) MyHostName=sc31    ;;
esac

# Terminal window title prompt string
case $TERM in
   alacritty|xterm*|rxvt*|urxvt*|kterm*|gnome*)
      TERM_TITLE=$'\e]0;'"$(id -un)@${MyHostName}"$'\007' ;;
   *)
      TERM_TITLE='' ;;
esac

unset MyHostName

# Setup up 3 line prompt
PS1="\n[\s: \w]\n\$ ${TERM_TITLE}"
PS2='> '
PS3='#? '
PS4='++ '

## Configure Haskell Stack completion
if digpath -q stack
then
   # Bash completion for stack (Haskell)
   eval "$(stack --bash-completion-script stack)"
fi

## Python Pyenv function configuration
[[ -v has_pyenv_installed ]] && eval "$(pyenv init -)"
