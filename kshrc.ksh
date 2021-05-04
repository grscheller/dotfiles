#!/bin/ksh
# shellcheck shell=ksh
# shellcheck source=/dev/null
##
#  ~/.kshrc
#
# Korn shell configuration across multiple,
# more or or less, POSIX complient systems.
#

## If not interactive, don't do anything.
[[ $- != *i* ]] && return

## Make sure an initial shell environment is well defined
export _ENV_INITIALIZED=${_ENV_INITIALIZED:=0}
((_ENV_INITIALIZED < 1)) && source ~/.envrc

## Set behaviors
set -o vi        # vi editing mode
set -o pipefail  # Return right most nonzero error, otherwise 0
HISTSIZE=5000

## Setup up prompt

# Adjust Hostname - change cattle names to pet names
HOST=$(hostname); HOST=${HOST%%.*}
case $HOST in
  rvsllschellerg2) HOST=voltron ;;
      SpaceCAMP31) HOST=sc31    ;;
esac

# Terminal window title prompt string
case $TERM in
  xterm*|rxvt*|urxvt*|kterm*|gnome*|alacritty)
      TERM_TITLE=$'\e]0;'"$(id -un)@\${HOST}"$'\007' ;;
  screen)
      TERM_TITLE=$'\e_'"$(id -un)@\${HOST}"$'\e\\' ;;
  *)
      TERM_TITLE='' ;;
esac

# Setup 3 line primary prompt
function relative_pwd
{
   if [[ ${PWD:0:${#HOME}} == "$HOME" ]]
   then
       printf '%s' "~${PWD:${#HOME}}"
   else
       printf '%s' "$PWD"
   fi
}

# Determine shell
MyShell=${0#-}; MyShell=${MyShell##*/}

# Setup 3 line prompt
PS1=$'\n['"${MyShell}"$': $(relative_pwd)]\n$ '"${TERM_TITLE}"
PS2='> '
PS3='#? '
PS4='++ '

## Command line utility functions

# Jump up multiple directories
function ud
{
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
function path
{
   if (( $# == 0 ))
   then
       PathWord="$PATH"
   else
       PathWord="$1"
   fi

   # shellcheck disable=SC2086
   ( IFS=':'; printf '%s\n' $PathWord )
}

# Archive eXtractor: usage: ax <file>
function ax
{
   if [[ -f $1 ]]
   then
       case $1 in
         *.tar)     tar -xvf "$1"                        ;;
         *.tar.bz2) tar -xjvf "$1"                       ;;
         *.tbz2)    tar -xjvf "$1"                       ;;
         *.tar.gz)  tar -xzvf "$1"                       ;;
         *.tgz)     tar -xzvf "$1"                       ;;
         *.tar.Z)   tar -xZvf "$1"                       ;;
         *.gz)      gunzip "$1"                          ;;
         *.bz2)     bunzip2 "$1"                         ;;
         *.zip)     unzip "$1"                           ;;
         *.Z)       uncompress "$1"                      ;;
         *.rar)     unrar x "$1"                         ;;
         *.tar.xz)  xz -dc "$1" | tar -xvf -             ;;
         *.tar.7z)  7za x -so "$1" | tar -xvf -          ;;
         *.7z)      7z x "$1"                            ;;
         *.cpio)    cpio -idv < "$1"                     ;;
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

# Setup JDK on Arch
function archJDK
{
   local version="$1"
   local jdir
   local jver

   if [[ -z $version ]]
   then
       printf "Available Java Versions: "
       for jdir in /usr/lib/jvm/java-*-openjdk
       do
           jver=${jdir%-*}
           jver=${jver#*-}
           printf '%s ' "$jver"
       done
       printf '\n'
       return
   fi

   if [[ ! $version == @([1-9])*([0-9]) ]]
   then
       printf "Malformed JDK version number: \"%s\"\n" "$version"
       return
   fi

   if [[ -d /usr/lib/jvm/java-${version}-openjdk ]]
   then
       export JAVA_HOME=/usr/lib/jvm/java-${version}-openjdk
       if [[ $PATH == /usr/lib/jvm/java-@([1-9])*([0-9])-openjdk/bin:* ]]
       then
           PATH=${PATH#[^:]*:}
       fi
       PATH=$JAVA_HOME/bin:$PATH
   else
       printf "No JDK found for Java \"%s\" in the\n" "$version"
       printf "standard location for Arch: /usr/lib/jvm/\n"
   fi
}

## Aliases

# Remove any inherited misconfigurations
unalias rm 2>&-
unalias ls 2>&-
unalias grep 2>&-
unalias egrep 2>&-
unalias fgrep 2>&-

# ls alias family
if [[ $(uname) == Darwin ]]
then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi
alias l1='ls -1'
alias la='ls -a'
alias ll='ls -ltr'
alias lh='ls -ltrh'
alias lha='ls -ltrha'
alias l.='ls -dA .*'

alias pst="ps axjf | sed -e '/^ PPID.*$/d' -e's/.*:...//'"
alias bc='bc -q'
alias nv=nvim

# Website scrapping
#   Pull down a subset of a website
alias Wget='/usr/bin/wget -p --convert-links -e robots=off'
#   Pull down more -- Not good for large websites
alias WgetMirror='/usr/bin/wget --mirror -p --convert-links -e robots=off'

# NVIDIA Daemon
#   keeps card active when not running X-Windows
alias nv-pd='sudo /usr/bin/nvidia-persistenced --user grs --persistence-mode'
#   Activate and Deactivate respectfully.
#      Communicates with above daemon if running, otherwise
#      directly with card in a deprecated manner.
alias nv-off='sudo /usr/bin/nvidia-smi -pm 0'
alias nv-on='sudo nvidia-smi -pm 1'

## SSH related functions, variables and aliases
#    Restart SSH key-agent and add your private
#    key, which is located here: ~/.ssh/id_rsa
alias addkey='eval $(ssh-agent) && ssh-add'
#    Make sure git asks for passwords on the command line
unset SSH_ASKPASS

## Configure Haskell

# Suppress pedantic warnings, and whatever else
# may get in the way of quickly syntax-checking
# and evaluating an expression.
ghci() { command ghci -v0 -Wno-all "$@"; }

## Make sure POSIX shells have their correct environments
alias sh='ENV=~/.shrc sh'

if [ -r ~/.dashrc ]; then
    alias dash='ENV=~/.dashrc dash'
elif [ -r ~/.shrc ]; then
    alias dash='ENV=~/.shrc dash'
fi

if [ -r ~/.kshrc ]; then
    alias ksh='ENV=~/.kshrc ksh'
elif [ -r ~/.shrc ]; then
    alias ksh='ENV=~/.shrc ksh'
fi

# Don't alias your current shell in case you deliberately changed $ENV
case "$MyShell"X in
    shX) unalias sh ;;
  dashX) unalias dash ;;
   kshX) unalias ksh ;;
  bashX) : ;;
      *) printf '\nWarning: Unexpected shell %s\n' "$MyShell" ;;
esac

unset -v MyShell
