# Turn off file completion
complete -c ve -f

# show all options available
complete -c ve \
  -n 'not __fish_seen_subcommand_from dev' \
  -a 'dev'
complete -c ve \
  -n 'not __fish_seen_subcommand_from grs' \
  -a 'grs'
complete -c ve \
  -n 'not __fish_seen_subcommand_from py4ai' \
  -a 'py4ai'
complete -c ve \
  -n 'not __fish_seen_subcommand_from py13_dev' \
  -a 'py13_dev'
