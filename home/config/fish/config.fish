## Final fish configuration tweaks.
#
# Note: This file is NOT the initial starting point for
#       fish configuration. The files in conf.d get sourced
#       BEFORE config.fish in alphabetical order.
#
# Note: The file ~/.config/fish/conf.d/00-initial-environment.fish
#       plays the role that ~/.profile does in a POSIX compliant shell.
#

# So that scp will work for receiving files
if not status is-interactive
    return
end

# Manage SSH key-agents - desktop environment shares one
function exit_handler --on-event fish_exit
    if status is-login
        if set -q SSH_AGENT_PID
            set -l tmpfile /tmp/grs_ssh_desktop_env
            if test -f $tmpfile
                set -l script 's/^.* //;s/;$//;2p'
                test (sed -n -e "$script" $tmpfile) -eq $SSH_AGENT_PID
                and rm -f $tmpfile
            end
            kill -15 $SSH_AGENT_PID
        end
    end
end

if ! set -q SSH_AGENT_PID
    set -l ssh_agent_flag 1
    set -l desktop_flag 0
    if set -q XDG_CURRENT_DESKTOP
        set desktop_flag 1
        if test -f /tmp/grs_ssh_desktop_env
            printf 'Reusing desktop SSH '
            source /tmp/grs_ssh_desktop_env
            if ps -p $SSH_AGENT_PID >/dev/null
                set ssh_agent_flag 0
            end
        end
    end
    if test "$ssh_agent_flag" -eq 1
        set -l umask_orig (umask)
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

# Set ve managed Python virtual environment
if set -q VE_VENV
    ve (basename $VE_VENV)
else
    set -e PYTHONPATH
    ve grs
end

# Set JDK_version managed Java environment
if set -q JDK_VERSION
    jdk_version $JDK_VERSION >/dev/null # so scp does not gag
else
    jdk_version 21 >/dev/null
end
