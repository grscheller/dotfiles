## Parse the commandline options
#
# Parses the option given by the user, if no option given
# the default is to "install".
#
# shellcheck shell=sh

usage="Usage: $SCRIPT_NAME [--install | --check | --remove | --clean | --nuke]"

if test $# -gt 1
then
    printf '\n%s\n\n' "$usage" >&2
    exit 1
elif test $# -eq 1
then
    case "$1" in
        --install)
            export DF_ACTION=install
            ;;
        --check)
            export DF_ACTION=check
            ;;
        --remove)
            export DF_ACTION=remove
            ;;
        --clean)
            export DF_ACTION=clean
            ;;
        --nuke)
            export DF_ACTION=nuke
            ;;
        *)
            printf '\n%s\n\n' "$usage" >&2
            exit 1
            ;;
    esac
fi
