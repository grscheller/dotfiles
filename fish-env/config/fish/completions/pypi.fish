# Turn off file completion
complete -c pypi -f

# show all options available
complete -c pypi \
  -n 'not __fish_seen_subcommand_from datastructures' \
  -a 'datastructures'
complete -c pypi \
  -n 'not __fish_seen_subcommand_from boringmath' \
  -a 'boringmath'
complete -c pypi \
  -n 'not __fish_seen_subcommand_from circulararray' \
  -a 'circulararray'
