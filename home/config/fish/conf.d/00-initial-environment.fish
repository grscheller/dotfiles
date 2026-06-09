## Ensure a sane initial environment is set up, if not already done so.
#
# Note: This file plays the same role as does the
#       file ~/.profile in a POSIX compliant shell.
#

# Sentinel value indicating whether an initial shell environment was setup
set -q _FISH_VIRGIN_PATH
or not begin
    set -gx _FISH_VIRGIN_PATH $PATH
    set -gx _FISH_INITIAL_SHELL
    set -g _Update_Fish_Environment
end
and set -e _FISH_INITIAL_SHELL

set -q _Redo_Fish_Environment
and begin
    cd
    set PATH $_FISHVIRGINPATH
    set -g _Update_Fish_Environment
    set -e _Redo_Fish_Environment
end

set -q _Update_Fish_Environment
and begin
    set -e _Update_Fish_Environment

    # Set locale
    set -gx LANG en_US.utf8

    # Path to dotfile GitHub repo
    set -gx DOTFILES_GIT_REPO ~/devel/dotfiles

    # Enable vi keybindings and cursor shape
    fish_vi_key_bindings
    set -g fish_cursor_default block
    set -g fish_cursor_insert line
    set -g fish_cursor_replace_one underscore
    set -g fish_cursor_visual underscore blink

    # Set up paging
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx SUDO_EDITOR /usr/bin/nvim
    set -gx PAGER 'nvim -R'
    set -gx MANPAGER 'nvim +Man!'
    set -gx DIFFPROG 'nvim -d'

    # Haskell locations used by Stack and Cabal
    set -p PATH ~/.local/bin ~/.cabal/bin $PATH

    # Configure JDK & Scala on Pop!OS
    set -p PATH ~/.local/share/coursier/bin
    jdk_version 21

    # Lua toolchain
    test -d ~/.local/share/nvim/lazy-rocks/hererocks/bin
    and set -p PATH ~/.local/share/nvim/lazy-rocks/hererocks/bin

    # Zig toolchain
    test -L ~/devel/zig_nightly/current
    and set -p PATH ~/devel/zig_nightly/current

    # Rust toolchain
    test -e ~/.cargo/env.fish
    and set -p PATH ~/.cargo/bin

    # Node.js toolchain
    test -d ~/devel/node_lts/node-v22.14.0-linux-x64/bin
    and set -p PATH ~/devel/node_lts/node-v22.14.0-linux-x64/bin

    # Python configuration
    set -gx PIP_REQUIRE_VIRTUALENV true
    set -gx VE_VENV_DIR ~/devel/venvs
    set -gx PYENV_ROOT ~/.local/share/pyenv
    set -a PATH $PYENV_ROOT/bin

    # Add ~/bin at end of PATH
    set PATH $PATH ~/bin

    # Cleanup PATH: remove duplicate & nonexistent entries, resolve symlinks
    set PATH (pathtrim)
end
