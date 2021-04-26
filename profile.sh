#!/bin/sh
# shellcheck shell=sh
# shellcheck source=/dev/null
##
#   ~/.profile
#

#  The Gnome display manager (gdm) will non-interactively
#  source ~/.profile with /bin/sh during Desktop setup.
#
#  Technically, only POSIX login shells should source this file.
#
case "$-" in
  *i*)
      # Initial interactive configurature for POSIX Shells
      . ~/.envrc
      
      # If Bash, get functions and aliases
      MyShell=${0#-}; MyShell=${MyShell##*/}
      case "$MyShell"X in
        bashX)
            if [ -r ~/.bashrc ]; then
                . ~/.bashrc
            fi
            ;;
        shX|ashX|dashX|kshX)
            :
            ;;
        *)
            # Fish should never see this
            printf 'Warning: Unexpected shell "%s\n"' "$0" >&2
            ;;
      esac
      unset MyShell
      ;;

  *)
      # Non-interactive environment configuration for display managers
      :
      ;;
esac
