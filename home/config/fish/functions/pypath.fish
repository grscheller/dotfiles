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
         case 'pythonic-fp-circulararray'
            set --append PythonPath ~/devel/pypi/fp/pythonic-fp-circulararray/src
         case 'pythonic-fp-containers'
            set --append PythonPath ~/devel/pypi/fp/pythonic-fp-containers/src
         case 'pythonic-fp-fptools'
            set --append PythonPath ~/devel/pypi/fp/pythonic-fp-fptools/src
         case 'pythonic-fp-iterables'
            set --append PythonPath ~/devel/pypi/fp/pythonic-fp-iterables/src
         case 'pythonic-fp-queues'
            set --append PythonPath ~/devel/pypi/fp/pythonic-fp-queues/src
         case 'pythonic-fp-singletons'
            set --append PythonPath ~/devel/pypi/fp/pythonic-fp-singletons/src
         case 'pythonic-fp-splitends'
            set --append PythonPath ~/devel/pypi/fp/pythonic-fp-splitends/src
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
