function ldot --description 'List all .files in directory, except . ..'
  set -f dotFiles

  if test (count $argv) -eq 0
      set dotFiles .*
  else
      for Dir in $argv
          set -a dotFiles $Dir/.*
      end
  end

  if test -n "$dotFiles"
      ls --color=auto -Ad $dotFiles
  end
end
