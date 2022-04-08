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

    # Configure Sway/Wayland for Arch Linux
    if string match -qr 'arch' (uname -r)
        # For a functional tray in Waybar, lie
        set -gx XDG_CURRENT_DESKTOP Unity
        # Tell Firefox to use Wayland if available
        set -gx MOZ_ENABLE_WAYLAND 1
        # Get QT clients to play nice with Wayland
        set -gx QT_QPA_PLATFORM wayland
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

    # Tools on iMac installed with SDKMAN
    set -p PATH ~/.sdkman/candidates/java/current/bin
    set -p PATH ~/.sdkman/candidates/sbt/current/bin
    set -p PATH ~/.sdkman/candidates/maven/current/bin
    set -p PATH ~/.sdkman/candidates/gradle/current/bin
    set -p PATH ~/.sdkman/candidates/groovy/current/bin
    set -p PATH ~/.sdkman/candidates/leiningen/current/bin
    set -p PATH ~/.sdkman/candidates/kotlin/current/bin

    # On iMac, node 16 is "keg only"
    #   For compilers to find node@16 you may need to set:
    #   set -gx LDFLAGS "-L/usr/local/opt/node@16/lib"
    #   set -gx CPPFLAGS "-I/usr/local/opt/node@16/include"
    set -p PATH /usr/local/opt/node@16/bin

    # On iMac, put brew clang before system clang - for clangd language server
    set -p PATH /usr/local/opt/llvm/bin

    # Utilities I want to overide most things
    set -p PATH ~/.local/bin ~/opt/bin
    # Personal utilities available if not found elsewhere
    set -a PATH ~/bin
    # Added some relative paths, useful for some software projects
    set -a PATH bin ../bin .

    # Python configuration
    set -gx PIP_REQUIRE_VIRTUALENV true
    set -gx PYENV_ROOT ~/.pyenv
    set -p PATH $PYENV_ROOT/shims
    set -gx PYTHONPATH lib ../lib

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

# Kick wifi networking
abbr -a -g kw 'swap_resolv_conf;iwctl device list;sleep 1;iwctl device list;getent hosts fast.net;swap_resolv_conf;getent hosts github.com'
