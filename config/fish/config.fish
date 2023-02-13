## Final fish configuration tweaks.
#
# Note that config.fish is not the entry point for fish
# configuration.  The files in conf.d get sourced BEFORE
# config.fish in alphabetical order.
#

# opam OCaml configuration
test -f ~/.opam/opam-init/init.fish
and source ~/.opam/opam-init/init.fish >/dev/null 2>&1

# Python pyenv function and environment configuration
digpath -q pyenv
and begin
   pyenv init - | source
end

# Ensure SSH key-agent running with your private keys
if ! set -q SSH_AGENT_PID
   printf 'SSH '
   eval (ssh-agent -c)
   and ssh-add
end
