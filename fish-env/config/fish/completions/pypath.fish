# Turn off file completion
complete -c pypath -f

# show all options available
complete -c pypath \
  -n 'not __fish_seen_subcommand_from datastructures' \
  -a 'datastructures'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from boringmath' \
  -a 'boringmath'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from circulararray' \
  -a 'circulararray'
