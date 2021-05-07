##
#  ~/.profile
#
#  The Gnome display manager (gdm) will non-interactively
#  source ~/.profile with /bin/sh during Desktop setup.
#
#  Technically, only POSIX login shells should source this file.
#
# shellcheck shell=sh
# shellcheck source=/dev/null

case "$-" in
    # Initial interactive configurature for POSIX Shells
    *i*) . ~/.envrc

         # If Bash, get functions and aliases
         MyShell=${0#-}; MyShell=${MyShell##*/}
         case "$MyShell"X in
             bashX) test -r ~/.bashrc && . ~/.bashrc ;;
                 *) :                                ;;
         esac
         unset MyShell
         ;;

      # Non-interactive environment configuration for display managers
      *)
         :
         ;;
esac
