## Final fish configuration tweaks.
#
# Note that config.fish is not the entry point for fish
# configuration.  The files in conf.d get sourced BEFORE
# config.fish in alphabetical order.
#

# So that scp will work for receiving files
if not status --is-interactive
   return
end

# If pyenv is installed, use it to manage Python environments
type -P pyenv >/dev/null 2>&1
and begin
   set -gx PYENV_ROOT ~/.local/share/pyenv
   pyenv init - | source
end

# Enable vi keybindings
fish_vi_key_bindings

# Ensure SSH key-agent running with your private keys
if ! set -q SSH_AGENT_PID
   printf 'SSH '
   eval (ssh-agent -c)
   and ssh-add
end

# Check if shell is running in a desktop environment
if set -q XDG_CURRENT_DESKTOP
   # Activate grs Python virtual environment - /usr/bin python scripts will
   # still use the system Python.environment.
   ve grs
end
