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

   set -f dollar '$'
   set -f venv_name
   set -f python_version_expected
   set -f python_version_from_path

   ## Initial setup

   # Provide an override mechanism to the default managed venv location
   if not set -q VE_VENV_DIR
      set -g -x VE_VENV_DIR ~/devel/python_venvs/
   end
   mkdir -p $VE_VENV_DIR

   # Source in the ve.conf configuration file in the managed venv location
   set ve_conf $VE_VENV_DIR/ve.conf
   if test -f $ve_conf
      source $ve_conf
   else
      set -l fmt 'Virtual environment config file: %s,\nwas not found.\n\n'
      printf $fmt $ve_conf
      return 1
   end

   ## Utility functions

   function _ve_usage
      printf 'Usage: ve\n'
      printf '       ve <virtenv>\n'
      printf '       ve [-c | --clear] [-r | --redo]\n'
      printf '       ve [-l | --list]\n'
      printf '       ve [-h | --help]\n\n'
   end

   function _ve_is_venv_managed
      set -f ve $argv
      for venv in $conf_virtual_envs 
         if test "$venv" = "$ve"
            set python_version_expected $venv
            return 0
         end
         return 1
      end
   end

   # call after _ve_is_venv_managed
   function _ve_is_python_on_path_expected_version
      set -f python_from_path
      if digpath -x -q python
         set python_from_path (digpath -f -x python)
      else
         return 1
      end
      set -l python_versions_on_path (string split -f 2 ' ' ($python_from_path --version))
      set python_version_from_path $python_versions_on_path[1]
      test "$python_version_from_path" = "$python_version_expected"
      and return 0
      return 1
   end

   # call after _ve_is_venv_managed
   function _ve_is_python_on_path_correct_version
      set -f python_from_path
      if digpath -x -q python
         set python_from_path (digpath -f -x python)
      else
         return 1
      end
      set -l python_versions_on_path (string split -f 2 ' ' ($python_from_path --version))
      set python_version_from_path $python_versions_on_path[1]
      test "$python_version_from_path" = "$python_version_expected"
      and return 0
      return 1
   end

   function _ve_clear_modules
      set -f Pip $argv[1]
      switch $python_version_from_path
         case '3.10.*' '3.11.*'
            if test ($Pip list 2>/dev/null|tail +3|wc -l) -gt 2
               $Pip uninstall -y ($Pip list|tail +3|fields 1|grep -Ev "(pip|setuptools)")
            end
            $Pip install --upgrade pip setuptools
            return 0
         case '3.12.*'
            if test (pip list 2>/dev/null|tail +3|wc -l) -gt 1
               $Pip uninstall -y ($Pip list|tail +3|fields 1|grep -Ev "(pip)")
            end
            $Pip install --upgrade pip
            return 0
         case '*'
            set -l fmt 'Error: Punting clearing venv: got an unexpected Python version: %s\n\n'
            printf $fmt $python_version_from_path
            return 1
      end
   end

   function _ve_cleanup --no-scope-shadowing
      set -l fs _ve_usage _ve_cleanup _ve_clear_modules _ve_is_venv_managed \
                _ve_is_python_on_path_expected_version \
                _ve_is_python_on_path_correct_version
      functions --erase $fs
   end

   ## Get and process cmdline options, or fail gracefully.

   if not argparse -n 've' c/clear r/redo l/list h/help -- $argv
      _ve_usage
      _ve_cleanup
      return 1
   end

   set -f argc (count $argv)

   if set -q _flag_clear || set -q _flag_redo
      set -f ve_flags_cr
   end

   if test "$argc" -gt 1
      printf 've: Invalid argument/option combination\n'
      _ve_usage
      _ve_cleanup
      return 1
   end

   ## Handle simple flags first

   # Show usage then quit.
   if set -q _flag_help
      _ve_usage
      _ve_cleanup
      return 0
   end

   # List names of managed venv's and valid venv directories, then quit.
   if set -q _flag_list
      set_color $fish_color_host; printf 'Managed venv location:\n'
      set_color $fish_color_user; printf '%s\n\n' $VE_VENV_DIR
      set_color $fish_color_host; printf 'Managed venv configurations:\n'
      set_color $fish_color_user; printf '%s\n' $conf_virtual_envs
      set_color $fish_color_host; printf '\nVirtual environments (managed or not):\n'
      set_color $fish_color_user
      for item in (ls $VE_VENV_DIR)
         if test -x $VE_VENV_DIR/$item/bin/python && test -f $VE_VENV_DIR/$item/bin/activate.fish 
            printf '%s\n' $item
         end
      end; printf '\n'
      set_color $fish_color_normal
      _ve_cleanup
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
      set -g -e VE_VIRTUAL_ENV
      _ve_cleanup
      return 0
   end

   ## Check if user supplied a venv name, if valid activate or create it.

   if test "$argc" -eq 1
      set -l venv_name_given $argv[1]

      # First check if $venv_name_given is a ve managed environment
      if not _ve_is_venv_managed $venv_name_given
         set -l fmt '\nError: "%s" is not a ve managed venv!\n\n'
         printf $fmt $venv_name_given
         _ve_cleanup
         return 1
      end

      # Activate venv, create it if necessary
      if not test -f "$VE_VENV_DIR/$venv_name_given/bin/activate.fish"
         # check if Python version is correct one for the venv
         set -l fmt1 '\n'
         set -l fmt2 'Info: "%s venv dose not exist.\n'
         set -l fmt3 '      "Creating the virtual emvironment.\n\n'
         printf $fmt1$fmt2$fmt3 $venv_name_given
         if _ve_is_python_on_path_expected_version
            set -l venv_to_create "$VE_VENV_DIR/$venv_name_given"
            rm -rf $venv_to_create
            if not python -m venv $venv_to_create
               set -l fmt 'Error: Failed to create venv: %s'
               printf $fmt $venv_to_create
               _ve_cleanup
               return 1
            end
         else
            set -l fmt 'Error: Python on $PATH wrong version for venv: "%s"\n\n'
            printf $fmt $venv_name_given
            _ve_cleanup
            return 1
         end
      end
      source $VE_VENV_DIR/$venv_name_given/bin/activate.fish
      set -g VE_VIRTUAL_ENV $VIRTUAL_ENV
   end

   ## Perform actions for options --clean and --redo

   # Make sure we are in a virtual environment
   if not set -q VIRTUAL_ENV
      set -g -e VE_VIRTUAL_ENV
      printf 'Error: Not in a ve managed venv! Punting.\n\n'
      _ve_cleanup
      return 1
   end

   if not set -q VE_VIRTUAL_ENV
      if test (dirname $VIRTUAL_ENV) != $VE_VENV_DIR
         printf 'Error: Not in a ve managed venv! Punting.\n\n'
         _ve_cleanup
         return 1
      end

      set venv_name (basename $VIRTUAL_ENV)
      if _ve_is_venv_managed $venv_name
         set -g VE_VIRTUAL_ENV $VIRTUAL_ENV
      else
         printf 'Error: Not in a ve managed venv! Punting.\n\n'
         _ve_cleanup
         return 1
      end
   end




   set -f Pip $VIRTUAL_ENV/bin/pip

   # Remove all installed modules from the venv
   if set -q _flag_clear
      set -l fmt '\nRemoving all installed modules from venv: %s\n\n'
      printf $fmt $venv_name
      if not _ve_clear_modules $Pip $pythonVersion
         _ve_cleanup
         return 1
      end
   end

   if set -q _flag_redo
      set -l fmt '\nInstalling/upgrading all managed modules to venv: %s\n\n'
      printf $fmt $venv_name
      eval set modules "$dollar"conf_modules_$venv_name
      $Pip install --upgrade $modules
   end

   _ve_cleanup
   return 0
end
