# shellcheck shell=bash
#
# ~/.bashrc
#
# Bash configuration aimed at modern Systemd based Linus systems.
#
# Primarily as a fallback when fish is unavailable
# or for Pop OS 22.04 whose fish is way too out-of-date.
#

## If not interactive, don't do anything.
[[ $- != *i* ]] && return

## Shell functions

#  Jump up multiple directories
function ud {
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
function pa {
   local PathWord
   if (( $# == 0 ))
   then
      PathWord="$PATH"
   else
      PathWord="$1"
   fi

   # shellcheck disable=SC2086
   ( IFS=':'; printf '%s\n' $PathWord )
}

# Canonicalize and remove duplicate $PATH components 
function pathtrim {
   if [[ $# -eq 0 ]]
   then
      printf 'Error: pathtrim takes exactly one arguement\n\n'
      return 1
   fi
   local PathRaw="$1"

   # Standardize the $PATH list:
   # - remove redundant / and :
   # - remove trailing /'s on directory names
   # - replace /./ -> /
   # - escape tabs, spaces, and parentheses
   local sedScript="s!/+!/!g
                    s!:+!:!g
                    s!([^:])/:!\1:!g
                    s!/\./!/!g
                    s!:\./!:!g
                    s! !\\ !g
                    s!	!\\	!g
                    s!\(!\\(!g
                    s!\)!\\)!g
                    s!^:!!"

   local PathNormalized DirsCanonicalized Dir addToPath
   PathNormalized="$(printf %s "$PathRaw" | sed -E -e "$sedScript")"
   DirsCanonicalized=

   IFS=':'
   for Dir in $PathNormalized
   do
      if [[ -d $Dir ]]
      then
         Dir="$(readlink --canonicalize-existing "$Dir")"
      else
         continue
      fi

      (( nn = 0 ))
      addToPath=
      while (( nn < ${#DirsCanonicalized[@]} ))
      do
         if [[ $Dir == "${DirsCanonicalized[$nn]}" ]]
         then
            unset addToPath
            break
         fi
         (( nn++ ))
      done

      if [[ -v addToPath ]]
      then
         DirsCanonicalized[$nn]="$Dir"
      fi
   done
   unset IFS

   PathTrimmed=
   for Dir in "${DirsCanonicalized[@]}"
   do
      PathTrimmed="$PathTrimmed:$Dir"
   done
   # PathTrimmed=$(printf %s "$PathTrimmed" | sed -E -e "$sedScript")
   printf '%s\n' "${PathTrimmed}"

   return 0
}

# Drill down through $PATH to look for files or directories.
# Like the ksh builtin whence, except it does not stop
# after finding the first instance. Handles spaces in both
# filenames and directories on $PATH. Also, shell patterns
# are supported.
function digpath {
   local OPTIND opt
   local quiet_flag=
   while getopts :qx opt
   do
      case $opt in
         q) quiet_flag=1
            ;;
         x) executable_flag=1
            ;;
         ?) printf "usage: digpath [-q] [-x] 'glob1' ['glob2' 'glab3' ...]"
            return 2
            ;;
      esac
   done

   local Dir File FileList ii Target
   FileList=
   ii=0

   IFS=':'
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
   unset IFS

   [[ -z $quiet_flag ]] && printf '%s\n' "${FileList[@]}"

   if ((${#FileList[@]} > 0))
   then
      return 0
   else
      return 1
   fi
}

# Archive eXtractor: usage: ax <file>
function ax {
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

#  Open Desktop file manager
function fm {
   local DiR="$1"
   [[ -n $DiR ]] || DiR="$PWD"
   xdg-open "$DiR" 2>/dev/null &
}

# Terminal which inherits environment of parent shell
function tm {
   if [[ -x /usr/bin/alacritty ]]; then
      ( /usr/bin/alacritty & )
   elif [[ -x /usr/bin/cosmic-term ]]; then
      ( /usr/bin/cosmic-term & )
   elif [[ -x /usr/bin/gnome-terminal ]]; then
      ( /usr/bin/gnome-terminal >/dev/null 2>&1 & )
   elif [[ -x /usr/bin/xterm ]]; then
      ( /usr/bin/xterm >/dev/null 2>&1 & )
   else
      printf "error: no terminal emulator found\n" >&2
   fi
}

#  PDF Reader
function ev {
   ( /usr/bin/evince "$@" >/dev/null 2>&1 & )
}

# Firefox Browser
function ff {
   if digpath -q firefox
   then
      ( firefox "$@" >&- 2>&- & )
   else
      printf 'firefox not found\n' >&2
   fi
}

## Make sure the initial shell environment is sane

# Initial starting point - we want to be able to override these in subshells
if [[ ! -v BASHVIRGINPATH ]] || [[ -v FORCEBASHREDO ]]
then
   if [[ -v FORCEBASHREDO ]] && [[ -v BASHVIRGINPATH ]]
   then
      PATH="$BASHVIRGINPATH"
   fi
   unset FORCEBASHREDO

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
   export DOTFILE_GIT_REPOS=~/devel/dotfiles

   # Location Rust Toolchain
   PATH=~/.cargo/bin:"$PATH"

   # Haskell locations used by Cabal and Stack
   PATH=~/.cabal/bin:~/.local/bin:"$PATH"

   # If there is a ~/bin directory, put near end
   PATH="$PATH":~/bin

   ## Clean up PATH
   PATH="$(pathtrim "$PATH")"
fi

## Aliases

alias nv=nvim
alias pst='ps -ejH'

# ls alias family
alias ls='ls --color=auto'
alias la='ls -a'
alias lh='ls -lh'
alias ll='ls -ltr'
alias l.='ls -dA .*'   # for current directory only

# appropriate for cosmic desktop environment - single quotes intentional
alias bInstall='$DOTFILE_GIT_REPOS/bash-env/bashInstall'
alias nvInstall='$DOTFILE_GIT_REPOS/nvim-env/nvimInstall'

# Website scrapping - pull down a subset of a website
alias Wget='/usr/bin/wget -p --convert-links -e robots=off'
# Pull down more -- Not good for large websites
alias WgetM='/usr/bin/wget --mirror -p --convert-links -e robots=off'

alias ga='git add'
alias gb='git branch'
alias gbl='git branch --list|cat'
alias gc='git commit -S'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch'
alias gh='git push'
alias gl='git log'
alias gm='git mv'
alias gp='git pull'
alias gs='git status'
alias gsu='git submodule update'
alias gsm='git submodule update --remote --merge'
alias gt='git tag --list|cat'
alias gw='git switch'

alias dp='digpath'

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

# get hostnames
MyHostName=$(hostnamectl hostname)
MyHostName=${MyHostName%%.*}

# Terminal window title prompt string
case $TERM in
   alacritty|cosmic-term|gnome*|xterm*)
      TERM_TITLE=$'\e]0;'"$(id -un)@${MyHostName}"$'\007' ;;
   *)
      TERM_TITLE='' ;;
esac

unset MyHostName

# Setup up 3 line prompt
PS1="[\s: \w]\n\$ ${TERM_TITLE}"
PS2='> '
PS3='#? '
PS4='++ '

# Python configuration
export PIP_REQUIRE_VIRTUALENV=true
export PYENV_ROOT=~/.local/share/pyenv
if [[ -e "$PYENV_ROOT/bin/pyenv" ]]
then
   eval "$($PYENV_ROOT/bin/pyenv init -)"
fi
