function ud --description 'Jump up multiple directories, default is 1'
   if test (count $argv) -gt 1
      printf 'ud: ud only takes 0 or 1 arguments\n\n'
      return 2
   end

   # Pop up one directory for no arguments or an empty string given
   if test (count $argv) -eq 0 || test -z $argv[1]
      cd ..
      return $status
   end

   set -f target $argv[1]
   set -f cnt 1
   set -f upDir ..
   set -f maxUp (math (string split / (pwd) | count) - 1)

   # If the target given was a number, jump up that number of directories
   if string match -qr -- '^[1-9]\d*$' $target
      set maxUp (math "min($target, $maxUp)")
      while test $cnt -lt $maxUp
         set upDir ../$upDir
         set cnt (math $cnt + 1)
      end
      cd $upDir
      return $status
   end

   set -f targetsFound
   set -f targetFound ""
   set -f baseName (basename (pwd))

   # Exact match
   while test $cnt -le $maxUp
      if test -e $upDir/$target
         if test "$upDir" != ..
            set targetFound $upDir/$target
            break
         else
            if test "$target" != "$baseName"
               set targetFound $upDir/$target
               break
            end
         end
      end
      set upDir ../$upDir
      set cnt (math $cnt + 1)
   end

   # Leading match
   if test -z $targetFound
      set cnt 1
      set upDir ..

      while test $cnt -le $maxUp
         set targetsFound $upDir/$target*

         if test "$upDir" = ..
            set -l targets ()
            for trgt in $targetsFound
               if test "$trgt" != "../$baseName"
                  set targets $targets $trgt
               end
            end
            set targetsFound $targets
         end

         if test (count $targetsFound) -gt 0
            break
         end

         set upDir ../$upDir
         set cnt (math $cnt + 1)
      end

      set -l numFound (count $targetsFound)

      if test $numFound -gt 1
         # for multiple matches, randomly select one
         set -l targets (string replace -r ^(string repeat -n (math "2 + 3*($cnt - 1)") .) "" $targetsFound)
         set targetFound $upDir/$targets[(random 1 $numFound)]
      else
         if test $numFound -eq 1
            set targetFound $targetsFound
         end
      end
   end

   # Set destination directory to jump up to
   set -f destination
   if test -z "$targetFound"
      printf 'ud: "%s" not found above current directory\n\n' $target
      return 1
   end
   if test -d "$targetFound"
      set destination $targetFound
   else
      set destination (dirname $targetFound)
   end

   # Jump up or whine
   if cd $destination[1] 2>/dev/null
      return 0
   end
   printf 'ud: failed to cd to "%s"\n    for target "%s"\n\n' $destination $target
   return 3
end
