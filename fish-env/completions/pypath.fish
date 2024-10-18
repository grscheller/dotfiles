# Turn off file completion
complete -c pypath -f

# show all options available
complete -c pypath \
  -n 'not __fish_seen_subcommand_from ai' \
  -a 'ai'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from boringmath' \
  -a 'boringmath'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from circulararray' \
  -a 'circulararray'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from datastructures' \
  -a 'datastructures'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from untyped' \
  -a 'experimental'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from fp' \
  -a 'fp'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from untyped' \
  -a 'untyped'
