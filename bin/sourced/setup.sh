# grscheller/dotfiles setup script
#
# Common infrastructure sourced into other dotfile installation scripts.
# Parses input arguments and setup functions for the dotfile scripts`.
# The idea is to keep the installation  scripts as simple as possible.0
#
# shellcheck shell=dash

## Sanity checks

if test -z "${df_home:=}" || test -z "${script_name:=}"
then
   printf '\nError: df_home and/or script_name variables not set!\n\n' >&2
   exit 1
fi

export DF_ACTION=${DF_ACTION:=''}

usage="Usage: $script_name [--install|--check|--remove|--clean|--nuke]"

if test -z "$DF_ACTION"
then
    # Source Functions
    . ../bin/sourced/source_functions.sh

    # Configure and create XDG Desktop Locations
    . ../bin/sourced/config_xdg_dirs.sh

    # Parse cmdline arguments
    if test $# -gt 1
    then
        printf '\n%s\n\n' "$usage"
        exit 1
    elif test $# -eq 1
    then
        case "$1" in
          --install)
             DF_ACTION=install
             ;;
          --check)
             DF_ACTION=check
             ;;
          --remove)
             DF_ACTION=remove
             ;;
          --clean)
             DF_ACTION=clean
             ;;
          --nuke)
             DF_ACTION=nuke
             ;;
          *)
             printf '\n%s\n\n' "$usage"
             exit 1
             ;;
        esac
    else
        DF_ACTION=install
    fi
fi
