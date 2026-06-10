## Ensure a sane initial environment is set up for login shells.
#
# Note: This file plays the same role as does the
#       file ~/.profile in a POSIX compliant shell.
#
# Important: SCP connections invoke login shells and will gag
#            on extraneous output. Therefore for SCP to work
#            correctly, this file should not produce anything
#            to stdout.
#
# Factoid: COSMIC DE startup chain will invoke the user's
#          shell as a login shell at some point. That shell
#          lives until the user logs out.
#

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

    ## Finally, manage a single SSH key-agent for the login session.

    # Cleanup SSH key-agent at end of login session.
    function exit_handler --on-event fish_exit
        if status --is-login
            set -q SSH_AGENT_PID
            and kill -15 $SSH_AGENT_PID >/dev/null 2>&1
            set -q SSH_AUTH_SOCK
            and rm -rf (path dirname $SSH_AUTH_SOCK)
        end
    end

    # Launch SSH key-agent
    set -l umask_original $umask
    umask 0077
    eval (ssh-agent -c)
    and ssh-add
    umask $umask_original

end
