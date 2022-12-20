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

## Flag to setup an initial environment if not done so yet
set -q FISHVIRGINPATH
or begin
    if set -q BASHVIRGINPATH
        set -gx FISHVIRGINPATH $BASHVIRGINPATH
    else
        set -gx FISHVIRGINPATH $PATH
        set -g UPDATE_ENV
    end
end

set -q REDO_ENV
and begin
    set -g UPDATE_ENV
    set PATH $FISHVIRGINPATH
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
    set -gx VISUAL $EDITOR
    set -gx SUDO_EDITOR $EDITOR
    set -gx PAGER 'nvim -R'
    set -gx MANPAGER 'nvim +Man!'
    set -gx DIFFPROG 'nvim -d'

    # Added ~/bin and relative paths at end of PATH
    fish_add_path -gP ~/bin bin ../bin .

    # RubyGems
    #   Neovim syntax:      $ gem install neovim
    #   Markdown linter:    $ gem install mdl
    #   Markdown converter: $ gem install kramdown
    set -l gemDirs ~/.local/share/gem/ruby/*/bin
    set -l cnt (count $gemDirs)
    set -l idx
    switch $cnt
      case '0'
      case '1'
        fish_add_path -gpP $gemDirs
      case '*'
        fish_add_path -gpP $gemDirs[1]
        printf '\n[fish.config] Warning: Multiple Ruby Gem directories found'
        for idx in (seq 1 $cnt)
            printf '\n  %s' $gemDirs[$idx]
            test $idx -eq 1; and printf '  <- using this one'
            test $idx -eq $cnt; and printf '\n'
        end
    end
    set -e gemDirs cnt idx

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
        # Tell Firefox to use Wayland if available
        set -gx MOZ_ENABLE_WAYLAND 1
        # Get QT clients to play nice with Wayland
        set -gx QT_QPA_PLATFORM wayland
        # Use /usr/bin/qt6ct utility to adjust QT
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

# Have git asks for passwords on the command line
set -e SSH_ASKPASS
