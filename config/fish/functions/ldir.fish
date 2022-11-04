function ldir --description 'Hierarchically list just directories'

   set -l arg
   set -l targets ()

   # Arguments which do not exist in the file system are ignored.
   for arg in $argv
      if test -e $arg
         set -a targets $arg
      end
   end

   # Print just directories.
   for target in {$targets}**
      test -d $target
      and echo $target
   end | sort | uniq

end
