# Turn off file completion
complete -c ve -f

# show all options available
complete -c ve \
  -n 'not __fish_seen_subcommand_from bm' \
  -a 'bm'
complete -c ve \
  -n 'not __fish_seen_subcommand_from dt' \
  -a 'dt'
complete -c ve \
  -n 'not __fish_seen_subcommand_from pypi' \
  -a 'pypi'
complete -c ve \
  -n 'not __fish_seen_subcommand_from grs' \
  -a 'grs'
complete -c ve \
  -n 'not __fish_seen_subcommand_from grs12' \
  -a 'grs12'
