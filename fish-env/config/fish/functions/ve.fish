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

   function usage_ve
      printf 'Usage: ve\n'
      printf '       ve <virtenv>\n'
      printf '       ve [-c | --clear] [-r | --redo]\n'
      printf '       ve [-l | --list]\n'
      printf '       ve [-h | --help]\n\n'
   end

   function isVenvManaged_ve
      set veName $argv[1]
      set venvs $argv[2..-1]

      for venv in $venvs
         if test "$venv" = "$veName"
            return 0
         end
      end
      return 1
   end

   function do_python_versions_match_ve
      set -l norm_venv (realpath (path normalize $argv[1]))
      if test "$norm_venv" != /usr && test "$norm_venv" != ""
         set -f pythonFromVenv $norm_venv/bin/python
      else
         return 1
      end

      set -l pythonFromPath (realpath (path normalize (digpath -f -x python)))

      if test -x "$pythonFromPath" && test -x "$pythonFromVenv"
         set pyPathVers (string split -f 2 ' ' ($pythonFromPath --version))
         set pyPathVer $pyPathVers[1]
         set pyVenvVers (string split -f 2 ' ' ($pythonFromVenv --version))
         set pyVenvVer $pyVenvVers[1]

         if test "$pyPathVer" = "$pyVenvVer"
            return 0
         else
            return 1
         end
      else
         return 1
      end
   end

   function cleanup_ve --no-scope-shadowing
      functions --erase usage_ve isVenvManaged_ve do_python_versions_match_ve cleanup_ve
   end

   ## Get and process cmdline options, or fail gracefully.

   if not argparse -n 've' c/clear r/redo l/list h/help -- $argv
      usage_ve
      cleanup_ve
      return 1
   end

   set argc (count $argv)

   if set -q _flag_clear || set -q _flag_redo
      set -f _ve_flags_cr
   end

   if not set -q _ve_flags_cr && test $argc -gt 1
      printf 've: Invalid argument/option combination\n'
      usage_ve
      cleanup_ve
      return 1
   end

   if set -q _ve_flags_cr && test $argc -gt 0
      printf 've: Invalid argument/option combination\n'
      usage_ve
      cleanup_ve
      return 1
   end

   ## Handle simple flags first

   # Show usage then quit.
   if set -q _flag_help
      usage_ve
      cleanup_ve
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
      cleanup_ve
      return 0
   end

   # if no arguments or options given, deactivate any active venv and then quit.
   if test $argc -eq 0 && not set -q _ve_flags_cr
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

      cleanup_ve
      return 0
   end

   ## Manipulate virtual environments

   # Function local variables
   set -f dollar '$'
   set -f venv_name
   set -f isManaged no

   # User supplied a (not necessarily managed) Venv name
   # Launch it if it is in the Managed venv location, or
   # offer to create it if it does not exist.
   if test $argc -eq 1
      set -l venv_name $argv[1]

      # First check if $venv_name is a ve managed environment
      if isVenvManaged_ve $venv_name $virtual_envs
         set -f isManaged yes
      else
         set fmt 'Warning: "%s" is not a ve managed venv!\n\n'
         printf $fmt $venv_name
      end

      if test -f "$VE_VENV_DIR/$venv_name/bin/activate.fish"
         source $VE_VENV_DIR/$venv_name/bin/activate.fish
         cleanup_ve
         return 0
      else
         set fmt1 'Error: No venv for "%s" was found in the\n'
         set fmt2 '       managed venv location: %s\n'
         set fmt3 '       but "%s" is a managed venv name\n\n'
         set fmt4 '       and "%s" is not a managed venv name\n\n'
         printf $fmt1$fmt2 $venv_name $VE_VENV_DIR
         if test "$isManaged" = yes
            printf $fmt3 $venv_name 
         else
            printf $fmt4 $venv_name 
         end
      end

      if test "$isManaged" = yes
         set fmt 'Create a managed venv for "%s"? [Y or [N]] '
         printf $fmt $venv_name
         read --nchars 1 --prompt-str $pmt1 ans
         printf '\n'
         if test "$ans" != Y
            cleanup_ve
            return 1
         end
         eval set versionExpected "$dollar"version_$venv_name
         if digpath -q -x python
            do_python_versions_match_ve $venv_name (digpath -f -x python) 
         else
            printf 'Error: Cannot find a python executable on the $PATH\n\n'
            cleanup_ve
            return 1
         end






         cleanup_ve
         return 1
      end
   else if set -q VIRTUAL_ENV
      # Try venv name from environment, not necessarily a managed one.
      set venv_name (path basename $VIRTUAL_ENV)
      set venv_norm_dir (path normalize (path dirname $VIRTUAL_ENV))
      set ve_venv_norm_dir (path normalize $VE_VENV_DIR)
      if test "$venv_norm_dir" != "$ve_venv_norm_dir"
         set fmt1 'WARNING: The "%s" venv, located here: %s\n'
         set fmt2 '         is NOT in managed location: %s\n'
         set fmt3 '         but "%s" is a managed venv name\n\n'
         set fmt4 '         and "%s" is not a managed venv name\n\n'
         set pmt1 '         Proceed? [Y or [N]]? '
         printf $fmt1$fmt2 $venv_name $venv_norm_dir $VE_VENV_DIR
         if isVenvManaged_ve $venv_name $virtual_envs
            printf $fmt3 $venv_name 
         else
            printf $fmt4 $venv_name 
         end
         read --nchars 1 --prompt-str $pmt1 ans
         printf '\n'
         if test "$ans" != Y
            cleanup_ve
            return 1
         end
      end
      set -e venv_norm_dir ve_venv_norm_dir
   else
      set fmt1 'Error: Currently $VIRTUAL_ENV is not set. Either not in a venv,\n'
      set fmt2 '       or user did not supply a name of a venv located in the\n'
      set fmt3 '       managed venv location: %s.\n\n'
      printf $fmt1$fmt2$fmt3 $VE_VENV_DIR
      cleanup_ve
      return 1
   end





   # Perform a consistency check, Make sure python on $PATH is at least
   # the same version as the one in the venv. If case pyenv is being used,
   # we cannot just call realpath on each one due to the possibility of
   # encountering pyenv shims in some cases.

   # If a managed environment, see if python version is what is expect.
   if set -q _ve_flag_venv_managed
      eval set versionExpected "$dollar"version_$venv_name
      if test "$versionExpected" != "$pythonVersion"
         set fmt1 'Warning: Python version found: %s\n'
         set fmt2 '         Python version expected for %s: %s\n\n'
         set pmt1 '         Proceed? [Y or [N]]? '
         printf $fmt1$fmt2 $pythonVersion $venv_name $versionExpected
         read --nchars 1 --prompt-str $pmt1 ans
         printf '\n'
         if test "$ans" != Y
            cleanup_ve
            return 1
         end
      end
   end

   ## Perform actions for options --clean and --redo
   set PIP $VIRTUAL_ENV/bin/pip

   # Remove all installed modules from the venv
   if set -q _flag_clear
      set fmt '\nRemove all installed modules from venv: %s\n\n'
      printf $fmt $venv_name
      switch $pythonVersion
      case '3.10.*' '3.11.*'
         if test ($PIP list 2>/dev/null|tail +3|wc -l) -gt 2
            $PIP uninstall -y ($PIP list|tail +3|fields 1|grep -Ev "(pip|setuptools)")
         end
         $PIP install --upgrade pip setuptools
      case '3.12.*'
         if test (pip list 2>/dev/null|tail +3|wc -l) -gt 1
            $PIP uninstall -y ($PIP list|tail +3|fields 1|grep -Ev "(pip)")
         end
         $PIP install --upgrade pip
      case '*'
         set fmt 'Punting clearing venv: got an unconfigured Python version: %s\n\n'
         printf $fmt $pythonVersion

         cleanup_ve
         return 1
      end
   end

   if set -q _flag_redo
      if set -q _ve_flag_venv_managed
         set fmt '\nInstalling/upgrading all managed modules to venv: %s\n\n'
         printf $fmt $venv_name
         eval set modules "$dollar"modules_$venv_name
         $PIP install --upgrade $modules
      else
         set fmt1 'WARNING: The "%s" venv, located here: %s\n'
         set fmt2 '         is NOT in managed location: %s\n'
         set fmt3 '         but "%s" is a managed venv name\n\n'
         set fmt4 '         and "%s" is not a managed venv name\n\n'
         set pmt1 '         Use a managed venv configuration to redo? [Y or [N]] '

         printf $fmt1$fmt2 $VIRTUAL_ENV
         read --nchars 1 --prompt-str $pmt1 ans
         printf '\n'
         if test "$ans" = Y
            set pmt2 'Enter name of a managed environment: '
            read --line --prompt-str $pmt2 user_managed_venv_name
            if isVenvManaged_ve $user_managed_venv_name $virtual_envs
               set fmt3 'Installing/upgrading modules with managed venv: %s\n\n'
               printf $fmt $user_managed_venv_name
               eval set modules "$dollar"modules_$user_managed_venv_name
               $PIP install --upgrade $modules
            else
               set fmt '"%s" is not a name of any managed venv.\n\n'
               printf $fmt $user_managed_venv_name
            end
         end
      end
   end

   cleanup_ve
   return 0
end
