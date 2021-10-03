function lbry --description 'Launch LBRY App'

  set -l LBRY_Dir ~/opt/AppImages
  set -l LBRY_App $LBRY_Dir/LBRY_*.AppImage

  if test (count $LBRY_App) -gt 1
      printf '\nError: Multiple LBRY apps found:\n'
      printf "\t%s\n" $LBRY_App
      return 1
  else if test (count $LBRY_App) -eq 0
      printf '\nError: LBRY app not found in $LBRY_Dir\n'
      return 1
  end

  if test -x $LBRY_App[1]
      $LBRY_App[1] >/dev/null 2>&1 &
      disown
  else
      printf '\nError: LBRY App "%s" not executable\n' $LBRY_App[1]
      return 1
  end

end
