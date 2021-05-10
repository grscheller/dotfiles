##
#  ~/.kshrc
#
#  Korn shell configuration across multiple,
#  more or or less, POSIX complient systems.
#
# shellcheck shell=ksh
# shellcheck source=/dev/null

## If not interactive, don't do anything.
[[ $- != *i* ]] && return

## Make sure an initial shell environment is well defined
export _ENV_INITIALIZED=${_ENV_INITIALIZED:=0}
((_ENV_INITIALIZED < 1)) && source ~/.environment_rc

## Set behaviors
set -o vi        # vi editing mode
set -o pipefail  # Return right most nonzero error, otherwise 0
HISTSIZE=5000

## Setup up prompt
source ~/.prompt_rc

## Shell functions (common to bash and ksh)
source ~/.functions_rc

## Aliases
source ~/.alias_rc

## Make sure POSIX shells all have their correct environments
source ~/.env_rc
