# grscheller/dotfiles setup script
#
# Common infrastructure sourced into other dotfile installation scripts.
# Parses input arguments and setup functions for the dotfile scripts`.
# The idea is to keep the installation  scripts as simple as possible.0
#
# shellcheck shell=dash

## Set up globals

umask 0022

# For initial bootstrap when $XDG directories might not exist yet
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:=$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:=$HOME/.local/state}"

ensure_dir "$XDG_CONFIG_HOME"
chmod 0755 "$XDG_CONFIG_HOME"
ensure_dir "$XDG_DATA_HOME"
chmod 0755 "$XDG_DATA_HOME"
ensure_dir "$XDG_STATE_HOME"
chmod 0755 "$XDG_STATE_HOME"
ensure_dir "$XDG_CACHE_HOME"
chmod 0755 "$XDG_CACHE_HOME"
