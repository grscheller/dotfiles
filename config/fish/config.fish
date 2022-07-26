## Fish configurstion for my workstations

## Using universal variables to configure fish itself
set -U fish_features all
set -U fish_key_bindings fish_vi_key_bindings

## PATH variable management
set -q VIRGINPATH
or begin
    set -gx VIRGINPATH $PATH
    set -x UPDATE_ENV
end

set -q REDO_ENV
and begin
    set -x UPDATE_ENV
    set PATH $VIRGINPATH
end

set -q UPDATE_ENV
and begin
    ## Setup initial environment variables
    set -e UPDATE_ENV
    set -e REDO_ENV
    
    # Use Neovim as the pager
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx PAGER 'nvim -R'
    set -gx MANPAGER 'nvim +Man!'
    set -gx DIFFPROG 'nvim -d'

    # Configure Sway/Wayland for Arch Linux
    if string match -qr 'arch' (uname -r)
        # For a functional tray in Waybar
        set -gx XDG_CURRENT_DESKTOP sway
        set -gx XDG_SESSION_DESKTOP sway
        # Tell Firefox to use Wayland if available
        set -gx MOZ_ENABLE_WAYLAND 1
        # Get QT clients to play nice with Wayland
        set -gx QT_QPA_PLATFORM wayland
        # Use /usr/bin/qt5ct utility to adjust QT
        set -gx QT_QPA_PLATFORMTHEME qt6ct
        # Set Dark Mode for GTK apps
        set -gx GTK_THEME 'Adwaita:dark'
    end

    # Ruby tool chain
    #   Mostly for locally installed ruby gems,
    #     to install these:
    #       Markdown linter: $ gem install mdl
    #       Neovim syntax:   $ gem install neovim
    set -p PATH /usr/local/lib/ruby/gems/*/bin
    set -p PATH /usr/local/opt/ruby/bin
    set -p PATH ~/.local/share/gem/ruby/*/bin

    # Rust toolchain
    set -p PATH ~/.cargo/bin

    # Haskell location used by Cabal and Stack
    set -p PATH ~/.cabal/bin ~/.local/bin 

    # Utilities I want to overide most things, I put sbt here
    set -p PATH ~/opt/bin
    # Personal utilities available if not found elsewhere
    set -a PATH ~/bin
    # Added some relative paths, useful for some software projects
    set -a PATH bin ../bin .

    # Python configuration
    set -gx PIP_REQUIRE_VIRTUALENV true
    set -gx PYENV_ROOT ~/.pyenv
    set -p PATH $PYENV_ROOT/shims
    set -gx PYTHONPATH lib ../lib  # Not sure best way to handle this

    # Configure Java for Arch Linux (Sway/Wayland)
    if string match -qr 'arch' (uname -r)
        archJDK 17
        set -gx _JAVA_AWT_WM_NONREPARENTING 1
    end

    # Clean up duplicate and non-existing paths
    set PATH (pathtrim)

    # Let Bash Shells know initial environment configured
    set -q _ENV_INITIALIZED
    or set -gx _ENV_INITIALIZED 0
    set -x _ENV_INITIALIZED (math "$_ENV_INITIALIZED+1")

    ## For non-Systemd systems
    if not digpath -q hostnamectl
        set -gx make_phoney_hostnamectl
    end
end

if set -q make_phoney_hostnamectl
    function hostnamectl
        hostname
    end
end

## Python Pyenv function configuration
test -d $PYENV_ROOT; and pyenv init - | source

## Enable vi keybindings
fish_vi_key_bindings

# Use cursor shape to indicate mode
set -g fish_cursor_default block
set -g fish_cursor_insert line
set -g fish_cursor_replace_one underscore
set -g fish_cursor_visual underscore blink

## Functions better managed not as separate files

# Convert between various bases (use capital A-F for hex-digits)
function h2h; printf 'ibase=16\nobase=10\n%s\n'   "$argv" | /usr/bin/bc; end
function h2d; printf 'ibase=16\nobase=A\n%s\n'    "$argv" | /usr/bin/bc; end
function h2o; printf 'ibase=16\nobase=8\n%s\n'    "$argv" | /usr/bin/bc; end
function h2b; printf 'ibase=16\nobase=2\n%s\n'    "$argv" | /usr/bin/bc; end
function d2h; printf 'ibase=10\nobase=16\n%s\n'   "$argv" | /usr/bin/bc; end
function d2d; printf 'ibase=10\nobase=10\n%s\n'   "$argv" | /usr/bin/bc; end
function d2o; printf 'ibase=10\nobase=8\n%s\n'    "$argv" | /usr/bin/bc; end
function d2b; printf 'ibase=10\nobase=2\n%s\n'    "$argv" | /usr/bin/bc; end
function o2h; printf 'ibase=8\nobase=20\n%s\n'    "$argv" | /usr/bin/bc; end
function o2d; printf 'ibase=8\nobase=12\n%s\n'    "$argv" | /usr/bin/bc; end
function o2o; printf 'ibase=8\nobase=10\n%s\n'    "$argv" | /usr/bin/bc; end
function o2b; printf 'ibase=8\nobase=2\n%s\n'     "$argv" | /usr/bin/bc; end
function b2h; printf 'ibase=2\nobase=10000\n%s\n' "$argv" | /usr/bin/bc; end
function b2d; printf 'ibase=2\nobase=1010\n%s\n'  "$argv" | /usr/bin/bc; end
function b2o; printf 'ibase=2\nobase=1000\n%s\n'  "$argv" | /usr/bin/bc; end
function b2b; printf 'ibase=2\nobase=10\n%s\n'    "$argv" | /usr/bin/bc; end
