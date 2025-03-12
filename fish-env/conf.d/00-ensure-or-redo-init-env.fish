## Ensure a sane initial environment is set up, if not already done so.
#
# Warning: non-idiomatic use of fish universals!
#
# All permanent configurations should flow from
# configuration files, not done on the command line or random GUI!!!
#
# If Redo_Fish_Environment is set, all "manual" configurations will be blown away!
# This way, I know configuration is sane and not affected by old cruft.
#
# The mechanism below was originally in config.fish.
#
# Unfortunately, config.fish is not the entry point
# for fish configuration. The files in conf.d get
# sourced BEFORE config.fish in alphabetical order.
#

# Sentinel value indicating whether an initial shell environment was setup
set -q FISHVIRGINPATH
or begin
      set -gx FISHVIRGINPATH $PATH
      set -g Update_Fish_Environment
   end

set -q Redo_Fish_Environment
and begin
       set -e Redo_Fish_Environment
       set -g Update_Fish_Environment
       set PATH $FISHVIRGINPATH
       if set -q XDG_CONFIG_HOME
          printf > $XDG_CONFIG_HOME/fish/fish_variables
       else
          printf > ~/.config/fish/fish_variables
       end
    end

set -q Update_Fish_Environment
and begin
       set -e Update_Fish_Environment

       ## First configure fish itself
       set -U fish_features all
       set -U fish_cursor_default block
       set -U fish_cursor_insert line
       set -U fish_cursor_replace_one underscore
       set -U fish_cursor_visual underscore blink

       # Set locale
       set -gx LANG en_US.utf8

       # Set up paging
       set -gx EDITOR nvim
       set -gx VISUAL nvim
       set -gx SUDO_EDITOR /usr/bin/nvim
       set -gx PAGER 'nvim -R'
       set -gx MANPAGER 'nvim +Man!'
       set -gx DIFFPROG 'nvim -d'

       # Set up paths to dotfiles related repos
       set -gx DOTFILES_GIT_REPO ~/devel/dotfiles

       # Zig toolchain
       test -L ~/devel/zig_nightly/current
       and set -p PATH ~/devel/zig_nightly/current

       # Rust toolchain
       test -e ~/.cargo/env.fish
       and set -p PATH ~/.cargo/bin

       # Haskell locations used by Stack and Cabal
       set PATH ~/.local/bin ~/.cabal/bin $PATH

       # Node.js toolchain
       test -d ~/devel/node_lts/node-v22.14.0-linux-x64/bin
       and set -p PATH ~/devel/node_lts/node-v22.14.0-linux-x64/bin

       # Configure JDK & Scala3 on Pop!OS
       set -a PATH ~/.local/share/coursier/bin
       jdk_version 21

       # Python configuration
       set -gx PIP_REQUIRE_VIRTUALENV true
       set -gx VE_VENV_DIR ~/devel/venvs
       set -gx PYENV_ROOT ~/.local/share/pyenv
       set -a PATH $PYENV_ROOT/bin

       # Add ~/bin at end of PATH
       set PATH $PATH ~/bin

       # Cleanup PATH: remove duplicate & nonexistent entries, resolve symlinks
       set PATH (pathtrim)
    end

