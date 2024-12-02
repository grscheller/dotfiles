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

# Enable vi keybindings
fish_vi_key_bindings

# Manage SSH key-agents - desktop environment shares one
function exit_handler --on-event fish_exit
   if status --is-login
       if set -q SSH_AGENT_PID
          kill -15 $SSH_AGENT_PID
       end
   end
end

if ! set -q SSH_AGENT_PID
   set -l ssh_flag 1
   set -l desktop_flag 0
   if set -q XDG_CURRENT_DESKTOP
      set desktop_flag 1
      if test -f /tmp/grs_ssh_desktop_env
         printf 'Last Desktop SSH '
         source /tmp/grs_ssh_desktop_env
         if ps -p $SSH_AGENT_PID > /dev/null
            set ssh_flag 0
         end
      end
   end
   if test "$ssh_flag" -eq 1
      set -l umask_orig $umask
      umask 0077
      printf 'SSH '
      if test "$desktop_flag" -eq 1
         eval (ssh-agent -c|tee /tmp/grs_ssh_desktop_env)
         and ssh-add
      else
         eval (ssh-agent -c)
         and ssh-add
      end
      umask $umask_orig
   end
end

# If installed, use pyenv to manage Python environments
if digpath -q -x pyenv
   pyenv init - | source
end
