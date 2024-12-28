function pypath --description 'manage $PYTHONPATH env variable'
   set -f PythonPath
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
         case 'experimental'
            set --append PythonPath ~/devel/pypi/experimental/src
         case 'fp'
            set --append PythonPath ~/devel/pypi/fp/src
         case '*'
            printf 'Unkown Python package %s\n' $arg
            return 1
      end
   end
   if test (count $PythonPath) -gt 0
      set -gx PYTHONPATH $PythonPath
      printf '$PYTHONPATH set to %s\n' (string join : $PYTHONPATH)
   else
      set -e PYTHONPATH
      printf '$PYTHONPATH removed\n'
   end
end
