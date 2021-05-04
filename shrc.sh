#!/bin/sh
# shellcheck shell=sh
# shellcheck source=/dev/null
##
#  ~/.shrc
#
# POSIX shell configuration across multiple,
# more or or less, POSIX complient systems.
#

## If not interactive, don't do anything.
case $- in
    *i*) :      ;;
     * ) return ;;
esac

## Make sure an initial shell environment is well defined
export _ENV_INITIALIZED=${_ENV_INITIALIZED:=0}
test $_ENV_INITIALIZED -lt 1 && . ~/.envrc

## Set behaviors
set -o vi
HISTSIZE=5000

## Setup up prompt

# Adjust Hostname - change cattle names to pet names
HOST=$(hostname); HOST=${HOST%%.*}
case $HOST in
  rvsllschellerg2) HOST=voltron ;;
      SpaceCAMP31) HOST=sc31    ;;
esac

# Determine shell
MyShell=${0#-}; MyShell=${MyShell##*/}

PS1="\n[${MyShell}]\n$ "
PS2='> '
PS3='#? '
PS4='++ '

## Command line utility functions

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
