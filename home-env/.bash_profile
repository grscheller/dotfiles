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
# Unfortunately, I have had to put a mechanism into .bashrc to ensure
# that a consistent initial shell environment has been configured.
# This is due to certain display managers invoking entire desktop
# environments without ever going through a login shell.
# 

# shellcheck disable=SC1090
[[ -f ~/.bashrc ]] && source ~/.bashrc
