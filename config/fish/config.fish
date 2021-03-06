## Make sure $fish_features is set in universal scope
if [ -z "$fish_features" ]
    set -U fish_features stderr-nocaret qmark-noglob regex-easyesc
    set_color red
    printf '\nWarning: fish_features were not universally set,'
    printf '\n         restart fish for them to take effect.\n\n'
    set_color normal
end

## Setup environment variables
set -x EDITOR nvim
set -x VISUAL nvim
set -x PAGER nvim -R
set -x MANPAGER "nvim -c 'set ft=man' -"

# PATH variable management
set -q VIRGINPATH
or begin
    set -x VIRGINPATH $PATH
    set -x UPDATE_ENV
end

set -q REDO_ENV
and begin
    set -x PATH $VIRGINPATH
    set -x UPDATE_ENV
end

set -q UPDATE_ENV
and begin
    # Python configuration
    set -x --path PYTHONPATH lib ../lib
    set -x PIP_REQUIRE_VIRTUALENV true

    # On iMac Brew installs symlinks here
    set -p PATH /usr/local/sbin

    # Rudy tool chain
    #   Mostly for locally installed ruby gems,
    #     to install these:
    #       Markdown linter: $ gem install mdl
    #       Neovim syntax:   $ gem install neovim
    set -p PATH ~/.local/share/gem/ruby/*/bin
    set -p PATH /usr/local/Cellar/ruby/*/bin

    # Rust toolchain
    set -p PATH ~/.cargo/bin

    # SBT on iMac installed with SDKMAN
    set -p PATH ~/.sdkman/candidates/sbt/current/bin

    # Utilities I want to overide everything
    set -p PATH ~/.local/bin ~/opt/bin
    # Personal utilities available if not found elsewhere
    set -a PATH ~/bin
    # Added two relative paths used in some software projects
    set -a PATH bin ../bin

    # If on Arch, set up JDK for Java 11
    if string match -qr 'arch' (uname -r)
        archJDK 11
    end

    # Clean up duplicate and non-existing paths
    set PATH (pathtrim)

    # Let POSIX Shells know initial environment configured
    set -q _ENV_INITIALIZED
    or set -x _ENV_INITIALIZED 0
    set -x _ENV_INITIALIZED (math "$_ENV_INITIALIZED+1")

    set -e UPDATE_ENV
    set -e REDO_ENV
end

## Enable vi keybindings - Alacritty not supported for fish <= 3.1.2
fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual underscore blink

## Set up abriviations

# Neovim, need to type n<space> or nv<space> to choose
abbr -a -g n nvim
abbr -a -g nv nvim

# NVIDIA Daemon, need to type nv-<tab> to list choices
abbr -a -g -- nv-pd sudo /usr/bin/nvidia-persistenced --user grs --persistence-mode
abbr -a -g -- nv-off sudo /usr/bin/nvidia-smi -pm 0
abbr -a -g -- nv-on sudo nvidia-smi -pm 1
abbr -a -g -- dp digpath

## Let the various POSIX shells know their configuration files
if test -r ~/.shrc
    abbr -a -g sh ENV=~/.shrc sh
end

if test -r ~/.dashrc
    abbr -a -g dash ENV=~/.dashrc dash
else if test -r ~/.shrc
    abbr -a -g dash ENV=~/.shrc dash
end
