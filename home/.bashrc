#!/bin/bash
#
#  ~/.bashrc
#
#  Bash configuration across multiple,
#  more or or less, POSIX complient systems.
#
#  No longer supporting MinGW/CygWin.
#

## If not interactive, don't do anything.
[[ $- != *i* ]] && return

## System wide configurations
#  Debian and Arch source /etc/bash.bashrc before ~/.bashrc.
[[ -f /etc/bashrc ]] && source /etc/bashrc  # Used on Redhat & Fedora

## Shell functions
source ~/.bashrc_functions

## Make sure an initial shell environment is well defined.
#  In the olde days, this was done in "~/.bash_prfile".
export _ENV_INITIALIZED=${_ENV_INITIALIZED:=0}
((_ENV_INITIALIZED < 1)) && {
    _ENV_INITIALIZED=$(( _ENV_INITIALIZED + 1 ))
    
    ## Set locale so commandline tools & other programs default to unicode
    export LANG=en_US.utf8
    
    ## Setup editors/pagers
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
    
    ## Construct the shell's PATH for all my different computers,
    ## non-existent and duplicate path elements dealt with at end.
    
    # Save original PATH
    [ -z "$VIRGIN_PATH" ] && export VIRGIN_PATH="$PATH"
    
    # Ruby tool chain
    #   Mostly for the Ruby Markdown linter,
    #   to install linter: $ gem install mdl
    if [ -d ~/.local/share/gem/ruby ]
    then
        eval PATH=~/.local/share/gem/ruby/*/bin:"$PATH"
    fi
    
    # Location Rust Toolchain
    PATH=~/.cargo/bin:"$PATH"
    
    # Haskell locations used by Cabal and Stack
    PATH=~/.cabal/bin:~/.local/bin:"$PATH"
    
    # Utilities I want to overide everything
    PATH=~/opt/bin:~/.local/bin:"$PATH"
    
    # If there is a ~/bin directory, put near end
    PATH="$PATH":~/bin
    
    # Put relative directories at end of PATH, this is for projects
    # where the user takes up residence in the project's root directory.
    PATH="$PATH":bin:../bin:.
    
    # Initial Python configuration
    export PIP_REQUIRE_VIRTUALENV=true
    export PYENV_ROOT=~/.pyenv
    PATH=$PYENV_ROOT/shims:"$PATH"
    export PYTHONPATH=lib:../lib
    
    # Configure Java for Sway/Wayland on ARCH
    if uname -r | grep -q arch
    then
        archJDK 17
        export _JAVA_AWT_WM_NONREPARENTING=1
    fi
    
    ## Clean up PATH
    PATH="$(pathtrim)"
}

## Aliases
# Remove any "helpful" aliases
unalias rm 2>&-
unalias ls 2>&-
unalias grep 2>&-
unalias egrep 2>&-
unalias fgrep 2>&-

# ls alias family
if [[ $(uname) = DarwinX ]]
then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi
alias la='ls -a'
alias lh='ls -lh'
alias ll='ls -ltr'

# For current directory, takes no arguments
alias l.='ls -dA .*'

alias pst="ps axjf | sed -e '/^ PPID.*$/d' -e's/.*:...//'"
alias bc='bc -q'
alias nv=nvim

# Website scrapping
#   Pull down a subset of a website
alias Wget='/usr/bin/wget -p --convert-links -e robots=off'
#   Pull down more -- Not good for large websites
alias WgetM='/usr/bin/wget --mirror -p --convert-links -e robots=off'

## SSH related functions, variables and aliases
#    Restart SSH key-agent and add your private
#    key, which is located here: ~/.ssh/id_rsa
alias addkey='eval $(ssh-agent) && ssh-add'
#    Make sure git asks for passwords on the command line
unset SSH_ASKPASS

## Setup behaviors - make BASH more Korn Shell like
set -o pipefail  # Return right most nonzero error, otherwise 0
shopt -s extglob
shopt -s checkwinsize
shopt -s checkhash
shopt -s cmdhist
shopt -s lithist
shopt -s histappend
PROMPT_COMMAND='history -a'
HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoredups

## Prompt and window construction
# Adjust hostname - change cattle names to pet names
MyHostName=$(hostnamectl hostname); MyHostName=${MyHostName%%.*}
case $MyHostName in
  rvsllschellerg2) MyHostName=voltron ;;
      SpaceCAMP31) MyHostName=sc31    ;;
esac

# Terminal window title prompt string
case $TERM in
  xterm*|rxvt*|urxvt*|kterm*|gnome*|alacritty)
      TERM_TITLE=$'\e]0;'"$(id -un)@${MyHostName}"$'\007' ;;
  *)
      TERM_TITLE='' ;;
esac

unset MyHostName

# Setup up 3 line prompt
PS1="\n[\s: \w]\n\$ ${TERM_TITLE}"
PS2='> '
PS3='#? '
PS4='++ '

## SDKMAN, for MacOS
if [[ -s ~/.sdkman/bin/sdkman-init.sh ]]
then
    source ~/.sdkman/bin/sdkman-init.sh
    PATH="$(pathtrim)"     # Clean up $PATH
fi

## Configure Haskell
#  Suppress pedantic warnings, and whatever else may get in the
#  way of quickly syntax-checking and evaluating an expression
ghci() { command ghci -v0 -Wno-all "$@"; }

if digpath -q stack
then
    # Bash completion for stack (Haskell)
    eval "$(stack --bash-completion-script stack)"
fi

## Python Pyenv function configuration
test -d "$PYENV_ROOT" && eval "$(pyenv init -)"
