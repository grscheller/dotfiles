function gitup --description 'Update GIT repos in subdirectories'
   argparse --name=gitup 'u/update' 'p/pause' -- $argv
   or return

   echo "update flag: $_flag_u"
   echo "pause flag: $_flag_p"
   echo

   set gitDirs (fd --hidden --no-ignore --type directory '^.git$' --exec 'echo')
   set repos ()

   for gitDir in $gitDirs
      string replace -r '\.git$' '' $gitDir
   end | while read line
      set repos $repos $line
   end

   for repo in $repos
      printf "$repo\n"
   end
end
