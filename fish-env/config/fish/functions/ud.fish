function ud --description 'Jump up multiple directories, default is 1'
   set -f upDir ..
   set -f maxUp (math (string split / (pwd) | count) - 1)
   set -f nDirs
   set -f target ''

   set -f argc (count $argv)

   if test (count $argv) -gt 1 
      printf 'ud: ud only takes 0 or 1 arguments' >&2
      return 2
   end

   if test $argc -eq 0
      cd ..
      return $status
   end
      
   if string match -qr -- '^[1-9]\d*$' $argv[1]
      # If argument is a number, jump up that number number of directories
      set nDirs $argv[1]
      test $nDirs -gt $maxUp && set nDirs $maxUp
   else
      # Otherwise set nDirs to $maxUp and set target to first argument.
      set nDirs $maxUp
      set target $argv[1]
   end

   set -f cnt 1
   if test -z "$target"
      # Setup number of directories to jump if no target given
      while test $cnt -lt $nDirs
         set upDir ../$upDir
         set cnt (math $cnt + 1)
      end
   else
      # First look for exact match.
      while test $cnt -le $nDirs
         test -e "$upDir/$target" && break
         set upDir ../$upDir
         set cnt (math $cnt + 1)
      end
      # Next look for leading string match, select first one found.
      set cnt 1
      set upDir ..
      set -f targetsFound
      set -f upDirPat
      while test $cnt -le $maxUp
         if test (count $upDir/$target*) -gt 0
            set targetsFound $upDir/$target*
            set target $targetsFound[1]
            set upDirPat (string replace -a '.' '\\.' $upDir)
            set target (string replace -r $upDirPat/ '' $target)
            break
         end
         set upDir ../$upDir
         set cnt (math $cnt + 1)
      end
   end

   set -f destination
   set -f targetDest $upDir/$target
   if test ! -e "$targetDest"
      printf 'ud: "%s" not found in any higher directory\n' $target >&2
      return 1
   else if test -d "$targetDest"
      set destination $targetDest
   else
      set destination (dirname $targetDest)
   end

   if cd $destination 2>/dev/null
      return 0
   else
      printf 'ud: failed to cd to "%s"\n    for target "%s"\n' $destination $target >&2
      return 3
   end
end
