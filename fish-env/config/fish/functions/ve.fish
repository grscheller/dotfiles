function ve --description 'Instantiate or configure a Python virtual env'

   # Provide override mechanism to usual virtual env location
   if not set -q PYTHON_GRS_ENVS
      set -g PYTHON_GRS_ENVS ~/devel/python_envs/
   end
   test -d $PYTHON_GRS_ENVS || mkdir -p $PYTHON_GRS_ENVS

   # Parse commandline
   set argc (count $argv)
   set arg1 $argv[1]

   if test $argc -gt 1 -o $arg1 = '-h' -o $arg1 = '--help'
      printf 'Error: invalid arguments\n\n'
      printf 'Usage: ve [veName]\n'
      printf '       ve [-c | --clear]\n'
      printf '       ve [-r | --redo]\n'
      printf '       ve [-h | --help]\n\n'
      return 1
   end

   if test $argc -eq 0
      # deactivate current virtual env if we are in one
      type -q deactivate && deactivate
      set fmt 'No Python venv in use, using python version %s\n'
      printf $fmt (python --version)
      return 0
   end

   set -e optRedo optClear
   switch $argv[1]
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
         set python_env $PYTHON_GRS_ENVS/$veName
         set pythonVersion '3.11.8'             # current arch system python
      case devNext pypi3_12_1                                        # tests
         set python_env $PYTHON_GRS_ENVS/$veName
         set pythonVersion '3.12.2'
      case '*'
         set fmt 'Warning: Untracked Python virtual environment: %s\n'
         printf $fmt $argv[1] >&2
         set python_env $PYTHON_GRS_ENVS/$veName
      end

      # Check if virtual env actually exists
      if test -n $veName && not test -e $python_env/bin/activate.fish
         set fmt 'Info: No venv "%s" found in $PYTHON_GRS_ENVS: %s\n'
         printf $fmt $veName $PYTHON_GRS_ENVS >&2
         return 1
      end

      # Activate Python virtual environment
      set -gx PYTHON_GRS_ENV $python_env
      source $PYTHON_GRS_ENV/bin/activate.fish
      return 0
   end

   ## Manage the current virtual environment

   # Sanity checks
   if not set -q PYTHON_GRS_ENV
      printf 'Not in a ve managed Python virtual environment.\n'
      return 1
   end

   if digpath -q python
      set pyVers (string split -f 2 ' ' (python --version))
   else
      set msg 'Python executable not found, yet $PYTHON_GRS_ENV = %s\n'
      printf $msg $PYTHON_GRS_ENV
      return 1
   end

   set pythonPath (which python)
   set pythonVe $PYTHON_GRS_ENV/bin/python
   if test $pythonPath = $pythonVe
      set pythonVer pyVers[1]
      set pypyVer pyVers[2]
      set veName (string replace -r '^.*/' '' $PYTHON_GRS_ENV)
   else
      set msg 'Python found on $PATH, %s, is not %s./n'
      printf $msg $pythonPath $PythonVe
      return 1
   end

   # Consistency checks

   # Parse commandline arguments
   set opt $argv[1]
   switch $opt
      case -c --clear
         printf 'option %s given\n' $opt
      case -r --redo
         printf 'option %s given\n' $opt
      case '*'
         printf 'Unknown option: %s\n' $opt
         return 1
   end
         
end
