# Turn off file completion
complete -c ve -f

# show all options available
complete -c ve \
  -n 'not __fish_seen_subcommand_from bm' \
  -a 'bm'
complete -c ve \
  -n 'not __fish_seen_subcommand_from fm' \
  -a 'fp'
complete -c ve \
  -n 'not __fish_seen_subcommand_from pypi' \
  -a 'pypi'
complete -c ve \
  -n 'not __fish_seen_subcommand_from grs' \
  -a 'grs'
