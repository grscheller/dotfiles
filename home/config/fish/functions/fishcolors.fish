function fishcolors --description 'Show colors used by fish'
   set -f color
   set -f color_def
   set -f normal (set_color normal)
   set -f format '| %s%-38s%s | %-22s |\n'
   printf '___________________________________________________________________\n'
   for color_var in (set -n|grep 'fish.*color'|grep -v '^_')
      set color_def $$color_var
      if not set color (set_color $color_def 2>/dev/null)
         set color_def 'ERROR!!!'
         set color (set_color normal)
      end
      printf $format $color $color_var $normal $color_def
   end
   printf '¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\n'
end
