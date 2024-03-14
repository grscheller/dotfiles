function vinst --description 'install/upgrade python packages'
   set PythonPackages \
      pip \
      setuptools \
      flit \
      fonttools \
      grscheller.datastructures \
      ipython \
      pdoc3 \
      pynvim \
      pyright \
      pytest

   set -q VIRTUAL_ENV
   or begin
      printf 'Punting: not in a Python virtual environment' >&2
      return 1
   end

   test -f $VIRTUAL_ENV/bin/activate
   or begin
      set msg 'does not point to a valid Python virtual environment'
      printf 'Punting: %s %s' $VIRTUAL_ENV[1] $msg >&2
      return 2
   end

   pip install --upgrade $PythonPackages
end
