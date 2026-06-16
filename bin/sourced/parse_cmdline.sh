## Parse the commandline options
#
# Parses the option given by the user, if no option given
# the default is to "install".
#
# shellcheck shell=sh

usage="Usage: $script_name [--install | --check | --remove | --clean | --nuke]"

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
fi
