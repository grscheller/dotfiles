##
#  ~/.bashrc
#
# Bash configuration across multiple,
# more or or less, POSIX complient systems.
#
# shellcheck shell=bash
# shellcheck source=/dev/null

## If not interactive, don't do anything.
[[ $- != *i* ]] && return

## System wide configurations
#      Mechanism used on Redhat & Redhat derived systems
[[ -f /etc/bashrc ]] && source /etc/bashrc
#      Debian and Arch Linux derived systems typically
#      compile bash with option -DSYS_BASHRC which causes
#      bash to source /etc/bash.bashrc before ~/.bashrc.

## Make sure an initial shell environment is well defined
export _ENV_INITIALIZED=${_ENV_INITIALIZED:=0}
((_ENV_INITIALIZED < 1)) && source ~/.envrc

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

## Setup up prompt

# Adjust Hostname - change cattle names to pet names
HOST=$(hostname); HOST=${HOST%%.*}
case $HOST in
  rvsllschellerg2) HOST=voltron ;;
      SpaceCAMP31) HOST=sc31    ;;
esac

# Terminal window title prompt string
case $TERM in
  xterm*|rxvt*|urxvt*|kterm*|gnome*|alacritty)
      TERM_TITLE=$'\e]0;'"$(id -un)@\${HOST}"$'\007' ;;
  screen)
      TERM_TITLE=$'\e_'"$(id -un)@\${HOST}"$'\e\\' ;;
  *)
      TERM_TITLE='' ;;
esac

# Determine shell
MyShell=${0#-}; MyShell=${MyShell##*/}

# Setup 3 line prompt
PS1=$'\n['"${MyShell}"': \w]\n$ '"${TERM_TITLE}"
PS2='> '
PS3='#? '
PS4='++ '

## Functions common to both ~/.bashrc and ~/.kshrc

source ~/.funcrc

## Aliases

# Remove any inherited misconfigurations
unalias rm 2>&-
unalias ls 2>&-
unalias grep 2>&-
unalias egrep 2>&-
unalias fgrep 2>&-

# ls alias family
if [[ $(uname) == Darwin ]]
then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi
alias l1='ls -1'
alias la='ls -a'
alias ll='ls -ltr'
alias lh='ls -ltrh'
alias lha='ls -ltrha'
alias l.='ls -dA .*'

alias pst="ps axjf | sed -e '/^ PPID.*$/d' -e's/.*:...//'"
alias bc='bc -q'
alias nv=nvim

# Website scrapping
#   Pull down a subset of a website
alias Wget='/usr/bin/wget -p --convert-links -e robots=off'
#   Pull down more -- Not good for large websites
alias WgetMirror='/usr/bin/wget --mirror -p --convert-links -e robots=off'

# NVIDIA Daemon
#   keeps card active when not running X-Windows
alias nv-pd='sudo /usr/bin/nvidia-persistenced --user grs --persistence-mode'
#   Activate and Deactivate respectfully.
#      Communicates with above daemon if running, otherwise
#      directly with card in a deprecated manner.
alias nv-off='sudo /usr/bin/nvidia-smi -pm 0'
alias nv-on='sudo nvidia-smi -pm 1'

## SSH related functions, variables and aliases
#    Restart SSH key-agent and add your private
#    key, which is located here: ~/.ssh/id_rsa
alias addkey='eval $(ssh-agent) && ssh-add'
#    Make sure git asks for passwords on the command line
unset SSH_ASKPASS

## Configure Haskell

# Suppress pedantic warnings, and whatever else
# may get in the way of quickly syntax-checking
# and evaluating an expression.
ghci() { command ghci -v0 -Wno-all "$@"; }

if digpath -q stack
then
    # Bash completion for stack (Haskell)
    eval "$(stack --bash-completion-script stack)"
fi

## Make sure POSIX shells have their correct environments
alias sh='ENV=~/.shrc sh'

if [ -r ~/.dashrc ]; then
    alias dash='ENV=~/.dashrc dash'
elif [ -r ~/.shrc ]; then
    alias dash='ENV=~/.shrc dash'
fi

if [ -r ~/.kshrc ]; then
    alias ksh='ENV=~/.kshrc ksh'
elif [ -r ~/.shrc ]; then
    alias ksh='ENV=~/.shrc ksh'
fi

# Don't alias your current shell in case you deliberately changed $ENV
case "$MyShell"X in
    shX) unalias sh ;;
  dashX) unalias dash ;;
   kshX) unalias ksh ;;
  bashX) : ;;
      *) printf '\nWarning: Unexpected shell %s\n' "$MyShell" ;;
esac

unset -v MyShell
