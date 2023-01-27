function ldot --description 'List all .files in directory, except . ..'
  set -l dotFiles

  if test (count $argv) -eq 0
      set dotFiles .*
  else
      for Dir in $argv
          set -a dotFiles $Dir/.*
      end
  end

  if test -n "$dotFiles"
      ls -Ad $dotFiles
  end
end
