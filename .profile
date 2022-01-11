##
#  ~/.profile
#
#  For use by all my interactive POSIX login shells.
#
#  The Gnome display manager (gdm) will non-interactively
#  source ~/.profile with /bin/sh during Desktop setup.
#
#  Technically, only POSIX login shells should source this file.
#

case "$-" in
    *i*) MyShell=${0#-}; MyShell=${MyShell##*/}

         # Force a reinitialization of the environment
         export _ENV_INITIALIZED=0

         export BASH_ENV=~/.bashrc
         case "$MyShell"X in
               shX) export ENV=~/.shrc ;;
             dashX) export ENV=~/.dashrc ;;
             bashX) . ${BASH_ENV} ;;
                 *) : ;;
         esac

         unset -v MyShell
         ;;

      *) # Non-interactive environment configuration for display managers
         :
         ;;
esac
