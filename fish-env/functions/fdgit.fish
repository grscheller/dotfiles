function fdgit --description 'Update GIT repos in subdirectories'

   set -l brblue (set_color brblue)
   set -l normal (set_color normal)

   set gitDirs (fd --hidden --no-ignore --type directory '^.git$')
   set repos ()

   string replace -r '/\.git/$' '' $gitDirs | while read line
      set repos $repos $line
   end

   for repo in $repos
      cd "$repo"
      set branch (git branch --show-current)
      begin
         printf '\n'
         printf '%s%s:%s\n' $brblue $repo $normal
         git --no-pager fetch --quiet
         printf '   '
         git --no-pager status --short --branch
         git --no-pager diff --stat --color origin/$branch | sed -e 's/^/  /'
      end
      cd -
   end

   printf '\n'

end
