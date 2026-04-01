function pp --description "manage $PYTHONPATH env variable"

   set -f bm_names \
      bm-abstract-algebra \
      bm-combinatorics \
      bm-number-theory \
      bm-probability-distributions \
      bm-pythagorean-triples \
      bm-recursive-functions \
      bm-special-functions \
      bm-homepage

   set -f bm_locations \
      ~/devel/pypi/bm/boring-math-abstract-algebra/src \
      ~/devel/pypi/bm/boring-math-combinatorics/src \
      ~/devel/pypi/bm/boring-math-number-theory/src \
      ~/devel/pypi/bm/boring-math-probability-distributions/src \
      ~/devel/pypi/bm/boring-math-pythagorean-triples/src \
      ~/devel/pypi/bm/boring-math-recursive-functions/src \
      ~/devel/pypi/bm/boring-math-special-functions/src \
      ~/devel/pypi/bm/boring-math/src

   set -f fp_names \
      fp-booleans \
      fp-circulararray \
      fp-containers \
      fp-fptools \
      fp-gadgets \
      fp-iterables \
      fp-numpy \
      fp-queues \
      fp-splitends \
      fp-homepage

   set -f fp_locations \
      ~/devel/pypi/fp/pythonic-fp-booleans/src \
      ~/devel/pypi/fp/pythonic-fp-circulararray/src \
      ~/devel/pypi/fp/pythonic-fp-containers/src \
      ~/devel/pypi/fp/pythonic-fp-fptools/src \
      ~/devel/pypi/fp/pythonic-fp-gadgets/src \
      ~/devel/pypi/fp/pythonic-fp-iterables/src \
      ~/devel/pypi/fp/pythonic-fp-numpy/src \
      ~/devel/pypi/fp/pythonic-fp-queues/src \
      ~/devel/pypi/fp/pythonic-fp-splitends/src \
      ~/devel/pypi/fp/pythonic-fp/src

   set -g _names_pp $bm_names $fp_names
   set -g _locations_pp $bm_locations $fp_locations
   set -g _PythonPath_pp

   function _usage
      set -f fmt '\nUsage: pp [-f | --fp] [-b | --bm] pp [-h | --help] [venv1 [venv2 ...]]\n\n'
      printf $fmt
   end

   function _cleanup
      set -e _names_pp _locations_pp _PythonPath_pp
      functions -e _add_location _usage _cleanup 
   end

   if not argparse -n pp b/bm f/fp h/help -- $argv
      _usage
      _cleanup
      return 1
   end

   if set -q _flag_help
      _usage
      _cleanup
      return 0
   end

   if set -q _flag_bm
      set --append _PythonPath_pp $bm_locations
   end

   if set -q _flag_fp
      set --append _PythonPath_pp $fp_locations
   end

   set -f pypi_projects_names $argv

   for name in $pypi_projects_names
      if contains $name $_names_pp
         set -l location $_locations_pp[(contains -i $name $_names_pp)]
         if not contains $location $_PythonPath_pp
            set --global --append _PythonPath_pp $location
         end
      else
         printf 'pp: Unknown managed PyPI package %s\n' $name
         _cleanup
         return 1
      end
   end

   if test (count $_PythonPath_pp) -gt 0
      set -gx PYTHONPATH $_PythonPath_pp
      printf '$PYTHONPATH exported & set to:\n  '
      string join \n'  ' $PYTHONPATH
   else
      set -e PYTHONPATH
      printf '$PYTHONPATH removed.\n'
   end

   _cleanup
   return 0
end
