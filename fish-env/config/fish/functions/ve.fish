function ve --description 'Instantiate or configure a Python virtual env'

   # Provide an override mechanism to the usual virtual env location
   if not set -q PYTHON_GRS_VENVS
      set --global --export PYTHON_GRS_VENVS ~/devel/python_venvs/
   end

   # Source in the ve.conf configuration file
   set ve_conf $PYTHON_GRS_VENVS/ve.conf
   if test -f $ve_conf
      source $ve_conf
   else
      set fmt 'Virtual environment config file: %s,\nwas not found.\n\n'
      printf $fmt $ve_conf
      return 1
   end

   # Usage function
   #   note: Fish functions have global scope & will need
   #         to be erased before the ve function ends.
   function _usage_ve
      printf 'Usage: ve\n'
      printf '       ve <virtenv>\n'
      printf '       ve [-c | --clear]\n'
      printf '       ve [-r | --redo]\n'
      printf '       ve [-l | --list]\n'
      printf '       ve [-h | --help]\n\n'
   end

   # Get cmdline options. If argparse errors out, show usage & quit with error.
   argparse -n 've' c/clear r/redo l/list h/help -- $argv
   or begin
      _usage_ve
      functions -e _usage_ve
      return 1
   end

   # Show usage and quit.
   if set -q _flag_help
      _usage_ve
      functions -e _usage_ve
      return 0
   end

   # List names of managed venvs and quit.
   if set -q _flag_list
      set fmt 'venvs in %s:'
      printf $fmt $PYTHON_GRS_VENVS
      for ve in $virtual_envs
         printf ' %s' $ve
      end
      printf '\n\n'
      functions -e _usage_ve
      return 0
   end

   set --erase flag_cr
   if set -q _flag_clear || set -q _flag_redo
      set flag_cr
   end

   echo Debug got to 1
   
   set argc (count $argv)

   # Error out for invalid option/flag combination 
   if set -q flag_cr
      if test $argc -gt 0
         printf 'Invalid argument/option combination\n'
         _usage_ve
         functions -e _usage_ve
         return 1
      end
   else if test $argc -gt 1
         printf 'Invalid argument/option combination\n'
         _usage_ve
         functions -e _usage_ve
         return 1
   end

   echo Debug got to 2
   
   # Try deactivating any venv if no arguments or options given
   if test $argc -eq 0 && not set -q flag_cr
      printf 'Shutting down any active virtual environment.\n'
      type -q deactivate && deactivate
      set fmt 'No Python venv in use, using python version: %s\n\n'
      printf $fmt (python --version)
      set --global --erase PYTHON_GRS_VENV
      functions -e _usage_ve
      return 1
   end

   echo Debug got to 3

   # Get the virtual environment name from user or grok from environment
   set --erase veName flag_punt flag_managed

   if test $argc -eq 1
      set veName $argv[1]
   end

   echo Debug got to 4

   if not set -q veName && not set -q PYTHON_GRS_VENV
      printf 'Not currently in a ve managed Python virtual environment.\n'
      printf 'Possibly venv manually invoked?\n\n'
      read --nchars 1 --prompt-str 'Proceed [Y or N]? ' ans
      if test $ans != Y
         set flag_punt
      end
   end

   # Perform consistency checks and reverse engineer venv name
   set pythonFromPath "(which python)"
   set pythonFromVE $PYTHON_GRS_VENV/bin/python
   if test -n "$pythonFromPath" && test -n "$pythonFromVE"
      set pyPathVers (string split -f 2 ' ' ($pythonFromPath --version))
      set pyPathVer $pyPathVer[1]
      set pyVenvVers (string split -f 2 ' ' ($pythonFromVE --version))
      set pyVenvVer $pyVenvVer[1]

      echo 'pyPathVer = $pyPathVer'
      echo 'pyVenvVer = $pyVenvVer'

      if test "$pyPathVer" = "$pyVenvVer"
         set pythonVersion (string replace -r '^.*/' '' $pyPathVer)
      else
         set fmt0 'For venv = %s\n'
         set fmt1 'Version of Python found on $PATH = "%"\n'
         set fmt2 'Version of Python in  $PATH = "%"\n'
         set fmt3 'do not match! Punting.\n\n'
         printf $fmt0$fmt1$fmt2$fmt3 $PYTHON_GRS_VENV $pyPathVer $pyVenvVer
         set flag_punt
      end
   else
      test -z $pythonFromPath && printf 'No python executable found on $PATH!\n'
      test -z $pythonFromVE && printf 'No python executable found in the "%s" virtual env!\n' 
      set flag_punt
   end

   echo Debug got to 5

   if set -q veName
      # See if $veName is one of our manage versions of Python
      for ve in $virtual_envs
         if test "$ve" = "$veName"
            set flag_managed
            break
         end
      end
   else
      if test (count $pythonFromPath) -eq 0
         printf 'A python executable was not found on the $PATH.\n\n'
      end
      if test (count $pythonFromVE) -eq 0
         set fmt1 'A python executable was not found in the %s venv, the\n'
         set fmt2 'virtual environment may be damaged or non-existant.\n\n'
         printf $fmt1 (string replace -r '^.*/' '' $PYTHON_GRS_VENV)
         printf $fmt2
      end
   end

   echo Debug got to 6

   # Give user option to punt if not in a manage environment
   if not set -q flag_managed
      set fmt 'virtual env: %s is not one of our managed ones.\n'
      printf $fmt $veName
      if not set flag_punt
         read --nchars 1 --prompt-str 'Proceed [Y or N]? ' ans
         if test $ans != Y
            set flag_punt
         end
      end
   end

   echo Debug got to 7

   if set -q flag_punt
      functions -e _usage_ve
      return 1
   end

   echo Debug got to 8

   if not set -q flag_cr
      set python_venv $PYTHON_GRS_VENVS/$veName

      # If venv does not exists in the canonical location, then punt.
      if test ! -e "$python_venv/bin/activate.fish"
         set fmt 'A venv for "%s" was not found in $PYTHON_GRS_VENVS: %s\n\n'
         printf $fmt $veName $PYTHON_GRS_VENVS
         set --global --erase PYTHON_GRS_VENV
         functions -e _usage_ve
         return 1
      end

   echo Debug got to 9

      ## Activate Python virtual environment and exit
      set --global --export PYTHON_GRS_VENV $python_venv
      source $PYTHON_GRS_VENV/bin/activate.fish
      functions -e _usage_ve
      return 0
   end

   echo Debug got to 10

   # See if the venv is the version we expect
   if set -q managed
      eval set versionExpected \$ver_$veName
      if test "$versionExpected" != "$pythonVersion"
         set fmt 'Python version found: %s\nPython version expected for %s: %s\n'
         printf $fmt $pythonVersion $veName $versionExpected
         read --nchars 1 --prompt-str 'Proceed [Y or N]? ' ans
         if test $ans != Y
            functions -e _usage_ve
            return 1
         end
      end
   end

   echo Debug got to 11

   if set -q flag_managed
      if set -q managed
         fmt = 'WARNING: "%s" is not a managed venv\n'
         print $fmt $veName
      end
   end

   ## Perform option actions
   if set -q _flag_clear
      switch $pythonVersion
      case '3.11.*' '3.10.*'
         echo clean 11: got $pythonVersion
      case '3.12.*'
         echo clean 12: got $pythonVersion
      case '*'
         printf 'Punting clearing venv: unsupported Python version "s"\n\n'
      end
   # p3_11clr 'pip uninstall -y (pip list|tail +3|fields 1|grep -Ev "(pip|setuptools)")'
   # p3_12clr 'pip uninstall -y (pip list|tail +3|fields 1|grep -Ev "(pip)")'
   end

   echo Debug got to 12

   if set -q _flag_redo
      switch $pythonVersion
      case '3.11.*' '3.10.*'
         echo redo 11: got $pythonVersion
      case '3.12.*'
         echo redo 12: got $pythonVersion
      case '*'
         set fmt 'Punting redoing %s venv: got unexpected Python version "%s"\n\n'
         printf $fmt $veName $pythonVersion
      end
   # vdredo 'pip install --upgrade ipython pytest pdoc3 flit "python-lsp-server[all]" jedi-language-server'
   end

   functions -e _usage_ve
   return 0

end
