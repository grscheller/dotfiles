function ve --description 'Instantiate or configure a Python virtual env'

   # Python virtual environment configurations
   set modules_devel \
      ipython                  \
      pytest                   \
      pdoc3                    \
      flit                     \
      "python-lsp-server[all]" \
      jedi-language-server    
   
   set modules_grs \
      ipython                   \
      fonttools                 \
      grscheller.circular-array \
      grscheller.datastructures \
      grscheller.boring-math    \
      'python-lsp-server[all]'  \
      jedi-language-server

   set modules_jupiter_learn \
      jupyterlab

   set 

   modules_jupiter_learn
   
   # Python base environment configuration

   # Provide override mechanism to usual virtual env location
   if not set -q PYTHON_GRS_ENVS
      set -g PYTHON_GRS_ENVS ~/devel/python_envs/
   end
   test -d "$PYTHON_GRS_ENVS" || mkdir -p "$PYTHON_GRS_ENVS"

   # usage function: fish functions have global scope - will need removing
   function _usage_ve
      printf 'Usage: ve\n'
      printf '       ve <virtenv>\n'
      printf '       ve [-c | --clear]\n'
      printf '       ve [-r | --redo]\n'
      printf '       ve [-h | --help]\n\n'
   end

   # Parse cmdline options
   argparse -n 've' c/clear r/redo h/help -- $argv

   # if user gave a help option, show usage and quit
   if set -q _flag_help
      _usage_ve
      functions -e _usage_ve
      return 1
   end

   # what is left after option parsing
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
      set -ge PYTHON_GRS_ENV
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

      # Semantic parsing - edit here for new managed environments
      switch $veName
      case grs devel jupyter_learn neovim pypy py4ai
         set python_env $PYTHON_GRS_ENVS/$veName
         set pythonVersion '3.11.8'             # current arch system python
      case devNext pypi3_12_1                                        # tests
         set python_env $PYTHON_GRS_ENVS/$veName[1]
         set pythonVersion '3.12.2'
      case '*'
         set fmt 've: Untracked Python virtual environment: %s\n'
         printf $fmt $argv[1]
         set python_env $PYTHON_GRS_ENVS/$veName
      end

      # Check if virtual env exists in the canonical location
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

   # Manage the current virtual environment

   # Sanity/consistency checks
   if not set -q PYTHON_GRS_ENV
      printf 'Not in a ve managed Python virtual environment.\n'
      printf 'Possibly venv manually invoked?\n\n'
      functions -e _usage_ve
      return 1
   else if not test -e "$PYTHON_GRS_ENV/bin/python"
      set fmt 'No python executable found in the "%s" venv.\n'
      printf $fmt $PYTHON_GRS_ENV
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
   if set -q _flag_clear
      printf 'option '-c' given\n'
# p3_11clr 'pip uninstall -y (pip list|tail +3|fields 1|grep -Ev "(pip|setuptools)")'
# p3_12clr 'pip uninstall -y (pip list|tail +3|fields 1|grep -Ev "(pip)")'
   end

   if set -q _flag_redo
      printf 'option '-r' given\n'
# vdredo 'pip install --upgrade ipython pytest pdoc3 flit "python-lsp-server[all]" jedi-language-server'
# vgredo 'pip install --upgrade ipython fonttools grscheller.circular-array grscheller.datastructures grscheller.boring-math "python-lsp-server[all]" jedi-language-server'
# vjredo 'pip install --upgrade jupyterlab'
# vnredo 'pip install --upgrade neovim pynvim mypy ruff black'
# vpredo 'pip install --upgrade ipython pytest'
   end
         
end
