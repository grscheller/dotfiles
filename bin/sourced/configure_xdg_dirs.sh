## Setup XDG Desktop folder locations
#
# grscheller/dotfiles uses these names in its setup scripts.
#
# - defaults to standard locations if not already defined
# - tries to ensures directories exist
# - failure to create will be indicated via stderr
#
# shellcheck shell=sh

# Script exclusively use these names
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:=$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:=$HOME/.local/state}"

# Ensure these folder exists before installation.
ensure_dir "$XDG_CONFIG_HOME" >&2
chmod 0755 "$XDG_CONFIG_HOME"
ensure_dir "$XDG_DATA_HOME" >&2
chmod 0755 "$XDG_DATA_HOME"
ensure_dir "$XDG_STATE_HOME" >&2
chmod 0755 "$XDG_STATE_HOME"
ensure_dir "$XDG_CACHE_HOME" >&2
chmod 0755 "$XDG_CACHE_HOME"
