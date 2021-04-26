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
alias ash='ENV=~/.shrc ash'
alias dash='ENV=~/.shrc dash'
if [ -r ~/.kshrc ]; then
    alias ksh='ENV=~/.kshrc ksh'
elif [ -r ~/.shrc ]; then
    alias ksh='ENV=~/.shrc ksh'
fi
alias sh='ENV=~/.shrc sh'

# Don't alias your shell in case you deliberately changed $ENV
MyShell=${0#-}; MyShell=${MyShell##*/}
case "$MyShell"X in
  shX)
      unalias sh
      ;;
  ashX)
      unalias ash
      ;;
  bashX)
      :
      ;;
  dashX)
      unalias dash
      ;;
  kshX)
      unalias ksh
      ;;
  *)
      printf '\nWarning: Unexpected shell "%s"\n\n' "$MyShell"
      ;;
esac
unset MyShell
