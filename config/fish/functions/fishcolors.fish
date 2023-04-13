function fishcolors --description 'Show colors used by fish'
   set -l color_vars (set -n|grep 'fish.*color'|grep -v '^_')
   for var in $color_vars
      printf '| %-40s | %-40s |\n' $var $$var
   end
end
