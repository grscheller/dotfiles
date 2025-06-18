function fdg --description 'Update GIT repos in subdirectories'
   if test -d ./.git
      printf '\nPunting... In a git working directory!\n'
   else
      switch $argv[1]
      case 'pull'
         set action pull
      case 'push'
         set action push
      case 'add'
         set action add .
      case '*'
         set action fetch
      end
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
         printf '\n%s%s:%s\n   ' $brblue $repo $normal
         git --no-pager status --short --branch
         git --no-pager $action &| sed -e 's/^/   /'
         git --no-pager diff --stat --color origin/$branch &| sed -e 's/^/  /'
         cd -
      end
   end
   printf '\n'
end
