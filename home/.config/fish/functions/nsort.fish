function nsort --description 'enumerate occurances of lines in file or stdin'
  sort $argv | uniq -c | sort -n
end
