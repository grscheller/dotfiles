function dn --description 'Jump down directory tree to find an item'

   if test (count $argv) -ne 1 
      printf 'dn: dn only takes exactly one argument' >&2
      return 1
   end

   set -l pat $argv[1]
   set -l found **/$pat*
   set -l cnt (count $found)
   if test "$cnt" -eq 0
      printf 'dn: pattern "%s" not found in any subdirectory' $pat >&2
      return 1
   end

   set target $found[1]
   if test -d "$target"
      cd $target
   else
      cd (dirname $target)
   end
end
