function pypath --description 'manage $PYTHONPATH env variable'
   set -f PythonPath
   for arg in $argv
      switch $arg
         case 'bm-integer-math'
            set --append PythonPath ~/devel/pypi/bm/bm-integer-math/src
         case 'bm-probability-distributions'
            set --append PythonPath ~/devel/pypi/bm/bm-probability-distributions/src
         case 'bm-pythagorean-triples'
            set --append PythonPath ~/devel/pypi/bm/bm-pythagorean-triples/src
         case 'bm-recursive-functions'
            set --append PythonPath ~/devel/pypi/bm/bm-recursive-functions/src
         case 'dtools-circulararray'
            set --append PythonPath ~/devel/pypi/dtools/dtools-circular-array/src
         case 'dtools-containers'
            set --append PythonPath ~/devel/pypi/dtools/dtools-containers/src
         case 'dtools-fp'
            set --append PythonPath ~/devel/pypi/dtools/dtools-fp/src
         case 'dtools-iterables'
            set --append PythonPath ~/devel/pypi/dtools/dtools-iterables/src
         case 'dtools-splitends'
            set --append PythonPath ~/devel/pypi/dtools/dtools-splitends/src
         case 'dtools-queues'
            set --append PythonPath ~/devel/pypi/dtools/dtools-queues/src
         case 'pythonic-fp-credits'
            set --append PythonPath ~/devel/pypi/fptools/pythonic-fp/src
         case 'pythonic-fp-circulararray'
            set --append PythonPath ~/devel/pypi/fptools/pythonic-fp-circulararray/src
         case '*'
            printf 'Unkown Python package %s\n' $arg
            return 1
      end
   end
   if test (count $PythonPath) -gt 0
      set -gx PYTHONPATH $PythonPath
      printf '$PYTHONPATH exported & set to:\n%s\n' (string join : $PYTHONPATH)
   else
      set -e PYTHONPATH
      printf '$PYTHONPATH removed\n'
   end
end
