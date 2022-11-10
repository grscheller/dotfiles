## Fish configurstion for my workstations
#
#  Warning: non-idiomatic use of Universals
#
#    Found no good way to bulletproof automatically
#    regenerating ~/.config/fish/fish_variables, especially
#    when there are lots of fish configuration changes.
#
#    Usually just using the "re" abbreviation is enough,
#    but sometimes also blowing away the fish_variables
#    file and restarting fish is needed.
#
#    Probably just fighting against someone else's
#    beloved configuration paradigm.

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
    # Let Bash know initial environment already configured
    set -q _ENV_INITIALIZED
    or set -gx _ENV_INITIALIZED 0
    set -x _ENV_INITIALIZED (math "$_ENV_INITIALIZED+1")

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

    # Added ~/bin and relative paths at end of PATH
    fish_add_path -gP ~/bin bin ../bin .

    # RubyGems
    #   Neovim syntax:      $ gem install neovim
    #   Markdown linter:    $ gem install mdl
    #   Markdown converter: $ gem install kramdown
    set -l RubyDir ~/.local/share/gem/ruby/*/bin
    set -l cnt (count $RubyDir)
    set -l idx
    switch $cnt
        case '0'
        case '1'
            fish_add_path -gpP $RubyDir
        case '*'
            fish_add_path -gpP $RubyDir[1]
            printf '\n[fish.config] Warning: Multiple Ruby directories found'
            for idx in (seq 1 $cnt)
                printf '\n  %s' $RubyDir[$idx]
                test $idx -eq 1; and printf '  <- this one used'
                test $idx -eq $cnt; and printf '\n'
            end
    end
    set -e RubyDirs cnt idx

    # Rust toolchain
    fish_add_path -gpP ~/.cargo/bin

    # Haskell location used by Stack and Cabal
    fish_add_path -gpP ~/.local/bin  ~/.cabal/bin

    # Configure Java for Arch Linux (Sway/Wayland)
    if string match -qr 'arch' (uname -r)
        set -gx _JAVA_AWT_WM_NONREPARENTING 1
        archJDK 17
    end

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

    # For non-Systemd systems
    if not digpath -q hostnamectl
        set -gx make_phoney_hostnamectl
    end

    # Python configuration (see also below at end)
    set -gx PIP_REQUIRE_VIRTUALENV true
    set -gx PYENV_ROOT ~/.local/share/pyenv
    set -gx PYTHONPATH lib ../lib
    digpath -q pyenv; and set -gx has_pyenv_installed
end

# Python pyenv function and environment configuration
set -q has_pyenv_installed; and begin
    pyenv init - | source
end

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
