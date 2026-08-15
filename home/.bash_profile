# shellcheck shell=bash
#
# ~/.bash_profile
#
# Bash login shells source this file and non-login shells source .bashrc
#
# Traditionally, an initial Bash environment was configured here
# upon system login via a login shell.  Other configurations, like
# functions and aliases, were configured by .bashrc.  Sourcing .bashrc,
# as is done below, ensures login shells also have these configurations.
#
# For many years I have had to put a mechanism into .bashrc to ensure
# that a consistent initial shell environment has been configured.
# This is due to certain display managers invoking entire desktop
# environments without ever going through a login shell.
#
# Fortunately, the Cosmic DE on Linux uses a mechanism to exec through
# a user's login shell before forking off the COSMIC DE. In the
# MSYS2 environment on Windows 11 mintty invokes bash as a login shell.
#

## configuration file (dotfile) infrastructure
export DOTFILE_GIT_REPOS=${DOTFILE_GIT_REPOS:$HOME/devel/dotfiles}
# export BASH_DOTFILE_GIT_REPO=$DOTFILE_GIT_REPOS/bash_dotfiles}
# export FISH_DOTFILE_GIT_REPO=$DOTFILE_GIT_REPOS/fish_dotfiles}
# export NVIM_DOTFILE_GIT_REPO=$DOTFILE_GIT_REPOS/nvim_dotfiles}
# export DEVEL_DOTFILE_GIT_REPO=$DOTFILE_GIT_REPOS/devel_dotfiles}
export BASH_DOTFILE_GIT_REPO=$DOTFILE_GIT_REPOS
export FISH_DOTFILE_GIT_REPO=$DOTFILE_GIT_REPOS
export NVIM_DOTFILE_GIT_REPO=$DOTFILE_GIT_REPOS
export DEVEL_DOTFILE_GIT_REPO=$DOTFILE_GIT_REPOS

## Get functions and aliases

# shellcheck disable=SC1090
[[ -f ~/.bashrc ]] && source ~/.bashrc

## Set up the initial shell environment

# Set locale so commandline tools & other programs default to unicode
export LANG=en_US.utf8

# Setup editors/pagers
if digpath -q nvim
then
   export EDITOR=nvim
   export VISUAL=nvim
   export PAGER='nvim -R'
   export MANPAGER='nvim +Man!'
   export DIFFPROG='nvim -d'
elif digpath -q vim
then
   export EDITOR=vim
   export VISUAL=vim
else
   export EDITOR=vi
   export VISUAL=vi
fi

# Set up path to dotfiles repo
export DOTFILE_GIT_REPOS=~/devel/dotfiles

# Location Rust Toolchain
PATH=~/.cargo/bin:"$PATH"

# Haskell locations used by Cabal and Stack
PATH=~/.cabal/bin:~/.local/bin:"$PATH"

# Python configuration
export PIP_REQUIRE_VIRTUALENV=true
export PYENV_ROOT=~/.local/share/pyenv
PATH="$PATH":$PYENV_ROOT/bin

# If there is a ~/bin directory, put near end
PATH="$PATH":~/bin

## Clean up PATH
PATH="$(pathtrim "$PATH")"
