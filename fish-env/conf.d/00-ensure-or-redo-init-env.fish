## Ensure a sane initial environment is set up, if not already done so.
#
# Warning: non-idiomatic use of fish universals!
#
# All permanent configurations should flow from
# configuration files, not done on the command line or random GUI!!!
#
# If REDO_ENV is set, all "manual" configurations will be blown away!
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
   if set -q BASHVIRGINPATH
      set -gx FISHVIRGINPATH $BASHVIRGINPATH
   else
      set -gx FISHVIRGINPATH $PATH
   end
   set -g UPDATE_ENV
end

set -q REDO_ENV
and begin
   set -g UPDATE_ENV
   set PATH $FISHVIRGINPATH
   if set -q XDG_CONFIG_HOME
      printf > $XDG_CONFIG_HOME/fish/fish_variables
   else
      printf > ~/.config/fish/fish_variables
   end
end

set -q UPDATE_ENV
and begin
   set -e UPDATE_ENV
   set -e REDO_ENV

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

   # Rust toolchain
   digpath -x -q rustc
   and set -p PATH ~/.cargo/bin

   # Haskell locations used by Stack and Cabal
   set PATH ~/.local/bin ~/.cabal/bin $PATH

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

   # Configure initial ve venv to launch
   set -gx VE_VENV
   ve grs
end
