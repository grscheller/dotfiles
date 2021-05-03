#!/bin/sh
# shellcheck shell=sh
# shellcheck source=/dev/null
##
#  ~/.shrc
#

## If not interactive, don't do anything.
case $- in
    *i*) :      ;;
     * ) return ;;
esac

## Shell configuration
HISTSIZE=5000
set -o vi

PS1='$ '

# Similar to the DOS path command
path () {
   if [ $# -eq 0 ]
   then
       PathWord="$PATH"
   else
       PathWord="$1"
   fi

   # shellcheck disable=SC2086
   ( IFS=:; printf '%s\n' $PathWord )
}

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

if [ -r ~/.bashrc ]; then
    alias bash='ENV= bash'
elif [ -r ~/.shrc ]; then
    alias bash='ENV=~/.shrc bash'
fi

# Don't alias your current shell in case you deliberately changed $ENV
MyShell=${0#-}; MyShell=${MyShell##*/}

case "$MyShell"X in
    shX) unalias sh ;;
  dashX) unalias dash ;;
   kshX) unalias ksh ;;
  bashX) unalias bash ;;
      *) printf '\nWarning: Unexpected shell %s\n' "$MyShell" ;;
esac

unset -v MyShell
