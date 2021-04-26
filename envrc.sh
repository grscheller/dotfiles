#!/bin/sh
# shellcheck shell=sh
# shellcheck source=/dev/null
#
#    ~/.envrc
#
#  Used to configure all my POSIX compatible shells.
#  Not used for fish.
#
#  Configure initial values of $PATH and environment
#  variables you wish child processes, perhaps other
#  shells, to initially inherit.
#
#  This was traditionally done in .profile or .bash_profile
#  whenever a login shell was created.  Unfortunately,
#  in most Desktop Environments, the shells in terminal
#  emulators are not decendant from login shells.
#  We can no longer assume that .profile ever gets sourced.
#
#  Out of the blue, GNOME 3 gdm on ARCH began
#  non-interactively sourcing .profile.
#
#   Written by Geoffrey Scheller
#   See: https://github.com/grscheller/dotfiles
#

## Sentinel value to mark completion ofan initial environment configuration
export ENV_INIT_LVL=${ENV_INIT_LVL:=0}
ENV_INIT_LVL=$(( ENV_INIT_LVL + 1 ))

if ~/.local/bin/digpath.sh -q nvim
then
    export EDITOR=nvim
    export VISUAL=nvim
    export MANPAGER="nvim -c 'set ft=man' -"
    export PAGER='nvim -R'
elif ~/.local/bin/digpath.sh -q vim
then
    export EDITOR=vim
    export VISUAL=vim
else
    export EDITOR=vi
    export VISUAL=vi
fi

# Set locale so commandline tools & other programs default to unicode
export LANG=en_US.utf8

## Python configuration
export PYTHONPATH=lib:../lib
export PIP_REQUIRE_VIRTUALENV=true

## Construct the shell's PATH for all my different computers
#
#  Non-existent path and duplicate path elements
#  will be dealt with near end of script via ~/bin/pathtrim
#

# Save original PATH
[ -z "$VIRGIN_PATH" ] && export VIRGIN_PATH="$PATH"

# On iMac Brew installs symlinks here
PATH=/usr/local/sbin:$PATH

# If there is a ~/bin directory, put near end
PATH="$PATH":~/bin

# Put relative directories at end of PATH, this is for
# projects where the user takes up residence in the project's
# root directory.
PATH="$PATH":bin:./bin

# Rudy tool chain
#   Mostly for the Ruby Markdown linter,
#   to install linter: $ gem install mdl
eval PATH=~/.local/share/gem/ruby/*/bin:"$PATH"

# Location Rust Toolchain
PATH=~/.cargo/bin:"$PATH"

# Utilities I want to overide everything
PATH=~/.local/bin:~/opt/bin:"$PATH"

# Clean up PATH - remove duplicate and non-existent path entries
[ -x ~/.local/bin/pathtrim ] && PATH=$(~/.local/bin/pathtrim)

## Setup ENV Evironment variable if NOT already set
if [ -z "$ENV" ]
then
  MyShell=${0#-}; MyShell=${MyShell##*/}
  case "$MyShell"X in
    bashX)
        :
        ;;
    kshX)
        if [ -r ~/.kshrc ]; then
            export ENV=~/.kshrc
        elif [ -r ~/.shrc ]; then
            export ENV=~/.shrc
        fi
        ;;
    shX)
        if [ -r ~/.shrc ]; then
            export ENV=~/.shrc
        fi
        ;;
    ashX)
        if [ -r ~/.ashrc ]; then
            export ENV=~/.ashrc
        elif [ -r ~/.shrc ]; then
            export ENV=~/.shrc
        fi
        ;;
    dashX)
        if [ -r ~/.dashrc ]; then
            export ENV=~/.dashrc
        elif [ -r ~/.shrc ]; then
            export ENV=~/.shrc
        fi
        ;;
    esac
fi
unset MyShell
