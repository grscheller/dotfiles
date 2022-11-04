function lf --description 'Hierarchically list just files'

   set -l arg
   set -l targets ()

   # Arguments which do not exist in the file system are ignored.
   for arg in $argv
      if test -e $arg
         set -a targets $arg
      end
   end

   # By "files" we mean anything that is not a directory.
   for target in {$targets}**
      test -d $target
      or echo $target
   end | sort | uniq

end
