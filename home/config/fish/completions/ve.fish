# Turn off file completion
complete -c ve -f

# show all options available
complete -c ve \
  -n 'not __fish_seen_subcommand_from bm' \
  -a 'bm'
complete -c ve \
  -n 'not __fish_seen_subcommand_from bm_test' \
  -a 'bm_test'
complete -c ve \
  -n 'not __fish_seen_subcommand_from fp' \
  -a 'fp'
complete -c ve \
  -n 'not __fish_seen_subcommand_from fp_test' \
  -a 'fp_test'
complete -c ve \
  -n 'not __fish_seen_subcommand_from grs' \
  -a 'grs'
complete -c ve \
  -n 'not __fish_seen_subcommand_from dev' \
  -a 'dev'
