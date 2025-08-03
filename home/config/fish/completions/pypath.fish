# Turn off file completion
complete -c pypath -f

# show all options available
complete -c pypath \
  -n 'not __fish_seen_subcommand_from fp-circulararray' \
  -a 'fp-circulararray'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from fp-containers' \
  -a 'fp-containers'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from fp-fptools' \
  -a 'fp-fptools'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from fp-gadgets' \
  -a 'fp-gadgets'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from fp-iterables' \
  -a 'fp-iterables'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from fp-singletons' \
  -a 'fp-singletons'
complete -c pypath \
  -n 'not __fish_seen_subcommand_from fp-splitends' \
  -a 'fp-splitends'
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
