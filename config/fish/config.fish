## Fish configuration for my Arch Linux/Sway DE systems

## Make sure $fish_features is set in universal scope
if [ -z "$fish_features" ]
    set -U fish_features stderr-nocaret qmark-noglob regex-easyesc
    set_color red
    printf '\nWarning: fish_features were not universally set,'
    printf '\n         restart fish for them to take effect.\n\n'
    set_color normal
end

## PATH variable management
set -q VIRGINPATH
or begin
    set -gx VIRGINPATH $PATH
    set -x UPDATE_ENV
end

set -q REDO_ENV
and begin
    set -x PATH $VIRGINPATH
    set -x UPDATE_ENV
end

set -q UPDATE_ENV
and begin
    ## Setup initial environment variables
    
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
        set -gx QT_QPA_PLATFORMTHEME qt5ct
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
        set -x _JAVA_AWT_WM_NONREPARENTING 1
    end

    # Clean up duplicate and non-existing paths
    set PATH (pathtrim)

    # Let Bash Shell know initial environment configured
    set -q _ENV_INITIALIZED
    or set -gx _ENV_INITIALIZED 0
    set -x _ENV_INITIALIZED (math "$_ENV_INITIALIZED+1")

    set -e UPDATE_ENV
    set -e REDO_ENV
end

## For non-Systemd systems - provide a phony hostnamectl command
function hostnamectl
    hostname
end

if digpath -q hostnamectl
    functions --erase hostnamectl
end

## Python Pyenv function configuration
test -d $PYENV_ROOT; and pyenv init - | source

## Enable vi keybindings
fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual underscore blink

## Set up abriviations

# Gui programs
abbr -a -g tm fishterm
abbr -a -g gq 'geeqie &; disown'

# Shell terminal cmds
abbr -a -g dp digpath
abbr -a -g nv nvim
abbr -a -g path 'string join \n $PATH'
abbr -a -g -- pst ps -ejH

# Git related cmds - anything more complicated, I want to think about
abbr -a -g ga git add .
abbr -a -g gc git commit
abbr -a -g gd git diff
abbr -a -g gf git fetch
abbr -a -g gl git log
abbr -a -g gm git mv
abbr -a -g gp git pull
abbr -a -g gh git push
abbr -a -g gs git status  # gs steps on ghostscript
# Shell environment cmds
abbr -a -g -- re REDO_ENV=yes fish -l -C cd
abbr -a -g ue UPDATE_ENV=yes fish
