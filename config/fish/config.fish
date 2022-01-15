## Make sure $fish_features is set in universal scope
if [ -z "$fish_features" ]
    set -U fish_features stderr-nocaret qmark-noglob regex-easyesc
    set_color red
    printf '\nWarning: fish_features were not universally set,'
    printf '\n         restart fish for them to take effect.\n\n'
    set_color normal
end

## Setup environment variables
set -x EDITOR nvim
set -x VISUAL nvim
set -x PAGER 'nvim -R'
set -x MANPAGER 'nvim +Man!'

# Tell Firefox to use Wayland if available
set -x MOZ_ENABLE_WAYLAND 1
# Get QT clients to play nice with Wayland
set -x QT_QPA_PLATFORM wayland
# Set Dark Mode for GTK apps
set -x GTK_THEME 'Adwaita:dark'

## PATH variable management
set -q VIRGINPATH
or begin
    set -x VIRGINPATH $PATH
    set -x UPDATE_ENV
end

set -q REDO_ENV
and begin
    set -x PATH $VIRGINPATH
    set -x UPDATE_ENV
end

set -q UPDATE_ENV
and begin
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

    # Utilities I want to overide everything
    set -p PATH ~/.local/bin ~/opt/bin
    # Personal utilities available if not found elsewhere
    set -a PATH ~/bin
    # Added some relative paths, useful for some software projects
    set -a PATH bin ../bin .

    # Python configuration
    set -x PIP_REQUIRE_VIRTUALENV true

    # Configure Java for Arch Linux (Sway/Wayland)
    if string match -qr 'arch' (uname -r)
        archJDK 17
        set -x _JAVA_AWT_WM_NONREPARENTING 1
    end

    # Clean up duplicate and non-existing paths
    set PATH (pathtrim)

    # Let POSIX Shells know initial environment configured
    set -q _ENV_INITIALIZED
    or set -x _ENV_INITIALIZED 0
    set -x _ENV_INITIALIZED (math "$_ENV_INITIALIZED+1")

    set -e UPDATE_ENV
    set -e REDO_ENV
end

## Enable vi keybindings
fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual underscore blink

## Set up abriviations
abbr -a -g nv nvim
abbr -a -g dp digpath
abbr -a -g tm fishterm
abbr -a -g ue UPDATE_ENV=yes fish
abbr -a -g -- re REDO_ENV=yes fish -l -C cd
abbr -a -g kn sudo systemctl restart systemd-networkd.service
abbr -a -g kw 'iwctl device list;iwctl device list'
abbr -a -g sp 'string split "\n" $PATH'

## Let the various POSIX shells know their configuration files
if test -r ~/.shrc
    abbr -a -g sh ENV=~/.shrc sh
end

if test -r ~/.dashrc
    abbr -a -g dash ENV=~/.dashrc dash
else if test -r ~/.shrc
    abbr -a -g dash ENV=~/.shrc dash
end
