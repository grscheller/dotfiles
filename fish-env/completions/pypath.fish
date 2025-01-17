# Turn off file completion
complete -c pypath -f

# show all options available
complete -c pypath \
  -n 'not __fish_seen_subcommand_from boringmath' \
  -a 'boringmath'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from integer-math' \
  -a 'integer-math'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from probability-distributions' \
  -a 'probability-distributions'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from pythagorean-triples' \
  -a 'pythagorean-triples'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from recursive-functions' \
  -a 'recursive-functions'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from circulararray' \
  -a 'circulararray'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from datastructures' \
  -a 'datastructures'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from fp' \
  -a 'fp'

