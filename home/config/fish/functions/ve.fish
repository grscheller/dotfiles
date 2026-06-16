# This function manages a group of Python virtual environments (venv).
#
# I manage my installed versions on Python with pyenv, so I have to be mindful
# of the possibility of pyenv shims being in use. I did not want this function
# to depend on pyenv commands in case I am in a situation where pyenv is not
# available, If pyenv shell function is defined, this script will use it to
# provide additional user feedback.
#
# The global environment variable $VE_VENV_DIR controls which group of venv's
# I am managing together. All the venv's "should" be installed in the directory
# it points to, Other non-managed venv can be located there. Also, a ve.conf
# configuration file must be stored there too.
#
# I maintain one version of ve.conf in my dotfiles GIT repo and $VE_VENV_DIR
# is set from my fish configs.
#
function ve --description 'Manage a group of Python virtual environments'

    ## Initial setup

    # Provide an environment override mechanism to virtual environment location
    if not set -q VE_VENV_DIR
        set -g -x VE_VENV_DIR ~/devel/venvs/
    end
    mkdir -p "$VE_VENV_DIR"

    set -f ve_conf "$VE_VENV_DIR/ve.conf"

    if not test -f "$ve_conf"
        printf '\nError: Virtual environmnent configuration file: %s, not found.\n\n' $ve_conf >&2
        return 1
    end

    ## Globals variables - fish scoping does NOT follow the call stack!!!
    #
    #  Functions passed shell variable names need these to be global.
    #
    set -g _venv # setup by _is_managed_venv
    set -g _version_required # setup by _is_managed_venv
    set -g _version_on_path # setup by _is_python_correct_version
    set -g _venvs # set up from configuration file
    set -g _versions # set up from configuration file
    set -g _modules # set up from configuration file

    ## Source in configuration file and set up venv schema

    # Source in venv configurations
    source $ve_conf
    set _venvs $conf_virtual_envs
    set -e conf_virtual_envs

    for ii in (seq (count $_venvs))
        eval set _versions[$ii] \$conf_$_venvs[$ii][1]
    end

    for ii in (seq (count $_venvs))
        eval set _modules[$ii] \"(string join ' ' \$conf_$_venvs[$ii][2..-1])\"
    end

    ## Utility functions

    # Call before _is_python_correct_version
    function _is_managed_venv
        set -l venv_name $argv[1]
        if contains $venv_name $_venvs
            set -l index (contains -i $venv_name $_venvs)
            set _venv $_venvs[$index]
            set _version_required $_versions[$index]
            return 0
        else
            return 1
        end
    end

    function _print_python_version
        set -l python $argv[1]
        set -l py_version (string split -f 2 ' ' ($python --version))
        set py_version $py_version[1] # some builds print additional version info
        printf '%s\n' $py_version
    end

    function _is_python_correct_version
        if type -f -q python
            set -f python_on_path (type -p python)
        else
            printf 'not on path\n'
            return
        end
        set _version_on_path (_print_python_version $python_on_path)
        if test "$_version_on_path" = "$_version_required"
            printf 'ok\n'
            return
        else
            printf 'wrong version\n'
            return
        end
    end

    function _usage
        set -l msg '
            Usage: ve <venv>
                ve [-c | --clear] | [-r | --redo]
                ve [-l | --list]
                ve [-m | --missing]
                ve [-h | --help]

                where missing: list missing pyenv installed Python versions
                         list: list all ve managed virtual environments
                        clear: remove all installed modules from venv
                         redo: install all managed modules into current venv
                         help: print usage information\n\n'
        set msg (string replace -ra '(?m)^ {1,12}' '' -- $msg | string collect)
        printf $msg
    end

    function _cleanup
        set -e _venv _version_required _version_on_path _venvs _versions _modules
        functions -e _is_managed_venv _print_python_version
        functions -e _is_python_correct_version _usage _cleanup
    end

    ## Get and process cmdline options, or fail gracefully.

    if not argparse -n ve c/clear r/redo l/list m/missing h/help -- $argv
        _usage
        _cleanup
        return 1
    end

    # Show usage then quit, trumps all other options.
    if set -q _flag_help
        _usage
        _cleanup
        return 0
    end

    # Set to 1 if no options were given
    set -f flags no

    set -q _flag_missing
    or set -q _flag_list
    or set -q _flag_clear
    or set -q _flag_redo
    and set flags yes

    # Set to 1 if inconsistent options given
    set -f punt no

    set -f argc (count $argv)
    if test "$argc" -gt 1
        set punt yes
    end

    if test "$argc" -eq 1
        set -q _flag_missing
        or set -q _flag_clear
        or set -q _flag_list
        or set -q _flag_redo
        and set punt yes
    end

    set -q _flag_missing
    and set -q _flag_list
    and set punt yes

    begin
        set -q _flag_clear
        or set -q _flag_redo
    end
    and begin
        set -q _flag_list
        or set -q _flag_missing
    end
    and set -f punt yes

    if test "$punt" = yes
        printf 'Error: Invalid argument/option combination\n' >&2
        _usage
        _cleanup
        return 1
    end

    # Process --list flag. List names of managed venvs and valid venv directories, then quit.
    if set -q _flag_list
        set -l version_info (tab_align2 _venvs _versions)
        set -g _venv_dirs
        set -g _venv_python_versions

        for venv_dir in (ls $VE_VENV_DIR)
            if begin
                    test -x "$VE_VENV_DIR/$venv_dir/bin/python"
                    and test -f "$VE_VENV_DIR/$venv_dir/bin/activate.fish"
                end
                set -a _venv_dirs $venv_dir
                set -a _venv_python_versions (_print_python_version $VE_VENV_DIR/$venv_dir/bin/python)
            end
        end

        set -l installed_venv_info (tab_align2 _venv_dirs _venv_python_versions)

        set -e _venv_dirs
        set -e _venv_python_versions

        set -l virtual_env
        set -l ve_venv

        if set -q VIRTUAL_ENV
            set virtual_env $VIRTUAL_ENV
        else
            set virtual_env NONE
        end

        if set -q VE_VENV
            set ve_venv $VE_VENV
        else
            set ve_venv NONE
        end

        printf '\n'
        set_color $fish_color_user; printf 'VIRTUAL_ENV: '
        set_color $fish_color_host; printf '%s\n' $virtual_env
        set_color $fish_color_user; printf '    VE_VENV: '
        set_color $fish_color_host; printf '%s\n' $ve_venv
        set_color $fish_color_user; printf '\nManaged venv configurations:\n'
        set_color $fish_color_host; printf '%s\n' $version_info
        set_color $fish_color_user; printf '\nVirtual environments (managed or not):\n'
        set_color $fish_color_host; printf '%s\n' $installed_venv_info
        set_color $fish_color_normal; printf '\n'
        _cleanup
        return 0
    end

    ## Process the --missing option to check if all the required pyenv
    ## managed Python versions are installed.

    if set -q _flag_missing
        set -l missing no
        set -l available_pyenv_versions (pyenv versions --bare)
        set -l managed_python_versions (printf '%s\n' $_versions | sort -u)
        for managed_python_version in $managed_python_versions
            if not contains $managed_python_version $available_pyenv_versions
                set missing yes
                set -l cnt 0
                set -l fmt 'Error: Python version %s not available from pyenv for venvs:'
                printf $fmt $managed_python_version
                for managed_version in $_versions
                    set cnt (math $cnt + 1)
                    if test "$managed_version" = "$managed_python_version"
                        printf ' %s' $_venvs[$cnt]
                    end
                end
                printf '\n'
            end
        end

        _cleanup
        if test "$missing" = no
            set -l fmt 'All Python versions are available for all managed virtual environments.\n'
            printf $fmt
            return 0
        else
            return 1
        end
    end

    # If no options were given, deactivate any active venv
    # and give some useful information.
    if test "$flags" = n
        if set -q VIRTUAL_ENV; or type -q deactivate
            printf '\nShutting down active venv: %s\n\n' \"$VIRTUAL_ENV\"
            deactivate
            set -e VE_VENV
        else
            printf '\nNo Python venv in use.'
            set -q VE_VENV
            and printf ' But VE_VENV = %s and VIRTUAL_ENV = %s' "$VE_VENV" "$VIRTUAL_ENV"
            printf '\n\n'
        end

        if type -f -q python
            printf 'Now using python version: %s\n\n' (python --version)
        else
            printf 'No python executable on path!\n\n'
        end

        if type -q pyenv
            pyenv versions
            printf '\n'
        end
    end

    ## Check if user supplied a venv name, if valid activate or create it.

    if test "$argc" -eq 1
        set -l venv_name $argv[1]

        # First check if $venv_name_given is a ve managed environment
        if not _is_managed_venv $venv_name
            printf '\nError: "%s" is not a ve managed venv!\n\n' $venv_name >&2
            _cleanup
            return 1
        end

        # Create managed virtual environment if necessary, punt if python version wrong
        if not test -f "$VE_VENV_DIR/$_venv/bin/activate.fish"
            set -l fmt '
                Info: The "%s" venv does not exist.
                      Creating new venv if using correct Python version.\n'
                set fmt (string replace -ra '(?m)^ {0,16}' '' -- $fmt | string collect)
                printf $fmt $_venv

            switch ( _is_python_correct_version )
                case ok
                    if python -m venv $VE_VENV_DIR/$_venv
                        printf '\nInfo: Created %s virtual environment.\n\n' $_venv
                    else
                        printf '\nError: Failed to create venv: %s\n\n' $_venv >&2
                        _cleanup
                        return 1
                    end
                case 'not on path'
                    set -l fmt '\nError: No Python executable found on the PATH to use for venv creation!\n\n'
                    printf $fmt >&2
                    _cleanup
                    return 1
                case 'wrong version'
                    set -l fmt '
                        Error: Incorrect Python version for the venv!
                               Python version needed for "%s" venv: %s
                               Possibly venv python was upgraded?\n\n'
                    set fmt (string replace -ra '(?m)^ {0,24}' '' -- $fmt | string collect)
                    printf $fmt $_version_on_path $_venv $_version_required >&2
                    _cleanup
                    return 1
            end
        end

        # Switch to managed  virtual environment and set $VE_VENV globally
        if test -f $VE_VENV_DIR/$_venv/bin/activate.fish
            source $VE_VENV_DIR/$_venv/bin/activate.fish
            if set -q VIRTUAL_ENV
                set -gx VE_VENV $VIRTUAL_ENV
                if test ! -x "$VE_VENV/bin/python"
                    set -l fmt '
                        Warning: No executable python found in venv!
                                 The "%s" venv may be corrupted?\n\n'
                    set fmt (string replace -ra '(?m)^ {1,16}' '' -- $fmt | string collect)
                    printf $fmt $_venv >&2
                else
                    set -l venv_py_version (_print_python_version $VE_VENV/bin/python)
                    if test "$venv_py_version" != "$_version_required"
                        set -l fmt '
                            Warning: Incorrect Python version for the venv!
                                     Python version found in "%s" venv: %s
                                     Python version required for this venv: %s
                                     The venv may need to be redone.\n\n'
                        set fmt (string replace -ra '(?m)^ {1,16}' '' -- $fmt | string collect)
                        printf $fmt $_venv $venv_py_version $_version_required >&2
                        return 1
                    end
                end
            else
                printf '\nError: Failed to activate virtual environment for %s\n\n' $_venv >&2
                return 1
            end
        end
    end

    if not begin
            set -q _flag_redo
            or set -q _flag_clear
        end
        _cleanup
        return 0
    end

    ## Process the --redo or --clear options

    # Make sure we are in a ve managed virtual environment
    if set -q VIRTUAL_ENV
        if test "$(path dirname $VIRTUAL_ENV)" != "$VE_VENV_DIR"
            printf '\nError: Not in a ve managed venv! Punting.\n\n' >&2
            set -e VE_VENV
            _cleanup
            return 1
        end
    else
        printf '\nError: Not in a venv! Punting.\n\n' >&2
        set -e VE_VENV
        _cleanup
        return 1
    end

    if test -z "$_venv"
        set -l venv_name (basename $VIRTUAL_ENV)
        if _is_managed_venv $venv_name
            switch ( _is_python_correct_version )
                case 'not on path'
                    set -l fmt '
                        Error: Python executable for "%s" venv not found!
                               Possibly a corrupted virtual environment?
                               Possibly corrupted shell environment?\n\n'
                    set fmt (string replace -ra '(?m)^ {0,24}' '' -- $fmt | string collect)
                    printf $fmt $_venv >&2
                    set -gx VE_VENV
                    _cleanup
                    return 1
                case 'wrong version'
                    set -l fmt '
                        Error: Incorrect Python version for venv!

                               Python version on $PATH: %s
                               Python version needed for "%s" venv: %s
                               Possibly venv python was upgraded?\n\n'
                    set fmt (string replace -ra '(?m)^ {0,24}' '' -- $fmt | string collect)
                    printf $fmt $_version_on_path $_venv $_version_required >&2
                    set -gx VE_VENV
                    _cleanup
                    return 1
            end
        else
            printf '\nError: Not in a ve managed venv! Punting.\n\n' >&2
            _cleanup
            return 1
        end
    end

    if set -q _flag_clear
        printf '\nRemoving all installed modules from venv: %s\n\n' $_venv >&2
        switch $_version_on_path
            case '3.10.*' '3.11.*'
                if test (pip list 2>/dev/null|tail +3|wc -l) -gt 2
                    pip uninstall -y (pip list|tail +3|fields 1|grep -Ev "(pip|setuptools)")
                end
                pip install --upgrade pip setuptools
            case '3.12.*' '3.13.*' '3.14.*' '3.15.*'
                if test (pip list 2>/dev/null|tail +3|wc -l) -gt 1
                    pip uninstall -y (pip list|tail +3|fields 1|grep -Ev "(pip)")
                end
                pip install --upgrade pip
            case '*'
                set -l fmt 'Error: Punting clearing venv: got an unexpected Python version: %s\n\n'
                printf $fmt $_version_on_path >&2
                _cleanup
                return 1
        end
    end

    if set -q _flag_redo
        printf '\nInstalling/upgrading all managed modules to venv: %s\n\n' $_venv >&2
        set -l modules $_modules[(contains -i $_venv $_venvs)]
        pip install --upgrade (string split ' ' $modules)
    end

    _cleanup
    return 0
end
