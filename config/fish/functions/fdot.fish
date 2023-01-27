function fdot --description 'Find dotfiles in non-hidden directories'

  set -l dotfiles

  for aa in (ldir *) do
      set -a dotfiles (ldot $aa)
  end

  for dotfile in $dotfiles
      test -f $dotfile
      and echo $dotfile
  end | sort | uniq

end
