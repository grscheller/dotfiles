function notilda --description 'strip pdoc3 generated tildas from TypeVars'
   for File in (fd --type file --extension html)
      sed -E 's/~_([A-Z])/_\1/g' $File > {$File}_temp
      mv {$File}_temp {$File}
   end
end
