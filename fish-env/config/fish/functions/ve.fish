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
# If a non-managed python virtual environment, within $VE_VENV_DIR or not, is
# currently activated, the script will warn the user giving them an opportunity
# either to bail or work with the venv.
#
function ve --description 'Manage a group of Python virtual environments'

   # Function local variables
   set -f dollar '$'
   set -f venv_name
   set -f is_managed
   set -f ans
   set -f fmt
   set -f fmt1
   set -f fmt2
   set -f fmt3
   set -f fmt4
   set -f pmt
   set -f pmt1

   ## Initial setup

   # Provide an override mechanism to the default managed venv location
   if not set -q VE_VENV_DIR
      set -g -x VE_VENV_DIR ~/devel/python_venvs/
   end

   # Source in the ve.conf configuration file in the managed venv location
   set ve_conf $VE_VENV_DIR/ve.conf
   if test -f $ve_conf
      source $ve_conf
   else
      set fmt 'Virtual environment config file: %s,\nwas not found.\n\n'
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
      set veName $argv[1]
      set venvs $argv[2..-1]

      for venv in $venvs
         test "$venv" = "$veName"
         and return 0
      end
      return 1
   end

   function _ve_are_python_versions_same
      set -f python_1 $argv[1]
      set -f python_2 $argv[2]
      set -f norm_py_1 (realpath (path normalize $python_1))
      set -f norm_py_2 (realpath (path normalize $python_2))

      test "$norm_py_1" = "$norm_py_2" && return 0

      if test -x "$python_1" && test -x "$python_2"
         set -l python_1_version (_ve_print_python_version $pyhon_1)
         set -l python_2_version (_ve_print_python_version $pyhon_2)
         if test "$python_1_version" = "$python_2_version"
            return 0
         else
            return 2
         end
      else
         set n 0
         test -x $python_1 || set n (math n + 10)
         test -x $python_2 || set n (math n + 20)
         return n
      end
   end

   function _ve_is_python_on_path_correct_version
      set -f expectedVersion $argv[1]
      if digpath -x -q python
         set -f pythonFromPath (digpath -f -x python)
      else
         return 2
      end
      set pyPathVers (string split -f 2 ' ' ($pythonFromPath --version))
      set pyPathVer $pyPathVers[1]
      test "$pyPathVer" = "$expectedVersion"
      and return 0
      return 1
   end

   function _ve_print_python_version
      set -f python_executable $argv[1]
      set -f pyPathVers (string split -f 2 ' ' ($python_executable --version))
      printf '%s' $pyPathVers[1]
   end

   function _ve_clear_modules
      set -f Pip $argv[1]
      set -f python_version $argv[2]
      switch $python_version
         case '3.10.*' '3.11.*'
            if test ($Pip list 2>/dev/null|tail +3|wc -l) -gt 2
               $Pip uninstall -y ($Pip list|tail +3|fields 1|grep -Ev "(pip|setuptools)")
            end
            $Pip install --upgrade pip setuptools
         case '3.12.*'
            if test (pip list 2>/dev/null|tail +3|wc -l) -gt 1
               $Pip uninstall -y ($Pip list|tail +3|fields 1|grep -Ev "(pip)")
            end
            $Pip install --upgrade pip
         case '*'
            set fmt 'Error: Punting clearing venv: got an unconfigured Python version: %s\n\n'
            printf $fmt $python_version
            _ve_cleanup
            return 1
      end
   end

   function _ve_install_modules
      set -f venv_name $argv[1]
      eval set modules "$dollar"modules_$venv_name
      $Pip install --upgrade $modules
   end

   function _ve_cleanup --no-scope-shadowing
      set -f fs1 _ve_usage _ve_is_venv_managed _ve_are_python_versions_same
      set -f fs2 _ve_is_python_on_path_correct_version
      set -f fs3 _ve_clear_modules _ve_install_modules _ve_cleanup
      functions --erase $fs1 $fs2 $fs3
   end

   ## Get and process cmdline options, or fail gracefully.

   if not argparse -n 've' c/clear r/redo l/list h/help -- $argv
      _ve_usage
      _ve_cleanup
      return 1
   end

   set -f argc (count $argv)

   if set -q _flag_clear || set -q _flag_redo
      set -f _ve_flags_cr
   end

   if not set -q _ve_flags_cr && test $argc -gt 1
      printf 've: Invalid argument/option combination\n'
      _ve_usage
      _ve_cleanup
      return 1
   end

   if set -q _ve_flags_cr && test $argc -gt 0
      printf 've: Invalid argument/option combination\n'
      _ve_usage
      _ve_cleanup
      return 1
   end

   ## Handle simple flags first

   # Show usage then quit.
   set -q _flag_help && begin
      _ve_usage
      _ve_cleanup
      return 0
   end

   # List names of managed venv's and valid venv directories, then quit.
   if set -q _flag_list
      set_color $fish_color_host; printf 'Managed venv names:\n'
      set_color $fish_color_user; printf '%s\n' $virtual_envs
      set_color $fish_color_host; printf '\nManaged venv location: %s\n' $VE_VENV_DIR
      set_color $fish_color_user
      for item in (ls $VE_VENV_DIR)
         if test -x $VE_VENV_DIR/$item/bin/python && test -f $VE_VENV_DIR/$item/bin/activate.fish 
            printf '%s\n' $item
         end
      end
      set_color $fish_color_normal
      printf '\n'
      _ve_cleanup
      return 0
   end

   # if no arguments or options given, deactivate any active venv and then quit.
   if test "$argc" -eq 0 && not set -q _ve_flags_cr
      if set -q VIRTUAL_ENV
         printf 'Shutting down active virtual environment.\n'
         deactivate
      else
         printf 'No Python venv in use.\n'
      end
      printf 'Now using python version: %s\n\n' (python --version)
      if type -q pyenv
         pyenv versions
         printf '\n'
      end
      _ve_cleanup
      return 0
   end

   ## Manipulate virtual environments

   # User supplied a (not necessarily managed) Venv name.
   # Launch it if it is in the Managed venv location, or
   # offer to create it if it does not exist.
   if test "$argc" -eq 1
      set venv_name $argv[1]

      # First check if $venv_name is a ve managed environment
      if _ve_is_venv_managed $venv_name $virtual_envs
         set is_managed yes
      else
         set fmt 'Warning: "%s" is not a ve managed venv!\n\n'
         printf $fmt $venv_name
      end

      if test -f "$VE_VENV_DIR/$venv_name/bin/activate.fish"
         source $VE_VENV_DIR/$venv_name/bin/activate.fish
         _ve_cleanup
         return 0
      else
         set fmt1 'Warning: No venv for "%s" was found in the\n'
         set fmt2 '         managed venv location: %s\n'
         set fmt3 '         but "%s" is a managed venv name.\n\n'
         set fmt4 '         and "%s" is not a managed venv name.\n\n'
         printf $fmt1$fmt2 $venv_name $VE_VENV_DIR
         if test "$is_managed" = yes
            printf $fmt3 $venv_name 
         else
            printf $fmt4 $venv_name 
         end
      end

      if test "$is_managed" = yes
         set -l pmt 'Create a managed venv for "'$venv_name'" [Y or [N]]? '
         read --nchars 1 --prompt-str $pmt ans
         test "$ans" != Y && begin
            _ve_cleanup
            return 1
         end
      end

      eval set versionExpected "$dollar"version_$venv_name
      _ve_is_python_on_path_correct_version $versionExpected
      switch $status
         case 1
            set fmt1 'Warning: Python version on $PATH not expected version!\n'
            set fmt2 '         Expected version: "%s"\n'
            set fmt3 '         Version on $PATH: "%s"\n\n'
            set pmt1 '         Proceed? [Y or [N]]? '
            read --nchars 1 --prompt-str $pmt1 ans
            printf '\n'
            test "$ans" = Y || begin 
               _ve_cleanup
               return 1
            end
         case 2
            set fmt1 'Error: No executable version of python found on $PATH!\n\n'
            set fmt2 '       One is needed to create the "%s" venv.\n\n'
            printf $fmt1$fmt2 $venv_name
            _ve_cleanup
            return 1
      end

   end
   _ve_cleanup
   return 0
end
 #      test -e $VE_VENV_DIR/$venv_name
 #      and rm -rf $VE_VENV_DIR/$venv_name

 #      set fmt 'Creating "%s" venv.\n\n'
 #      printf $fmt $venv_name
 #      python -m venv $VE_VENV_DIR/$venv_name

 #      set fmt 'Activating "%s" venv.\n\n'
 #      printf $fmt $venv_name
 #      source $VE_VENV_DIR/$venv_name/bin/activate.fish

 #      set fmt 'clear/upgrade modules venv: %s\n\n'
 #      printf $fmt $venv_name
 #      _ve_clear_modules $VE_VENV_DIR/$venv_name/bin/pip (_ve_print_python_version (digpath -f -x python)
 # 
 #      set fmt 'Install/upgrad modules venv: %s\n\n'
 #      printf $fmt $venv_name

      # if digpath -q -x python
      #    set -l pythonFromPath (digpath -f -x python)
      #    _ve_are_python_versions_same $venv_name/bin/python $pythonFromPath
      #    switch $status
      #       case 1
      #          pass
      #    end
      # else
      #    printf 'Error: Cannot find a python executable on the $PATH\n\n'
      #    _ve_cleanup
      #    return 1
      # end

########
#
#
#
#
#
#
#
#   #          if _ve_are_python_versions_same $venv_name/bin/python (digpath -f -x python)
#   #             pass
#   #          else
#   #             set fmt1 'Error: Python on $PATH di \n'
#   #             set fmt2 '       managed venv location: %s\n'
#   #             set fmt3 '       but "%s" is a managed venv name\n\n'
#   #          end
#
#
#   #       _ve_cleanup
#   #       return 1
#   #    end
#   # else if set -q VIRTUAL_ENV
#   #    # Try venv name from environment, not necessarily a managed one.
#   #    set venv_name (path basename $VIRTUAL_ENV)
#   #    set venv_norm_dir (path normalize (path dirname $VIRTUAL_ENV))
#   #    set ve_venv_norm_dir (path normalize $VE_VENV_DIR)
#   #    if test "$venv_norm_dir" != "$ve_venv_norm_dir"
#   #       set fmt1 'WARNING: The "%s" venv, located here: %s\n'
#   #       set fmt2 '         is NOT in managed location: %s\n'
#   #       set fmt3 '         but "%s" is a managed venv name\n\n'
#   #       set fmt4 '         and "%s" is not a managed venv name\n\n'
#   #       set pmt1 '         Proceed? [Y or [N]]? '
#   #       printf $fmt1$fmt2 $venv_name $venv_norm_dir $VE_VENV_DIR
#   #       if _ve_is_venv_managed $venv_name $virtual_envs
#   #          printf $fmt3 $venv_name 
#   #       else
#   #          printf $fmt4 $venv_name 
#   #       end
#   #       read --nchars 1 --prompt-str $pmt1 ans
#   #       printf '\n'
#   #       if test "$ans" != Y
#   #          _ve_cleanup
#   #          return 1
#   #       end
#   #    end
#   #    set -e venv_norm_dir ve_venv_norm_dir
#   # else
#   #    set fmt1 'Error: Currently $VIRTUAL_ENV is not set. Either not in a venv,\n'
#   #    set fmt2 '       or user did not supply a name of a venv located in the\n'
#   #    set fmt3 '       managed venv location: %s.\n\n'
#   #    printf $fmt1$fmt2$fmt3 $VE_VENV_DIR
#   #    _ve_cleanup
#   #    return 1
#   # end
#
#
#
#
#
#   # Perform a consistency check, Make sure python on $PATH is at least
#   # the same version as the one in the venv. If case pyenv is being used,
#   # we cannot just call realpath on each one due to the possibility of
#   # encountering pyenv shims in some cases.
#
#   # If a managed environment, see if python version is what is expect.
#   if _ve_is_venv_managed $venv_name $virtual_envs
#      eval set versionExpected "$dollar"version_$venv_name
#      if test "$versionExpected" != "$pythonVersion"
#         set fmt1 'Warning: Python version found: %s\n'
#         set fmt2 '         Python version expected for %s: %s\n\n'
#         set pmt1 '         Proceed? [Y or [N]]? '
#         printf $fmt1$fmt2 $pythonVersion $venv_name $versionExpected
#         read --nchars 1 --prompt-str $pmt1 ans
#         printf '\n'
#         if test "$ans" != Y
#            _ve_cleanup
#            return 1
#         end
#      end
#   end
#
#   ## Perform actions for options --clean and --redo
#   set -f Pip $VIRTUAL_ENV/bin/pip
#
#   # Remove all installed modules from the venv
#   set -q _flag_clear && begin
#      set fmt '\nRemove all installed modules from venv: %s\n\n'
#      printf $fmt $venv_name
#      _ve_clear_modules $Pip $pythonVersion
#   end
#
#   if set -q _flag_redo
#      if _ve_is_venv_managed $venv_name $virtual_envs
#         set fmt '\nInstalling/upgrading all managed modules to venv: %s\n\n'
#         printf $fmt $venv_name
#         eval set modules "$dollar"modules_$venv_name
#         $Pip install --upgrade $modules
#      else
#         set fmt1 'WARNING: The "%s" venv, located here: %s\n'
#         set fmt2 '         is NOT in managed location: %s\n'
#         set fmt3 '         and "%s" is not a managed venv name,\n\n'
#         set pmt1 '         Use a managed venv configuration to redo? [Y or [N]] '
#         printf $fmt1$fmt2$fmt3 $venv_name $VIRTUAL_ENV $VE_VENV_DIR $venv_name
#         read --nchars 1 --prompt-str $pmt1 ans
#         printf '\n'
#         if test "$ans" = Y
#            set pmt 'Enter name of a managed environment config to use: '
#            read --line --prompt-str $pmt users_venv_name
#            if _ve_is_venv_managed $users_venv_name $virtual_envs
#               set fmt 'Installing/upgrading modules with managed venv: %s\n\n'
#               printf $fmt $users_venv_name
#               _ve_install_modules $users_venv_name
#            else
#               set fmt '"%s" is not a name of any managed venv.\n\n'
#               printf $fmt $user_managed_venv_name
#            end
#         end
#      end
#   end
#
#   _ve_cleanup
#   return 0
#end
