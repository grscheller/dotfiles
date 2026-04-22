function ocp --description 'octopus cp - copy one item to many locations'

   set -f item $argv[1]
   set -f dests $argv[2..]

   if test (count $item) -lt 1
      printf 'Error: No arguments give.\n' >&2
      return 1
   end

   if test (count $dests) -lt 1
      printf 'Error: No destinations give.\n' >&2
      return 1
   end

   set -f cp_flags
   if test -d $item
      set cp_flags '-r'
      if not string match -qr '/$' -- $item
         set item $item/
      end
   end

   set -f dest
   for dest in $dests
      if test -f $dest
         if test -d $item
            printf 'Error: Can not overwrite file "%s" with directory "%s".\n' $dest $item >&2
            return 1
         end
      end
      if not string match -qr '/$' -- $dest
         if test -d $dest
            printf 'Error: Trying to copy to a directory without explicitely\n' >&2
            printf '       indicating a trailing "/".\n' >&2
            return 1
         end
      end
      if string match -qr '/$' -- $dest
         if not test -d $dest
            mkdir -p $dest
         end
         echo got to 1
      else
         mkdir -p (dirname $dest)
         echo got to 2
      end
   end

   for dest in $dests
      if not test "$item" -ef  "$dest"
         cp $cp_flags $item $dest
      end
   end

end
