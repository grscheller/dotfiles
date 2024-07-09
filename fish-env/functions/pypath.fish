function pypath --description 'manage $PYTHONPATH env variable'
   set -e PYTHONPATH
   set -l PythonPath
   for arg in $argv
      switch $arg
         case 'ai'
            set --append PythonPath ~/devel/courses/udacity/ai/courses-distributions/src
         case 'boringmath'
            set --append PythonPath ~/devel/pypi/boring-math/src
         case 'circulararray'
            set --append PythonPath ~/devel/pypi/circular-array/src
         case 'datastructures'
            set --append PythonPath ~/devel/pypi/datastructures/src
         case 'fp'
            set --append PythonPath ~/devel/pypi/fp/src
      end
   end
   if test (count $PythonPath) -gt 0
      set -gx PYTHONPATH $PythonPath
      printf 'Set $PYTHONPATH to %s\n' (string join : $PYTHONPATH)
   else
      printf 'Removed $PYTHONPATH\n'
   end
end
