function dn --description 'Jump down directory tree to find an item'

   if test (count $argv) -ne 1 
      printf 'dn: dn takes exactly one argument' >&2
      return 1
   end

   set -l pat $argv[1]

   # Jump to first target in current directory which *pat or *pat* matches
   set -l targets $pat*
   for target in $targets
      if test -d "$target"
         cd $target
         return 0
      end
   end

   set -l targets *$pat*
   for target in $targets
      if test -d "$target"
         cd $target
         return 0
      end
   end

   # Now lets dig down some more
   set -l found **/$pat
   set -l cnt (count $found)
   if test "$cnt" -eq 0
      set found **/$pat*
      set cnt (count $found)
      if test "$cnt" -eq 0
         set found **/*$pat*
         set cnt (count $found)
         if test "$cnt" -eq 0
            printf 'dn: pattern "%s" not found in any subdirectory' $pat >&2
            return 1
         end
      end
   end

   # Jump to last target found by the glob (will tend to be less deep)
   set target $found[-1]
   if test -d "$target"
      cd $target
   else
      cd (dirname $target)
   end
end
