# Turn off file completion
complete -c pypath -f

# show all options available
complete -c pypath \
  -n 'not __fish_seen_subcommand_from boringmath' \
  -a 'boringmath'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from bn-integer-math' \
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
  -n 'not __fish_seen_subcommand_from circulararray' \
  -a 'dtools-circulararray'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from datastructures' \
  -a 'ddtools-atastructures'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from fp' \
  -a 'dtools-fp'

