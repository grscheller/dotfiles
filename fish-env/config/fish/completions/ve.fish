# Turn off file completion
complete -c ve -f

# show all options available
complete -c ve \
  -n 'not __fish_seen_subcommand_from grs' \
  -a 'grs'
complete -c ve \
  -n 'not __fish_seen_subcommand_from devel' \
  -a 'devel'
complete -c ve \
  -n 'not __fish_seen_subcommand_from pypi3_12_1' \
  -a 'pypi3_12_1'
complete -c ve \
  -n 'not __fish_seen_subcommand_from jupyter_learn' \
  -a 'jupyter_learn'
complete -c ve \
  -n 'not __fish_seen_subcommand_from py4ai' \
  -a 'py4ai'
