# shellcheck shell=dash
#
# The COSMIC DE startup process properly sources a
# user's shell as a login shell to configure its environment.
# 
# Unfortunately, this shell is exec'ed to the next step
# in the startup process. Any ...
# After a fork, greetd will exec itself as dash sourcing
# this file to pick up user defined environment variables.
# 
#
# This reproduces the
# old CDE hack that seams to have become
# a de facto standard.
#

    export GRS_COSMIC_SENTINEL=0
