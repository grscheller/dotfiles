## Fish configurstion for my workstations

## Setup initial environment if it has not been done so yet
set -q VIRGINPATH
or begin
    set -gx VIRGINPATH $PATH
    set -g UPDATE_ENV
end

set -q REDO_ENV
and begin
    set -g UPDATE_ENV
    set PATH $VIRGINPATH
end

set -q UPDATE_ENV
and begin
    set -e UPDATE_ENV
    set -e REDO_ENV

    ## Configure fish itself
    set -U fish_features all

    # Enable vi keybindings
    fish_vi_key_bindings

    # Use cursor shape to indicate vi-mode
    set -gx fish_cursor_default block
    set -gx fish_cursor_insert line
    set -gx fish_cursor_replace_one underscore
    set -gx fish_cursor_visual underscore blink

    # Set up paging
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx PAGER less
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

    # Added ~/bin and relative paths at end of PATH
    set -a PATH ~/bin bin ../bin .

    # RubyGems
    #   Neovim syntax:      $ gem install neovim
    #   Markdown linter:    $ gem install mdl
    #   Markdown converter: $ gem install kramdown
    fish_add_path -gpP ~/.local/share/gem/ruby/*/bin

    # Rust toolchain
    fish_add_path -gpP ~/.cargo/bin

    # Haskell location used by Cabal and Stack
    fish_add_path -gpP ~/.local/bin  ~/.cabal/bin

    # Python configuration (see also below at end)
    set -gx PIP_REQUIRE_VIRTUALENV true
    set -gx PYENV_ROOT ~/.pyenv
    fish_add_path -gpP $PYENV_ROOT/shims
    set -gx PYTHONPATH lib ../lib  # Very old method, frowned upon?

    # Configure Java for Arch Linux (Sway/Wayland)
    if string match -qr 'arch' (uname -r)
        set -gx _JAVA_AWT_WM_NONREPARENTING 1
        archJDK 17
    end

    # Let Bash Shells know initial environment configured
    set -q _ENV_INITIALIZED
    or set -gx _ENV_INITIALIZED 0
    set -x _ENV_INITIALIZED (math "$_ENV_INITIALIZED+1")

    # For non-Systemd systems
    if not digpath -q hostnamectl
        set -gx make_phoney_hostnamectl
    end
end

## Functions better managed not as separate files

# For non-Systemd systems
if set -q make_phoney_hostnamectl
    function hostnamectl
        hostname
    end
end

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

## Python Pyenv function configuration
test -d $PYENV_ROOT; and pyenv init - | source
