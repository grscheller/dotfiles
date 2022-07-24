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
set -g fish_cursor_default block
set -g fish_cursor_insert line
set -g fish_cursor_replace_one underscore
set -g fish_cursor_visual underscore blink

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

## Setup Tokyo Night based colors for fish to use

# TokyoNight based colors consistent with my alacritty configuration
set -l foreground c0caf5  #c0caf5  bright white
set -l selection 33467c   #33467c
set -l comment 565f89     #565f89
set -l red f7768e         #f7768e  red
set -l orange ff9e64      #ff9e64  index color 16
set -l yellow e0af68      #e0af68  yellow
set -l green 9ece6a       #9ece6a  green
set -l purple 9d7cd8      #9d7cd8  dimmed "magenta" 
set -l azure 7dcfff       #7dcfff  bright "cyan"
set -l pink bb9af7        #bb9af7  "magenta" - not pink nor magenta
set -l cyan 0cb4c0        #0cb4c0  cyan

# Syntax highlighting colors
set -g fish_color_autosuggestion $comment
set -g fish_color_cancel -r
set -g fish_color_cwd $green
set -g fish_color_cwd_root $red
set -g fish_color_command $azure
set -g fish_color_comment $comment
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_escape $pink
set -g fish_color_history_current --bold
set -g fish_color_host $pink
set -g fish_color_host_remote $yellow
set -g fish_color_keyword $pink
set -g fish_color_normal $foreground
set -g fish_color_operator $green
set -g fish_color_param $purple
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_search_match --background=$selection
set -g fish_color_selection --background=$selection
set -g fish_color_status $orange
set -g fish_color_user $cyan
set -g fish_color_valid_path --underline

# Completion pager colors
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
set -g fish_pager_color_prefix $azure
set -g fish_pager_color_progress $comment
set -g fish_pager_color_selected_background -r
