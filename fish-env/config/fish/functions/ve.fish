function ve --description 'Instantiate or configure a Python virtual env'

   # Provide override mechanism to usual virtual env location
   if not set -q PYTHON_GRS_ENVS
      set -g PYTHON_GRS_ENVS ~/devel/python_envs/
   end
   test -d "$PYTHON_GRS_ENVS" || mkdir -p "$PYTHON_GRS_ENVS"

   # DRY utility function: fish functions have global scope - will need removing
   function _usage_ve
      printf 'Usage: ve\n'
      printf '       ve <virtenv>\n'
      printf '       ve [-c | --clear]\n'
      printf '       ve [-r | --redo]\n'
      printf '       ve [-h | --help]\n\n'
   end

   # Parse commandline
   set argc (count $argv)
   set arg1 $argv[1]

   if test $argc -gt 1 || test "$arg1" = "-h" || test "$arg1" = "--help"
      _usage_ve
      functions -e _usage_ve
      return 1
   end

   if test $argc -eq 0
      # deactivate current virtual env if we are in one
      type -q deactivate && deactivate
      set fmt 'No Python venv in use, using python version: %s\n\n'
      printf $fmt (python --version)
      set -ge PYTHON_GRS_ENV
      functions -e _usage_ve
      return 0
   end

   set -e optRedo optClear
   switch $arg1
      case -c --clear 
         set optClear
      case -r --redo
         set optRedo
      case '*'
         set veName $arg1
   end

   # Semantic parsing - edit here for new managed environments
   set -e pythonVersion python_env
   if set -q optClear || set -q optRedo
      :
   else
      switch $veName
      case grs devel jupyter_learn neovim pypy py4ai
         set python_env $PYTHON_GRS_ENVS/$veName[1]
         set pythonVersion '3.11.8'             # current arch system python
      case devNext pypi3_12_1                                        # tests
         set python_env $PYTHON_GRS_ENVS/$veName[1]
         set pythonVersion '3.12.2'
      case '*'
         if string match -q -r -- '-.*' $arg1
            printf 'Error: invalid argument or option\n'
            _usage_ve
            functions -e _usage_ve
            return 1
         end
         set fmt 'Warning: Untracked Python virtual environment: %s\n'
         printf $fmt $argv[1]
         set python_env $PYTHON_GRS_ENVS/$veName
      end

      # Check if virtual env actually exists
      if not test -e "$python_env/bin/activate.fish"
         set fmt 'Info: No venv "%s" found in $PYTHON_GRS_ENVS: %s\n\n'
         printf $fmt $veName $PYTHON_GRS_ENVS
         functions -e _usage_ve
         return 1
      end

      # Activate Python virtual environment
      set -gx PYTHON_GRS_ENV $python_env
      source $PYTHON_GRS_ENV/bin/activate.fish
      functions -e _usage_ve
      return 0
   end

   ## Manage the current virtual environment

   # Sanity/consistency checks
   if not set -q PYTHON_GRS_ENV
      printf 'Not in a ve managed Python virtual environment.\n'
      printf 'Possibly venv manually invoked?\n\n'
      functions -e _usage_ve
      return 1
   else if not test -e "$PYTHON_GRS_ENV/bin/python"
      printf 'No python executable found in the "%s" venv.\n' $PYTHON_GRS_ENV
   else if digpath -q python
      set pyVers (string split -f 2 ' ' (python --version))
   else
      set fmt 'Python executable not on $PATH, yet $PYTHON_GRS_ENV = %s\n'
      printf $fmt $PYTHON_GRS_ENV
      functions -e _usage_ve
      return 1
   end

   set pythonPath (which python)
   set pythonVe $PYTHON_GRS_ENV/bin/python
   if test "$pythonPath" = "$pythonVe"
      set pythonVer pyVers[1]
      set pypyVer pyVers[2]
      set veName (string replace -r '^.*/' '' $PYTHON_GRS_ENV)
   else
      set fmt 'First python found on $PATH, %s,\nis not %s.\n\n'
      printf $fmt $pythonPath $PythonVe
      functions -e _usage_ve
      return 1
   end

   # Perform option actions
   if set -q optClear
      printf 'option '-c' given\n'
   end

   if set -q optRedo
      printf 'option '-r' given\n'
   end
         
end
