function pypath --description 'manage $PYTHONPATH env variable'
   set -f PythonPath
   for arg in $argv
      switch $arg
         case 'boringmath'
            set --append PythonPath ~/devel/pypi/boring-math/src
         case 'integer-math'
            set --append PythonPath ~/devel/pypi/bm/bm-integer-math/src
         case 'probability_distributions'
            set --append PythonPath ~/devel/pypi/bm/bm-probability-distributions/src
         case 'pythagorean-triples'
            set --append PythonPath ~/devel/pypi/bm/bm-pythagorean-triples/src
         case 'recursive-functions'
            set --append PythonPath ~/devel/pypi/bm/bm-recursive-functions/src
         case 'circulararray'
            set --append PythonPath ~/devel/pypi/dtools/dtools-circular-array/src
         case 'datastructures'
            set --append PythonPath ~/devel/pypi/dtools/dtools-datastructures/src
         case 'fp'
            set --append PythonPath ~/devel/pypi/dtools/dtools-fp/src
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
