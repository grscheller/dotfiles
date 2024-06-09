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
# configuration file must be located there too, stored there too.
#
# I maintain one version of ve.conf in the home-env section of my dotfiles
# GIT repo and $VE_VENV_DIR is set from my fish configs.
#
function ve --description 'Manage a group of Python virtual environments'

   ## Initial setup

   # Provide an environment override mechanism to virtual environment location
   if not set -q VE_VENV_DIR
      set -g -x VE_VENV_DIR ~/devel/python_venvs/
   end
   mkdir -p $VE_VENV_DIR

   set -f ve_conf $VE_VENV_DIR/ve.conf

   if not test -f $ve_conf
      set -l fmt1 'Error: Virtual environment configuration file: %s,\n'
      set -l fmt2 '       was not found.\n\n'
      printf $fmt1$fmt2 $ve_conf
      return 1
   end

   ## Globals variables - fish scoping does NOT follow the call stack!!!

   set -g _venv_ve              # setup by _is_managed_venv
   set -g _version_required_ve  # setup by _is_managed_venv
   set -g _version_on_path_ve   # setup by _is_python_correct_version
   set -g _venvs_ve     # set up from configuration file
   set -g _versions_ve  # set up from configuration file
   set -g _modules_ve   # set up from configuration file

   ## Function level variables

   set -f dollar '$'  # used in eval statements

   ## Source in configuration file and set up venv schema

   # Source in venv configurations
   source $ve_conf
   set _venvs_ve $conf_virtual_envs
   for ii in (seq (count $_venvs_ve))
      eval set _versions_ve[$ii] {$dollar}conf_$_venvs_ve[$ii][1]
   end
   for ii in (seq (count $_venvs_ve))
      eval set _modules_ve[$ii] \"(string join ' ' {$dollar}conf_$_venvs_ve[$ii][2..-1])\"
   end
   set -e conf_virtual_envs
   for ii in (seq (count $_venvs_ve))
      eval set -e conf_$_venvs_ve[$ii]
   end

   ## Utility functions

   # Call before _is_python_correct_version
   function _is_managed_venv
      set -f name $argv[1]
      if contains $name $_venvs_ve
         set -l index (contains -i $name $_venvs_ve)
         set _venv_ve $_venvs_ve[$index]
         set _version_required_ve $_versions_ve[$index]
         return 0
      else
         return 1
      end
   end

   function _is_python_correct_version
      if digpath -x -q python
         set -f python_on_path (digpath -f -x python)
      else
         printf 'not on path\n'
         return
      end
      set -l python_versions_on_path (string split -f 2 ' ' ($python_on_path --version))
      set -l version_found $python_versions_on_path[1]
      set _version_on_path_ve $version_found
      if test "$version_found" = "$_version_required_ve"
         printf 'ok\n'
         return
      else
         printf 'wrong version\n'
         return
      end
   end

   function _usage
      set -l fmt1 'Usage: ve [<venv>]\n'
      set -l fmt2 '       ve [-c | --clear] [-r | --redo]\n'
      set -l fmt3 '       ve [-l | --list]\n'
      set -l fmt4 '       ve [-h | --help]\n\n'
      printf $fmt1$fmt2$fmt3$fmt4
   end

   function _cleanup
      set -e _venv_ve _version_required_ve _version_on_path_ve
      set -e _venvs_ve _versions_ve _modules_ve
      functions -e _is_managed_venv _is_python_correct_version _usage _cleanup
   end

   ## Get and process cmdline options, or fail gracefully.

   if not argparse -n 'Error: ' c/clear r/redo l/list h/help -- $argv
      _usage
      _cleanup
      return 1
   end

   set -f argc (count $argv)

   if set -q _flag_clear || set -q _flag_redo
      set -f ve_flags_cr
   end

   if test "$argc" -gt 0 && set -q ve_flags_cr || test "$argc" -gt 1
      printf 'Error: Invalid argument/option combination\n\n'
      _usage
      _cleanup
      return 1
   end

   ## Handle simple flags first

   # Show usage then quit.
   if set -q _flag_help
      _usage
      _cleanup
      return 0
   end

   # List names of managed venv's and valid venv directories, then quit.
   if set -q _flag_list
      set_color $fish_color_host; printf 'Managed venv location: '
      set_color $fish_color_user; printf '%s\n' $VE_VENV_DIR
      set_color $fish_color_host; printf 'Managed venv configurations:\n'
      set_color $fish_color_user; printf '  %s\n' $_venvs_ve
      set_color $fish_color_host; printf 'Virtual environments (managed or not):\n'
      set_color $fish_color_user
      for item in (ls $VE_VENV_DIR)
         if test -x $VE_VENV_DIR/$item/bin/python && test -f $VE_VENV_DIR/$item/bin/activate.fish
            printf '  %s\n' $item
         end
      end; printf '\n'
      set_color $fish_color_normal
      _cleanup
      return 0
   end

   # If no arguments or options given, deactivate any active venv,
   # give some useful information and then quit.
   if test "$argc" -eq 0 && not set -q ve_flags_cr
      if set -q VIRTUAL_ENV
         printf 'Shutting down active virtual environment.\n'
         deactivate
      else
         printf 'No Python venv in use.\n'
      end
      if digpath -q python
         printf 'Now using python version: %s\n\n' (python --version)
      else
         printf 'No python executable on path!\n\n'
      end
      if type -q pyenv
         pyenv versions
         printf '\n'
      end
      _cleanup
      return 0
   end

   ## Check if user supplied a venv name, if valid activate or create it.

   if test "$argc" -eq 1
      set -l name $argv[1]

      # First check if $venv_name_given is a ve managed environment
      if not _is_managed_venv $name
         set -l fmt '\nError: "%s" is not a ve managed venv!\n\n'
         printf $fmt $name
         _cleanup
         return 1
      end

      # Activate venv, create it if necessary, punt if python version wrong
      if not test -f "$VE_VENV_DIR/$_venv_ve/bin/activate.fish"
         set -l fmt1 '\n'
         set -l fmt2 'Info: The "%s" venv does not exist.\n'
         set -l fmt3 '      Creating new venv if using correct Python version.\n\n'
         printf $fmt1$fmt2$fmt3 $_venv_ve
         switch ( _is_python_correct_version )
            case 'ok'
               if python -m venv $VE_VENV_DIR/$_venv_ve
                  set -l fmt 'Info: Created %s virtual environment.\n\n'
                  printf $fmt $_venv_ve
               else
                  set -l fmt 'Error: Failed to create venv: %s\n\n'
                  printf $fmt $_venv_ve
                  _cleanup
                  return 1
               end
            case 'not on path'
               set -l fmt1 'Error: No Python executable found on $PATH to\n'
               set -l fmt2 '       use for venv creation!\n\n'
               printf $fmt1$fmt2
               _cleanup
               return 1
            case 'wrong version'
               set -l fmt1 'Error: Incorrect Python version for the venv!\n'
               set -l fmt2 '       Python version on $PATH: %s\n'
               set -l fmt3 '       Python version needed for "%s" venv: %s\n'
               set -l fmt4 '       Possibly venv python was upgraded?\n\n'
               set -l fmt $fmt1$fmt2$fmt3$fmt4
               printf $fmt $_version_on_path_ve $_venv_ve $_version_required_ve
               _cleanup
               return 1
         end
      end
      source $VE_VENV_DIR/$_venv_ve/bin/activate.fish
   end

   if not set -q ve_flags_cr
      _cleanup
      return
   end

   ## Process --clean and --redo options

   # Make sure we are in a ve virtual environment

   if set -q VIRTUAL_ENV
      if test (dirname $VIRTUAL_ENV) != $VE_VENV_DIR
         printf 'Error: Not in a ve managed venv! Punting.\n\n'
         _cleanup
         return 1
      end
   else
      printf 'Error: Not in a venv! Punting.\n\n'
      _cleanup
      return 1
   end

   if test -z "$_venv_ve"
      set -l name (basename $VIRTUAL_ENV)
      if _is_managed_venv $name
         switch ( _is_python_correct_version )
            case 'not on path'
               set -l fmt1 'Error: Python executable for "%s" venv not found!\n'
               set -l fmt2 '       Possibly a corrupted virtual environment?\n'
               set -l fmt3 '       Possibly corrupted shell environment?\n\n'
               printf $fmt1$fmt2$fmt3 $_venv_ve
               _cleanup
               return 1
            case 'wrong version'
               set -l fmt1 'Error: Incorrect Python version for venv!\n'
               set -l fmt2 '       Python version on $PATH: %s\n'
               set -l fmt3 '       Python version needed for "%s" venv: %s\n'
               set -l fmt4 '       Possibly venv python was upgraded?\n\n'
               printf $fmt xxx yyy zzz
               printf $fmt1$fmt2$fmt3$fmt4 $_version_on_path_ve $_venv_ve $_version_required_ve
               _cleanup
               return 1
         end
      else
         printf 'Error: Not in a ve managed venv! Punting.\n\n'
         _cleanup
         return 1
      end
   end

   if set -q _flag_clear
      set -l fmt '\nRemoving all installed modules from venv: %s\n\n'
      printf $fmt $_venv_ve
      switch $_version_on_path_ve
         case '3.10.*' '3.11.*'
            if test (pip list 2>/dev/null|tail +3|wc -l) -gt 2
               pip uninstall -y (pip list|tail +3|fields 1|grep -Ev "(pip|setuptools)")
            end
            pip install --upgrade pip setuptools
            return 0
         case '3.12.*'
            if test (pip list 2>/dev/null|tail +3|wc -l) -gt 1
               pip uninstall -y (pip list|tail +3|fields 1|grep -Ev "(pip)")
            end
            pip install --upgrade pip
            return 0
         case '*'
            set -l fmt 'Error: Punting clearing venv: got an unexpected Python version: %s\n\n'
            printf $fmt $_version_on_path_ve
            return 1
      end
   end

   if set -q _flag_redo
      set -l fmt '\nInstalling/upgrading all managed modules to venv: %s\n\n'
      printf $fmt $_venv_ve
      set -l modules $_modules_ve[(contains -i $_venv_ve $_venvs_ve)]
      pip install --upgrade (string split ' ' $modules)
   end
   _cleanup
   return 0
end
