# This function manages a group of Python virtual environments (venv).
#
# I manage my installed versions on Python with pyenv, so I have to be mindful
# of the possibility of pyenv shims being in use. I did not want this function
# to depend on pyenv commands in case I am in a situation where pyenv is not
# used,
#
# The global environment variable $PYTHON_VE_VENVS controls which group of
# venvs I am managing together. All the venvs must be installed in the directory
# which it points to, Also the configuration file ve.conf must also be stored
# there.
#
# I maintain one version of ve.conf with home-env section of my dotfiles GIT
# repo and set $PYTHON_VE_VENVS from my fish configs.
#
function ve --description 'Manage a group of Python virtual environments'

   # Provide an override mechanism to the usual virtual env location
   if not set -q PYTHON_VE_VENVS
      set --global --export PYTHON_VE_VENVS ~/devel/python_venvs/
   end

   # Source in the ve.conf configuration file
   set ve_conf $PYTHON_VE_VENVS/ve.conf
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
      printf '       ve [-c | --clear]\n'
      printf '       ve [-r | --redo]\n'
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
   argparse -n 've' c/clear r/redo l/list h/help -- $argv
   or begin
      usage_ve
      cleanup_ve_cmd
      return 1
   end

   # Show usage and quit.
   if set -q _flag_help
      usage_ve
      cleanup_ve_cmd
      return 0
   end

   # List names of managed venvs, directories in $PYTHON_VE_VENVS, then quit.
   if set -q _flag_list
      set_color $fish_color_host
      printf 'Tracked virtual environments:\n'
      set_color $fish_color_user
      for ve in $virtual_envs
         printf '%s\n' $ve
      end
      set_color $fish_color_host
      printf '\n%s:\n' $PYTHON_VE_VENVS
      set_color $fish_color_user
      for item in (ls $PYTHON_VE_VENVS)
         test -x $PYTHON_VE_VENVS/$item/bin/python && printf '%s\n' $item
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

   # Error out for invalid option/flag combination.
   if set -q _ve_flags_cr
      if test $argc -gt 0
         printf 'Invalid argument/option combination\n'
         usage_ve
         cleanup_ve_cmd
         return 1
      end
   else
      if test $argc -gt 1
         printf 'Invalid argument/option combination\n'
         usage_ve
         cleanup_ve_cmd
         return 1
      end
   end

   # Try deactivating any venv if no arguments or options given.
   if test $argc -eq 0 && not set -q _ve_flags_cr
      if type -q deactivate
         printf 'Shutting down active virtual environment.\n'
         type -q deactivate && deactivate
      else
         printf 'No Python venv in use.\n'
      end
      printf 'Using python version: %s\n\n' (python --version)
      set --global --erase PYTHON_VE_VENV
      cleanup_ve_cmd
      return 0
   end

   # Activate venv if name given by user, else get venv from $PYTHON_VE_VENV
   # if it is set, otherwise punt.
   set --erase venvName
   if test $argc -eq 1
      # Get venv name from user.
      set venvName $argv[1]
      if test -f $PYTHON_VE_VENVS/$venvName/bin/activate.fish
         source $PYTHON_VE_VENV/bin/activate.fish
         set --global --export PYTHON_VE_VENV $PYTHON_VE_VENVS/$venvName
      else
         # Give user feedback on failure and quit.
         set fmt 'Virtual env activation script,\n   %s\nwas ot found!\n\n'
         printf $fmt $PYTHON_VE_VENVS/$venvName/bin/activate.fish

         if test -d $PYTHON_VE_VENVS/$venvName
            fmt = 'Python venv %s not found here: %s\n\n'
            printf $fmt $venvName $PYTHON_VE_VENVS
         end
         cleanup_ve_cmd
         return 1
      end
   else if set -q PYTHON_VE_VENV
      # Try and get from environment
      set venvName (string replace -r '^.*/' '' $PYTHON_VE_VENV)
   else
      # Give up.
      printf 'Currently $PYTHON_VE_VENV is not set.\n'
      printf 'Either not in a venv or, possibly, a venv '
      printf 'was manually invoked via activate?\n\n'
      cleanup_ve_cmd
      return 1
      end
   end

   # Check if $venvName is a ve managed environment
   if not isVenvManaged $venvName $virtual_envs
      set fmt 'Warning: "%s" is not one of ve\'s managed venv!\n'
      printf $fmt $venvName
   end

   # Perform a consistency check, Make sure python on $PATH is at least
   # the same version as the one in the venv. If case pyenv is being used,
   # we cannot just call realpath on each one due to pyenv shims.
   set pythonFromPath (which python)
   if -q PYTHON_VE_VENV
      set pythonFromVE $PYTHON_VE_VENV/bin/python
   else

   end

   if test -x "$pythonFromPath" && test -x "$pythonFromVE"
      set pyPathVers (string split -f 2 ' ' ($pythonFromPath --version))
      set pyPathVer $pyPathVers[1]
      set pyVenvVers (string split -f 2 ' ' ($pythonFromVE --version))
      set pyVenvVer $pyVenvVers[1]

      if test "$pyPathVer" != "$pyVenvVer"
         set fmt0 'For venv = %s,\n'
         set fmt1 'python version found on the $PATH: "%s"\n'
         set fmt2 'python version found in this venv: "%s"\n'
         set fmt3 'Do not match! Shell environment misconfigured?\n\n'
         printf $fmt0$fmt1$fmt2$fmt3 $PYTHON_VE_VENV $pyPathVer $pyVenvVer
         cleanup_ve_cmd
         return 1
      end
      set pythonVersion $pyVenvVer
   else
      # See if a venv does not exists in the canonical location
      if test ! -e "$PYTHON_VE_VENV/bin/activate.fish"
         set fmt 'A venv for "%s" was not found in $PYTHON_VE_VENVS: %s\n\n'
         printf $fmt $venvName $PYTHON_VE_VENVS
         set --global --erase PYTHON_VE_VENV
      end
      if test -z "$pythonFromPath"
         fmt = 'No python executable found on $PATH\n\n'
      end
      cleanup_ve_cmd
      return 1
   end

   # If a managed environment,see if venv is the version we expect
   if set -q _ve_flag_venv_managed
      set dollar '$'
      eval set versionExpected "$dollar"version_$venvName
      if test "$versionExpected" != "$pythonVersion"
         set fmt 'Python version found: %s\nPython version expected for %s: %s\n'
         printf $fmt $pythonVersion $venvName $versionExpected
         read --nchars 1 --prompt-str 'Proceed [Y or [N]]? ' ans
         if test $ans != Y
            cleanup_ve_cmd
            return 1
         end
      end
   end

   ## Perform actions for options --clean and --redo

   if set -q _ve_flags_cr
      set PIP $PYTHON_VE_VENV/bin/pip
   end

   # Remove all installed modules from the venv
   if set -q _flag_clear
      set fmt 'Remove all installed modules from venv: %s\n\n'
      printf $fmt $venvName
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
      set fmt 'Reinstall/upgrade all managed modules to venv: %s\n\n'
      printf $fmt $venvName
      set dollar '$'
      eval set modules "$dollar"modules_$venvName
      $PIP install --upgrade $modules
   end

   cleanup_ve_cmd
   return 0
end
