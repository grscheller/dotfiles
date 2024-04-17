## Ensure a sane initial environment is set up, if not already done so.
#
# Warning: non-idiomatic use of fish universals!
#
# All permanent configurations should flow from
# configuration files, not done on the command line!!!
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

   ## Configure fish itself, IMHO one of the few legitimate uses for Universals
   set -U fish_features all

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

   # Set up paths to dotfiles related repos
   set -gx DOTFILES_GIT_REPO ~/devel/dotfiles

   # Add ~/bin to end of PATH
   fish_add_path -gpP ~/bin

   # Rust toolchain
   fish_add_path -gpP ~/.cargo/bin

   # Haskell location used by Stack and Cabal
   fish_add_path -gpP ~/.local/bin  ~/.cabal/bin

   # Nix - thru symbolic link to current Nix environment, defer to pacman
   set PATH $PATH ~/.nix-profile/bin

   # Configure JDK on arch with fish function
   if string match -qr 'arch' (uname -r)
      archJDK 17
   end

   # Python configuration
   set -gx PIP_REQUIRE_VIRTUALENV true
   set -gx VE_VENV_DIR ~/devel/python_venvs
   test -d $VE_VENV_DIR || mkdir -p $PYTHON_VE_VENVS
   set -gx PYENV_ROOT ~/.local/share/pyenv

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
