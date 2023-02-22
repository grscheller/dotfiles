## Ensure a sane initial environment is set up, if not already done so.
#
# Warning: non-idiomatic use of fish universals!
#
# All permanent configurations should flow from
# configuration files, not done on the command line!
# 
# If REDO_ENV is set, all "manual" configurations will be blown away!
# This way, I know configuration is sane and not affected by old cruft.
#
# The mechanism below was originally in config.fish.
#
# Unfortunately, config.fish is not the entry point
# for fish configuration.  The files in conf.d get
# sourced BEFORE config.fish in alphabetical order.
#

# Sentinel value indicating whether an initial shell environment was setup.
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
   if set -q XDG_CONFIG_HOME
      printf > $XDG_CONFIG_HOME/fish/fish_variables
   else
      printf > ~/.config/fish/fish_variables
   end
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

   # Set up path to dotfiles repo
   set -gx DOTFILE_GIT_REPO ~/devel/dotfiles

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

   # Configure JDK on arch with fish function
   if string match -qr 'arch' (uname -r)
      archJDK 17
   end

   # Python configuration
   set -gx PIP_REQUIRE_VIRTUALENV true
   set -gx PYENV_ROOT ~/.local/share/pyenv
   set -gx PYTHONPATH lib ../lib

   # For non-Systemd systems
   if not type -q hostnamectl
      set -gx make_phoney_hostnamectl
   end
end

# For non-Systemd systems
if set -q make_phoney_hostnamectl
   function hostnamectl
      hostname
   end
end