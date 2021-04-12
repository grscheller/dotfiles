function tm --description 'Launch fish shell running in Alacritty terminal'

   set uFlag ()
   set rFlag ()
   set -g _tm_do_it yes

   # Define private functions
   function __tm_usage
      printf '\nUsage: tm [-u|r] [-h]' >&2
      printf '\n  where' >&2
      printf '\n    -u: update PATH and environment' >&2
      printf '\n    -r: redo PATH and environment' >&2
      printf '\n    -h: show help for tm' >&2
   end

   function __tm_punt
      set _tm_do_it no
      if test (count $argv) -gt 0
          printf '\nError: %s' "$argv" >&2
          __tm_usage
      else
          __tm_usage
      end
   end

   function __tm_cleanup
      set -e _tm_do_it
      functions -e __tm_usage __tm_punt __tm_cleanup
   end

   # Process arguments
   set index 1
   set cnt (count $argv)
   while [ $index -le $cnt ]
     switch $argv[$index]

       case -h --help -help
          __tm_punt
          break

       case -u --update
          if [ -z $rFlag[1] ]
              set uFlag u
              set index (math "$index+1")
          else
              __tm_punt 'Both -u and -r options cannot be simultaneously be set'
              break
          end

       case -r --redo
          if [ -z $uFlag[1] ]
              set rFlag r
              set index (math "$index+1")
          else
              __tm_punt 'Both -u and -r options cannot be simultaneously be set'
              break
          end

       case '*'
          __tm_punt "Unexpect option or argument \"$argv[$index]\" given"
          break

     end
   end

   # Launch alacritty, if not punting
   if [ $_tm_do_it[1] = yes ]
       if test -n "$uFlag"
           fish -c "set -x UPDATE_ENV; alacritty -e fish &; disown"
       else if test -n "$rFlag"
           fish -c "cd; set -x REDO_ENV; alacritty -e fish -l &; disown"
       else
           alacritty -e fish &; disown
       end
   end

   # Clean up
   __tm_cleanup

end
