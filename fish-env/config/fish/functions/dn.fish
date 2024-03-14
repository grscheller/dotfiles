function dn --description 'Jump down directory tree to find an item'
   set -f firstTarget
   set -f firstDir

   set -f argc (count $argv)

   if test (count $argv) -gt 1 
      printf 'dn: dn only takes 0 or 1 arguments' >&2
      return 2
   end

   if test $argc -eq 0
      # Go to first directory dn finds
      set firstDir (fd --type directory --max-results=1) ''
      if test -n $firstDir[1]
         cd $firstDir[1]
         return $status
      else
         printf 'Nowhere to drop down to!\n' >&2
         return 1
      end
   end

   set -f fdArgs --glob --unrestricted --case-sensitive --max-results=1
   set -f pattern "$argv[1]"
   # First look for first exact match.
   set firstTarget (fd $fdArgs $pattern)
   # Next look for leading string match.
   set -a firstTarget (fd $fdArgs $pattern'*')
   # Finally look for containing string match.
   set -a firstTarget (fd $fdArgs '*'$pattern'*')

   if test -z $firstTarget[1]
      printf 'dn: pattern "*%s*" not found for any lower directory\n' $pattern >&2
      return 1
   end

   if test -d $firstTarget[1]
      set firstDir $firstTarget[1]
   else
      set firstDir (dirname $firstTarget[1])
   end

   if cd $firstDir 2>/dev/null
      return 0
   else
      printf 'dn: failed to cd to "%s"\n    for pattern "%s"\n' $destination $target
      return 3
   end
end
