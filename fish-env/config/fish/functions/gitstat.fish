function gitstat --description 'Update GIT repos in subdirectories'

   set gitDirs (fd --hidden --no-ignore --type directory '^.git$')
   set repos ()

   string replace -r '/\.git/$' '' $gitDirs | while read line
      set repos $repos $line
   end

   for repo in $repos
      cd "$repo"
      printf '%s:\n' $repo
      set branch (git branch --show-current)
      git --no-pager fetch --quiet
      git --no-pager status --short
      git --no-pager diff --stat --color origin/$branch | sed 's/^/  /'
      cd -
   end

end
