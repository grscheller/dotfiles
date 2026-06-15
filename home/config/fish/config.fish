## Final fish configuration tweaks.
#
# Factoid: This file is NOT the initial starting point for
#          fish configuration. The files in conf.d get
#          sourced BEFORE config.fish in alphabetical order.
#
# Note: The file ~/.config/fish/conf.d/00-initial-environment.fish
#       plays the role that ~/.profile does in a POSIX compliant shell.
#

if status is-interactive

    # Enable vi keybindings and cursor shape
    fish_vi_key_bindings
    set -g fish_cursor_default block
    set -g fish_cursor_insert line
    set -g fish_cursor_replace_one underscore
    set -g fish_cursor_visual underscore blink

    # If installed, use pyenv to manage Python environments
    if digpath -q -x pyenv
        pyenv init - | source

        # Set ve managed Python virtual environment
        if set -q VE_VENV
            ve (basename $VE_VENV) >/dev/null 2>&1
        else
            set -e PYTHONPATH
            ve grs >/dev/null 2>&1
        end
    end

    # Set JDK_version managed Java environment
    if set -q JDK_VERSION
        jdk_version $JDK_VERSION
    else
        jdk_version 21
    end

end
