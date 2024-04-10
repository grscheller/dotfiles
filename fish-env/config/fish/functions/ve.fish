function ve --description 'Instantiate or configure a Python virtual env'

   ## Provide an override mechanism to usual virtual env location
   if not set -q PYTHON_GRS_VENVS
      set -gx PYTHON_GRS_VENVS ~/devel/python_venvs/
   end
   set venvs_conf $PYTHON_GRS_VENVS/venvs.conf

   ## Read in the venv configuration file
   if test -f $venvs_conf
      source $venvs_conf
   else
      set fmt 'Virtual environment config file: %s,\nwas not found.'
      printf $fmt $venvs_conf
      return 1
   end

   ## Usage function
   #    note: Fish functions have global scope and will
   #          need to be erased before the ve function ends.
   function _usage_ve
      printf 'Usage: ve\n'
      printf '       ve <virtenv>\n'
      printf '       ve [-c | --clear]\n'
      printf '       ve [-r | --redo]\n'
      printf '       ve [-h | --help]\n\n'
   end

   ## Parse cmdline options
   argparse -n 've' c/clear r/redo h/help -- $argv
   or begin
      _usage_ve
      functions -e _usage_ve
      return 1
   end


   # if user gave a help option, show usage and quit
   if set -q _flag_help
      _usage_ve
      functions -e _usage_ve
      return 1
   end

   ## 
   set argc (count $argv)
   set arg1 $argv[1]

   if set -q _flag_clear || set -q _flag_redo
      set flag_given
      if test $argc -gt 0
         printf 've: invalid argument/option combination\n'
         _usage_ve
         functions -e _usage_ve
         return 1
      end
   end

   if test $argc -eq 0 && not set -q flag_given
      # deactivate current virtual env if we are in one
      type -q deactivate && deactivate
      set fmt 'No Python venv in use, using python version: %s\n\n'
      printf $fmt (python --version)
      set -ge PYTHON_GRS_VENV
      functions -e _usage_ve
      return 0
   end

   if not set -q flag_given && test $argc -gt 1
      printf 've: invalid argument/option combination\n'
      _usage_ve
      functions -e _usage_ve
      return 1
   else if not set -q flag_given
      set veName $arg1

      # See if $veName is one of our manage versions of Python
      set -e managed
      for ve in $vert_venvs
         if test "$ve" = "$veName"
            set managed
            break
         end
      end

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

      set python_venv $PYTHON_GRS_VENVS/$veName

      # Check if virtual env exists in the canonical location
      if not test -e "$python_venv/bin/activate.fish"
         set fmt 'Info: No venv "%s" found in $PYTHON_GRS_VENVS: %s\n\n'
         printf $fmt $veName $PYTHON_GRS_VENVS
         functions -e _usage_ve
         return 1
      end

      ## Activate Python virtual environment and exit
      set -gx PYTHON_GRS_VENV $python_venv
      source $PYTHON_GRS_VENV/bin/activate.fish
      functions -e _usage_ve
      return 0
   end

   ## Manage the current virtual environment

   # Sanity check - if we got here, a valid option was given
   if not set -q _flag_clear && not set -q _flag_redo
      set fmt 've: check ve.fish script, neither %s nor %s were set'
      printf $fmt _flag_clear _flag_redo
      functions -e _usage_ve
      return 1
   end
   
   # Make sure $PYTHON_GRS_VENV/bin/python is the python on the $PATH
   if not set -q PYTHON_GRS_VENV
      printf 'Not in a ve managed Python virtual environment.\n'
      printf 'Possibly venv manually invoked?\n\n'
      functions -e _usage_ve
      return 1
   else if not test -e "$PYTHON_GRS_VENV/bin/python"
      set fmt 'No python executable found in the "%s" venv.\n'
      printf $fmt $PYTHON_GRS_VENV
   else if digpath -q python
      set pyVers (string split -f 2 ' ' (python --version))
   else
      set fmt 'A python executable was not found on $PATH, yet $PYTHON_GRS_VENV = %s\n'
      printf $fmt $PYTHON_GRS_VENV
      functions -e _usage_ve
      return 1
   end

   # Make sure we are using the correct version of Python
   set pythonPath (which python)
   set pythonVe $PYTHON_GRS_VENV/bin/python
   if test "$pythonPath" = "$pythonVe"
      set pythonVersion $pyVers[1]
      set pypyVer pyVers[2]
      set veName (string replace -r '^.*/' '' $PYTHON_GRS_VENV)
   else
      set fmt 'First python found on $PATH, %s,\nis not %s.\n\n'
      printf $fmt $pythonPath $PythonVe
      functions -e _usage_ve
      return 1
   end

   # See if $veName is one of our manage versions of Python
   set -e managed
   for ve in $vert_venvs
      if test "$ve" = "$veName"
         set managed
         break
      end
   end

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
         printf $fmt $versionExpected $veName $pythonVersion
         read --nchars 1 --prompt-str 'Proceed [Y or N]? ' ans
         if test $ans != Y
            functions -e _usage_ve
            return 1
         end
      end
   end

   ## Perform option actions
   if set -q _flag_clear
      printf 'option '-c' given\n'
   # p3_11clr 'pip uninstall -y (pip list|tail +3|fields 1|grep -Ev "(pip|setuptools)")'
   # p3_12clr 'pip uninstall -y (pip list|tail +3|fields 1|grep -Ev "(pip)")'
   end

   if set -q _flag_redo
      printf 'option '-r' given\n'
   # vdredo 'pip install --upgrade ipython pytest pdoc3 flit "python-lsp-server[all]" jedi-language-server'
   end

end
