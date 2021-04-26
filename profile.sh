#!/bin/sh
# shellcheck shell=sh
# shellcheck source=/dev/null
##
#   ~/.profile
#
#   Written by Geoffrey Scheller
#   See: https://github.com/grscheller/dotfiles
#

## If not interactive, don't do anything.
#
#    The Gnome display manager (gdm) will non-interactively
#    source ~/.profile.
#
case "$-" in
    *i*) :      ;;
     * ) return ;;
esac

## Configurature an initial interactive environment
[ -r ~/.envrc ] && . ~/.envrc

## If Bash, get functions and aliases, fish should never see this.
MyShell=${0#-}; MyShell=${MyShell##*/}
case "$MyShell"X in
  bashX)
      if [ -r ~/.bashrc ]; then
          . ~/.bashrc
      fi
      ;;
  kshX|shX|ashX|dashX)
      :
      ;;
  *)
      printf 'Warning: Unexpected shell "%s\n"' "$0" >&2
      ;;
esac
unset MyShell

## Perform other tasks unique to actual login shells
