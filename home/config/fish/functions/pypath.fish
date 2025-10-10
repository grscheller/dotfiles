function pypath --description 'manage $PYTHONPATH env variable'
   set -f PythonPath
   for arg in $argv
      switch $arg
         case 'fp-booleans'
            set --append PythonPath ~/devel/pypi/fp/pythonic-fp-booleans/src
         case 'fp-circulararray'
            set --append PythonPath ~/devel/pypi/fp/pythonic-fp-circulararray/src
         case 'fp-containers'
            set --append PythonPath ~/devel/pypi/fp/pythonic-fp-containers/src
         case 'fp-fptools'
            set --append PythonPath ~/devel/pypi/fp/pythonic-fp-fptools/src
         case 'fp-gadgets'
            set --append PythonPath ~/devel/pypi/fp/pythonic-fp-gadgets/src
         case 'fp-homepage'
            set --append PythonPath ~/devel/pypi/fp/pythonic-fp/src
         case 'fp-iterables'
            set --append PythonPath ~/devel/pypi/fp/pythonic-fp-iterables/src
         case 'fp-queues'
            set --append PythonPath ~/devel/pypi/fp/pythonic-fp-queues/src
         case 'fp-splitends'
            set --append PythonPath ~/devel/pypi/fp/pythonic-fp-splitends/src
         case 'bm-combinatorics'
            set --append PythonPath ~/devel/pypi/bm/boring-math-combinatorics/src
         case 'bm-homepage'
            set --append PythonPath ~/devel/pypi/bm/boring-math/src
         case 'bm-number-theory'
            set --append PythonPath ~/devel/pypi/bm/boring-math-number-theory/src
         case 'bm-probability-distributions'
            set --append PythonPath ~/devel/pypi/bm/boring-math-probability-distributions/src
         case 'bm-pythagorean-triples'
            set --append PythonPath ~/devel/pypi/bm/boring-math-pythagorean-triples/src
         case 'bm-recursive-functions'
            set --append PythonPath ~/devel/pypi/bm/boring-math-recursive-functions/src
         case 'bm-special-functions'
            set --append PythonPath ~/devel/pypi/bm/boring-math-special-functions/src
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
