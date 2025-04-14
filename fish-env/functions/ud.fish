function ud --description 'Jump up multiple directories, default is 1'
   if test (count $argv) -gt 1
      printf 'ud: ud only takes 0 or 1 arguments\n\n'
      return 2
   end

   # Pop up one directory if no arguments, or an empty string, was given
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

   # First look for an exact match
   while test $cnt -le $maxUp
      if test -e $upDir/$target
         if test "$upDir" = ".."
            if test "$target" = "$baseName"
               # don't find current directory
               set upDir ../$upDir
               set cnt (math $cnt + 1)
               continue
            end
         end
         set targetFound $upDir/$target
         echo got to 3: $targetFound
         break
      end
      set upDir ../$upDir
      set cnt (math $cnt + 1)
   end

   echo got to 4: $targetFound

   # Next check in case a quoted glob pattern was given
   if test -z $targetFound
      set cnt 1
      set upDir ..
      while test $cnt -le $maxUp
         eval set targetsFound $upDir/$target
         if test (count $targetsFound) -gt 0
            if test (count $targetsFound) -eq 1
               set targetFound $targetsFound
               break
            end
            # for multiple matches, randomly select one
            set targets (string replace -r ^(string repeat -n (math "2 + 3*($cnt - 1)") .) "" $targetsFound)
            set target $targets[(random 1 (count $targets))]
            break
         end
         set upDir ../$upDir
         set cnt (math $cnt + 1)
      end
   end

   echo got to 5: $targetFound

   # Finally check if an initial pattern was given
   if test -z $targetFound
      set cnt 1
      set upDir ..
      while test $cnt -le $maxUp
         eval set targetsFound $upDir/$target*
         if test (count $targetsFound) -gt 0
            if test (count $targetsFound) -eq 1
               set targetFound $targetsFound
               break
            end
            # for multiple matches, randomly select one
            set targets (string replace -r ^(string repeat -n (math "2 + 3*($cnt - 1)") .) "" $targetsFound)
            set target $targets[(random 1 (count $targets))]
            break
         end
         set upDir ../$upDir
         set cnt (math $cnt + 1)
      end
   end

   echo got to 6: $targetFound

   set -f destination
   if test -z "$targetFound"
      printf 'ud: "%s" not found above current directory\n\n' $target
      return 1
   else if test -d "$targetFound"
      set destination $targetFound
   else
      set destination (dirname $targetFound)
   end

   echo got to 7: $targetFound

   if cd $destination[1] 2>/dev/null
      return 0
   end
   printf 'ud: failed to cd to "%s"\n    for target "%s"\n\n' $destination $target
   return 3
end
