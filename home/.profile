# shellcheck shell=dash
#
# Export a sentinel value so that shells know that an initial
# sane development environment has yet to be configured. Takes
# advantaged of an old CDE hack that seams to have become
# a de facto standard.
#
# Also acts as a bash fallback in environments without
# an up-to-date fish installed.
#
# So that bash will source this file, my dotfile installation
# scripts remove both ~/.bash_profile or ~/.bash_login if they
# exist.
#

if [ -n "$BASH_VERSION" ]
then
    # If sourced by bash.
    if [ -f "$HOME/.bashrc" ]
    then
        . "$HOME/.bashrc"
    fi
else
    # When greatd sources with /usr/bin/sh which is dash.
    export GRS_COSMIC_SENTINEL=unconfigured
fi
