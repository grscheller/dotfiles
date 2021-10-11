function nsort --description 'Numerically list occurances in file or stdin'
  sort $argv | uniq -c | sort -n
end
