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

# If installed, use pyenv to manage Python environments
if digpath -q -x pyenv
    pyenv init - | source

    # Set ve managed Python virtual environment
    if set -q VE_VENV
        ve (basename $VE_VENV)
    else
        set -e PYTHONPATH
        ve grs
    end
end

# Set JDK_version managed Java environment
if set -q JDK_VERSION
    jdk_version $JDK_VERSION >/dev/null # so scp does not gag
else
    jdk_version 21 >/dev/null
end
