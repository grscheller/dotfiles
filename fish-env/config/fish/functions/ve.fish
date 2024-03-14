## Switch Python virtual environments
#
# Even though Python virtual environments know the location of the version
# of Python they need, My Neovim configuration needs access to Python tools
# installed into a Python's virtual environment. Usually due to the tool not
# being managed by the Linux distribution's package manager system.
#
# To simply my Neovim configuration, the Lua variable vim.g.python3_host_prog
# is set to the pyenv managed Python ~/.local/share/pyenv/shims/python and no
# attempt is made to 
#
# As a result, I need to ensure the vir
#
function ve --description 'Switch Python Virtual environments'
   # Sanity check and setup if needed
   if not set -q PYTHON_GRS_ENVS
      set PYTHON_GRS_ENVS ~/devel/python_envs/
   end
   test -d $PYTHON_GRS_ENVS || mkdir -p $PYTHON_GRS_ENVS

   # argment parsing
   set veName $argv
   if test (count $veName) -ge 1
      set veName $veName[1]
      switch $veName
      case grs devel neovim pypy
         :
      case 'pypi*'
         set veName pypi3_12_1
      case jupyter_learn
         :
      case '*'
         set fmt 'Warning: Untracked Python virtual environment: %s\n'
         printf $fmt $argv[1] >&2
      end
   else
      set veName ''
   end

   if test -n $veName && not test -e $PYTHON_GRS_ENVS/$veName/bin/activate.fish
      set fmt 'Info: No venv "%s" found in $PYTHON_GRS_ENVS: %s\n'
      printf $fmt $veName "$PYTHON_GRS_ENVS" >&2
      return 1
   end

   # Deactivate Python virtual environment if no arguments given
   if test -z $veName[1]
      type -q deactivate && deactivate
      set fmt 'No Python venv in use, using %s\n'
      printf $fmt (python --version)
      return 0
   end

   # Activate Python virtual environment
   source $PYTHON_GRS_ENVS/$veName/bin/activate.fish

   return 0
end
