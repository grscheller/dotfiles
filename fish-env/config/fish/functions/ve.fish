function ve --description 'Instantiate or configure a Python virtual env'

   # Provide an override mechanism to usual virtual env location
   if not set -q PYTHON_GRS_VENVS
      set --global --export PYTHON_GRS_VENVS ~/devel/python_venvs/
   end
   set ve_conf $PYTHON_GRS_VENVS/ve.conf

   # Sourcw in the venv configuration file
   if test -f $ve_conf
      source $ve_conf
   else
      set fmt 'Virtual environment config file: %s,\nwas not found.'
      printf $fmt $ve_conf
      return 1
   end

   # Usage function
   #   note: Fish functions have global scope and will
   #         need to be erased before the ve function ends.
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

   # Try deactivating any venv if no arguments or options given
   if test $argc -eq 0 && test not set -q flag_cr
      # deactivate current virtual env if we are in one
      type -q deactivate && deactivate
      set fmt 'No Python venv in use, using python version: %s\n\n'
      printf $fmt (python --version)
      set --global --erase PYTHON_GRS_VENV
      functions -e _usage_ve
      return 1
   end

   # Get the virtual environment name from user or grok from environment
   set --erase veName flag_punt flag_managed

   if test $argc -eq 1
      set veName $argv[1]
   else if not set -q PYTHON_GRS_VENV
      # Give feedback, shutdown any running venv, error out 
      printf 'Not in a ve managed Python virtual environment.\n'
      printf 'Possibly venv manually invoked?\n\n'
      printf 'Shutting down any active virtual environment.\n'
      type -q deactivate && deactivate
      set fmt 'No Python venv in use, using python version: %s\n\n'
      printf $fmt (python --version)
      set --global --erase PYTHON_GRS_VENV
      functions -e _usage_ve
      return 1
   else
      # Perform consistency checks and reverse engineer venv name
      set pythonFromPath (realpath(which python))
      set pythonFromVE (realpath($PYTHON_GRS_VENV/bin/python))
      if test (count $pythonFromPath) -gt 0 && test (count $pythonFromVE) -gt 0
         if test "$pythonFromPath" = "$pythonFromVE"
            set pyVers (string split -f 2 ' ' (python --version))
            set pythonVersion $pyVers[1]
            set veName (string replace -r '^.*/' '' $PYTHON_GRS_VENV)
         else
            set flag_punt
         end
      else
         set flag_punt
      end
   end

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

   # Give user option to punt if not in a manage environment
   if not set -q flag_managed
      set fmt 'virtual env: %s is not one of our managed ones.\n'
      printf $fmt $veName
      read --nchars 1 --prompt-str 'Proceed [Y or N]? ' ans
      if test $ans != Y
         set flag_punt
      end
   end

   if set -q flag_punt
      functions -e _usage_ve
      return 1
   end

   if not set -q flag_cr
      set python_venv $PYTHON_GRS_VENVS/$veName

      # If venv does not exists in the canonical location, then punt.
      if not test -e "$python_venv/bin/activate.fish"
         set fmt 'Virtual env "%s" not found in $PYTHON_GRS_VENVS: %s\n\n'
         printf $fmt $veName $PYTHON_GRS_VENVS
         set --global --erase PYTHON_GRS_VENV
         functions -e _usage_ve
         return 1
      end

      ## Activate Python virtual environment and exit
      functions -e _usage_ve
      set --global --export PYTHON_GRS_VENV $python_venv
      source $PYTHON_GRS_VENV/bin/activate.fish
      return 0
   end

   ## Manage the current virtual environment

   # Make sure we are using the correct version of Python





   # Give user option to punt if not a manage environment
   if not set -q managed
      set fmt 'virtual env: %s is not one of our managed ones\n'
      printf $fmt $veName
      read --nchars 1 --prompt-str 'Proceed [Y or N]? ' ans
      if test $ans != Y
         functions -e _usage_ve
         return 1
      end
   end

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

   ## Perform option actions
   if set -q _flag_clear
      if set -q managed
         switch $pythonVersion
         case '3.11.*'
            echo clean 11: got $pythonVersion
         case '3.12.*'
            echo clean 12: got $pythonVersion
         end
      else
         fmt = 'Punting: %s is not a managed version\n\n'
         print $fmt $veName
      end

   # p3_11clr 'pip uninstall -y (pip list|tail +3|fields 1|grep -Ev "(pip|setuptools)")'
   # p3_12clr 'pip uninstall -y (pip list|tail +3|fields 1|grep -Ev "(pip)")'
   end

   if set -q _flag_redo
      if set -q managed
         switch $pythonVersion
         case '3.11.*'
            echo redo 11: got $pythonVersion
         case '3.12.*'
            echo redo 12: got $pythonVersion
         end
      else
         fmt = 'Punting: %s is not a managed version\n\n'
         print $fmt $veName
      end

   # vdredo 'pip install --upgrade ipython pytest pdoc3 flit "python-lsp-server[all]" jedi-language-server'
   end

   functions -e _usage_ve
   return 9

end
