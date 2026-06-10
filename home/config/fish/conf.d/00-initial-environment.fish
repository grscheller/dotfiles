## Ensure a sane initial environment is set up for login shells.
#
# Note: This file plays the same role as does the
#       file ~/.profile in a POSIX compliant shell.
#
# Console and SSH connections invoke login shells. The problem is
# the default cosmic-term keybinding <super+t> does not start my
# my shell, fish, as a login shell. My solution was to create a
# custom keybinding <super-enter> for 'cosmic-term -- fish --login'.
#
# - Thus I can configure a sane initial fish environment is
#   configured by just testing if the fish session is a login shell.
#
# - My shell function tm will invoke a disown cosmic-term running
#   fish with the same environment as the caller.
#
# - I get a brand new configured fish shell running in a new
#   cosmic-term via <super-enter> which needs to manually configured.
#
# - I can forget <super+t> even exists.
#

# Enable vi keybindings and cursor shape
fish_vi_key_bindings
set -g fish_cursor_default block
set -g fish_cursor_insert line
set -g fish_cursor_replace_one underscore
set -g fish_cursor_visual underscore blink

status is-login
and begin
    set -gx FISH_VIRGIN_PATH_GRS $PATH
    set -gx FISH_LOGIN_SHELL_GRS $fish_pid

    # Set locale
    set -gx LANG en_US.utf8

    # Path to dotfile GitHub repo
    set -gx DOTFILES_GIT_REPO ~/devel/dotfiles

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

    # Setup an SSH Agent that non-login shells can inherit.
    eval (ssh-agent -c) > /dev/null

    # Indicate a configured fish shell in the GUI environment
    set -q COSMIC_FISH_CONFIGURED
    and set COSMIC_FISH_CONFIGURED configured

end
