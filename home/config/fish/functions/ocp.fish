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
   end

   for dest in $dests
      if test -f $dest
         if test -d $item
            printf 'Error: Can not overwrite file "%s" with directory "%s".\n' $dest $item >&2
            printf 'Abort!\n'
            return 1
         end
      end
   end

   for dest in $dests
      if test ! -d (dirname $dest)
         mkdir -p (dirname $dest)
      end
   end

   for dest in $dests
      cp $cp_flags $item $dest
   end

end
