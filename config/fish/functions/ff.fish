function ff --description 'Launch Firefox web browser'
   if type -q firefox
      firefox $argv >/dev/null 2>&1 &
      disown
   else
      # Maybe we are on iMac
      set -l ff_exe /Applications/Firefox.app/Contents/MacOS/firefox 
      if test -x $ff_exe
         $ff_exe $argv >/dev/null 2>&1 &
         disown
      else
         printf \nDid not find a firefox executable.\n >&2
         return 1
      end
   end
end
