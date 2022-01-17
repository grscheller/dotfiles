##
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
#      Mechanism used on Redhat & Redhat derived systems
[[ -f /etc/bashrc ]] && source /etc/bashrc
#      Debian and Arch Linux derived systems typically
#      compile bash with option -DSYS_BASHRC which causes
#      bash to source /etc/bash.bashrc before ~/.bashrc.

## Shell functions
source ~/.functions_rc

## Aliases
source ~/.alias_rc

## Make sure an initial shell environment is well defined
export _ENV_INITIALIZED=${_ENV_INITIALIZED:=0}
((_ENV_INITIALIZED < 1)) && source ~/.environment_rc

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

## Setup up 3 line prompt
source ~/.prompt_rc

## Make sure POSIX shells all have their correct environments
source ~/.env_rc

## SDKMAN, for MacOS
if [[ -s ~/.sdkman/bin/sdkman-init.sh ]]
then
    source ~/.sdkman/bin/sdkman-init.sh
    PATH="$(pathtrim)"     # Clean up $PATH
fi
