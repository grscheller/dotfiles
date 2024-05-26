function lf --description 'Hierarchically list just files'

   # By "files" we mean anything that is not a directory.
   set -f arg
   set -f targets ()

   if test (count $argv) -gt 0
      # Arguments which do not exist in the file system are ignored.
      for arg in $argv
         if test -e "$arg"
            set -a targets $arg
         end
      end

      for target in {$targets}**
         test -d "$target"
         or printf '%s\n' $target
      end | sort | uniq
   else
      set dirName (basename $PWD)
      ud
      for target in {$dirName}**
         test -d "$target"
         or printf '%s\n' $target
      end | sort | uniq | sed -e "s|^$dirName/||"
      cd -
   end


end
