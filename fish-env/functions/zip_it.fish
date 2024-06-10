function zip_it --description 'Print 2 arrays zipped together with separator'

   set -f dollar '$'
   set -f sep ' '

   if argparse s/sep= -- $argv
      set -q sep _flag_sep
      and set sep $_flag_sep
   else
      return
   end

   # For this to work, both arrays need to be in global scope
   set arr_name_1 $argv[1]
   set arr_name_2 $argv[2]

   eval set -f arr1 {$dollar}$arr_name_1
   eval set -f arr2 {$dollar}$arr_name_2

   set -l len1 (count $arr1)
   set -l len2 (count $arr2)
   if test "$len1" -lt "$len2"
      set -f len $len1
   else
      set -f len $len2
   end

   for ii in (seq $len)
      printf '%s%s%s\n' $arr1[$ii] $sep $arr2[$ii]
   end

end

