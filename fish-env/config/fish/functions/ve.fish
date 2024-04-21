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

   # Provide an override mechanism to the usual virtual env location
   if not set -q VE_VENV_DIR
      set --global --export VE_VENV_DIR ~/devel/python_venvs/
   end

   # Source in the ve.conf configuration file
   set ve_conf $VE_VENV_DIR/ve.conf
   if test -f $ve_conf
      source $ve_conf
   else
      set fmt 'Virtual environment config file: %s,\nwas not found.\n\n'
      printf $fmt $ve_conf
      return 1
   end

   # Usage function
   function usage_ve
      printf 'Usage: ve\n'
      printf '       ve <virtenv>\n'
      printf '       ve [-c | --clear] [-r | --redo]\n'
      printf '       ve [-l | --list]\n'
      printf '       ve [-h | --help]\n\n'
   end

   # Flag if argument is a managed environment
   function isVenvManaged
      set veName $argv[1]
      set venvs $argv[2..-1]

      set --global --erase _ve_flag_venv_managed
      for venv in $venvs
         if test "$venv" = "$veName"
            set --global _ve_flag_venv_managed
            return 0
         end
      end
      return 1
   end

   function cleanup_ve_cmd --no-scope-shadowing
      set --global --erase _ve_flag_venv_managed
      functions --erase usage_ve isVenvManaged cleanup_ve_cmd
   end

   # Get cmdline options. If argparse errors out, show usage & quit with error.
   if not argparse -n 've' c/clear r/redo l/list h/help -- $argv
      usage_ve
      cleanup_ve_cmd
      return 1
   end

   # Show usage and quit
   if set -q _flag_help
      usage_ve
      cleanup_ve_cmd
      return 0
   end

   # List names of managed venv's, directories in $VE_VENV_DIR, then quit.
   if set -q _flag_list
      set_color $fish_color_host
      printf 'Tracked virtual environments:\n'

      set_color $fish_color_user
      for ve in $virtual_envs
         printf '%s\n' $ve
      end

      set_color $fish_color_host
      printf '\n%s:\n' $VE_VENV_DIR

      set_color $fish_color_user
      for item in (ls $VE_VENV_DIR)
         if test -x $VE_VENV_DIR/$item/bin/python
            printf '%s\n' $item
         end
      end

      set_color $fish_color_normal

      printf '\n'
      cleanup_ve_cmd
      return 0
   end

   set --erase _ve_flags_cr
   if set -q _flag_clear || set -q _flag_redo
      set _ve_flags_cr
   end

   set argc (count $argv)

   # Error out for invalid option/flag combination

   if set -q _ve_flags_cr && test $argc -gt 0
      printf 've: Invalid argument/option combination\n'
      usage_ve

      cleanup_ve_cmd
      return 1
   end

   if not set -q _ve_flags_cr && test $argc -gt 1
      printf 've: Invalid argument/option combination\n'
      usage_ve

      cleanup_ve_cmd
      return 1
   end

   # Try deactivating any venv if no arguments or options given
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

      cleanup_ve_cmd
      return 0
   end

   # If venv name given by user, activate venv if one exists with that name
   # in canonical managed venv location. Otherwise get the name of the venv
   # from the $VIRTUAL_ENV environment variable.
   set --erase venv_name
   if test $argc -eq 1
      # Get venv name from user
      set venv_name $argv[1]
      if test -f "$VE_VENV_DIR/$venv_name/bin/activate.fish"
         source $VE_VENV_DIR/$venv_name/bin/activate.fish
      else
         set fmt1 'Error: No venv for "%s" was found in the\n'
         set fmt2 '       managed venv location: %s\n\n'
         set fmt3 '       "%s" is a managed venv name\n\n'
         set fmt4 '       "%s" is not a managed venv name\n\n'
         printf $fmt1 $venv_name
         printf $fmt2 $VE_VENV_DIR
         if isVenvManaged $venv_name $virtual_envs
            printf $fmt3 $venv_name 
         else
            printf $fmt4 $venv_name 
         end
         cleanup_ve_cmd
         return 1
      end
   else if set -q VIRTUAL_ENV
      # Try venv name from environment, not necessarily a managed one.
      set venv_name (path basename $VIRTUAL_ENV)
      set venv_norm_dir (path normalize (path dirname $VIRTUAL_ENV))
      set ve_venv_norm_dir (path normalize $VE_VENV_DIR)
      if test "$venv_norm_dir" != "$ve_venv_norm_dir"
         set fmt1 'WARNING: The %s venv, located here: %s\n'
         set fmt2 '         is NOT in managed location: %s\n\n'
         set fmt3 '         "%s" is a managed venv name\n\n'
         set fmt4 '         "%s" is not a managed venv name\n\n'
         set pmt1 '         Proceed? [Y or [N]]? '
         printf $fmt1 $venv_name $venv_norm_dir
         printf $fmt2 $VE_VENV_DIR
         if isVenvManaged $venv_name $virtual_envs
            printf $fmt3 $venv_name 
         else
            printf $fmt4 $venv_name 
         end
         read --nchars 1 --prompt-str $pmt ans
         printf '\n'
         if test "$ans" != Y
            cleanup_ve_cmd
            return 1
         end
      end
      set -e venv_norm_dir ve_venv_norm_dir
   else
      set fmt1 'Error: Currently $VIRTUAL_ENV is not set. Either not in a venv,\n'
      set fmt2 '       or user did not supply a name of a venv located in the\n'
      set fmt3 '       managed venv location: %s.\n\n'
      printf $fmt1$fmt2$fmt3 $VE_VENV_DIR
      cleanup_ve_cmd
      return 1
   end

   # Check if $venv_name is a ve managed environment
   if not isVenvManaged $venv_name $virtual_envs
      set fmt 'Warning: "%s" is not a ve managed venv!\n\n'
      printf $fmt $venv_name
   end

   # Perform a consistency check, Make sure python on $PATH is at least
   # the same version as the one in the venv. If case pyenv is being used,
   # we cannot just call realpath on each one due to the possibility of
   # encountering pyenv shims in some cases.
   set pythonFromPath (which python)
   set pythonFromVE

   if set -q VIRTUAL_ENV
      set norm_venv (realpath (path normalize $VIRTUAL_ENV))

      if test "$norm_venv" != /usr && test "$norm_venv" != ""
         set pythonFromVE $VIRTUAL_ENV/bin/python
      end
      set -e norm_venv
   end

   if test -x "$pythonFromPath" && test -x "$pythonFromVE"
      set pyPathVers (string split -f 2 ' ' ($pythonFromPath --version))
      set pyPathVer $pyPathVers[1]
      set pyVenvVers (string split -f 2 ' ' ($pythonFromVE --version))
      set pyVenvVer $pyVenvVers[1]

      if test "$pyPathVer" != "$pyVenvVer"
         set fmt0 'Error: For venv = %s,\n'
         set fmt1 '       python version found on the $PATH: "%s"\n'
         set fmt2 '       python version found in this venv: "%s"\n'
         set fmt3 '       Do not match!\n\n'
         set fmt4 '       Maybe shell environment misconfigured?\n\n'
         printf $fmt0$fmt1$fmt2$fmt3$fmt4 $VIRTUAL_ENV $pyPathVer $pyVenvVer
         cleanup_ve_cmd
         return 1
      end
      set pythonVersion $pyVenvVer
   else
      if test ! -d "$VIRTUAL_ENV"
         set fmt 'Error: The "%s" venv directory, %s, does not exist!\n\n'
         printf $fmt $venv_name $VIRTUAL_ENV
      else if test ! -x "$VIRTUAL_ENV/bin/python"
         set fmt 'Error: No python executable found in "%s" for "%s" venv!\n\n'
         printf $fmt $VIRTUAL_ENV/bin $venv_name
      end

      if test -z "$pythonFromPath"
         set fmt 'No python executable found on $PATH\n\n'
      end

      cleanup_ve_cmd
      return 1
   end

   # If a managed environment, see if python version is what is expect.
   if set -q _ve_flag_venv_managed
      set dollar '$'
      eval set versionExpected "$dollar"version_$venv_name
      if test "$versionExpected" != "$pythonVersion"
         set fmt1 'Warning: Python version found: %s\n'
         set fmt2 '         Python version expected for %s: %s\n\n'
         set pmt1 '         Proceed? [Y or [N]]? '
         printf $fmt1$fmt2 $pythonVersion $venv_name $versionExpected
         read --nchars 1 --prompt-str $pmt1 ans
         printf '\n'
         if test "$ans" != Y
            cleanup_ve_cmd
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
         if test (pip list 2>/dev/null|tail +3|wc -l) -gt 2
            $PIP uninstall -y (pip list|tail +3|fields 1|grep -Ev "(pip|setuptools)")
         end
         $PIP install --upgrade pip setuptools
      case '3.12.*'
         if test (pip list 2>/dev/null|tail +3|wc -l) -gt 1
            $PIP uninstall -y (pip list|tail +3|fields 1|grep -Ev "(pip)")
         end
         $PIP install --upgrade pip
      case '*'
         set fmt 'Punting clearing venv: got an unconfigured Python version: %s\n\n'
         printf $fmt $pythonVersion

         cleanup_ve_cmd
         return 1
      end
   end

   if set -q _flag_redo
      set dollar '$'
      if set -q _ve_flag_venv_managed
         set fmt '\nInstalling/upgrading all managed modules to venv: %s\n\n'
         printf $fmt $venv_name
         eval set modules "$dollar"modules_$venv_name
         $PIP install --upgrade $modules
      else
         set fmt '\nThe "%s" venv is not a ve managed virtual environment.\n' 
         printf $fmt $VIRTUAL_ENV
         set prompt 'Use another managed configuration to redo? [Y or [N]]'
         read --nchars 1 --prompt-str $prompt ans
         if test "$ans" = Y
            set prompt 'Enter name of a managed environment: '
            read --line --prompt-str $prompt user_managed_venv_name
            if isVenvManaged $user_managed_venv_name $virtual_envs
               set fmt 'Installing/upgrading modules with managed venv: %s\n\n'
               printf $fmt $user_managed_env_name
               eval set modules "$dollar"modules_$user_managed_venv_name
               $PIP install --upgrade $modules
            else
               set fmt '"%s" is not a name of any managed venv.\n\n'
               printf $fmt 
            end
         end
      end
   end

   cleanup_ve_cmd
   return 0
end
