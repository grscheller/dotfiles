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
set -x MANPAGER nvim -c 'set ft=man' -

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
    set -gx --path PYTHONPATH lib ../lib
    set -gx PIP_REQUIRE_VIRTUALENV true

    # Rudy tool chain
    #   Mostly for locally installed ruby gems,
    #     to install these:
    #       Markdown linter: $ gem install mdl
    #       Neovim syntax:   $ gem install neovim
    set -p PATH ~/.local/share/gem/ruby/*/bin
    set -p PATH /usr/local/Cellar/ruby/*/bin

    # Rust toolchain
    set -p PATH ~/.cargo/bin

    # Personal utilits I want to overide everything
    set -p PATH ~/.local/bin
    # Rersonal utilities available if not found elsewhere
    set -a PATH ~/bin
    # Added two relative paths used in some software projects
    set -a PATH bin ../bin

    # Clean up duplicate and non-existing paths
    set PATH (pathtrim "$PATH")

    set -e UPDATE_ENV
    set -e REDO_ENV
end

## Enable vi keybindings - Alacritty not supported for fish <= 3.1.2
fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual underscore blink
