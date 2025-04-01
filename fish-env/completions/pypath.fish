# Turn off file completion
complete -c pypath -f

# show all options available
complete -c pypath \
  -n 'not __fish_seen_subcommand_from bm-integer-math' \
  -a 'bm-integer-math'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from bm-probability-distributions' \
  -a 'bm-probability-distributions'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from bm-pythagorean-triples' \
  -a 'bm-pythagorean-triples'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from bm-recursive-functions' \
  -a 'bm-recursive-functions'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from dtools-circulararray' \
  -a 'dtools-circulararray'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from dtools-datastructures' \
  -a 'dtools-datastructures'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from dtools-fp' \
  -a 'dtools-fp'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from dtools-queues' \
  -a 'dtools-queues'
