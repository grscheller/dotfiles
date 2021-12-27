##
#  ~/.profile
#
#  The Gnome display manager (gdm) will non-interactively
#  source ~/.profile with /bin/sh during Desktop setup.
#
#  Technically, only POSIX login shells should source this file.
#

case "$-" in
    *i*) # Initial interactive configurature for POSIX Shells
         . ~/.environment_rc

         # Set $ENV and $BASH_ENV
         MyShell=${0#-}; MyShell=${MyShell##*/}

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
