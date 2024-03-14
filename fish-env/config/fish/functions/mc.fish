function mc --description 'My Calculator App'
   if type -q ~/bin/myCalc
      ~/bin/myCalc >/dev/null 2>&1 &
      disown
   else
      printf \nDid not find myCalc executable.\n >&2
      return 1
   end
end
