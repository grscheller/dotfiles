function dotf --description 'Find dotfiles in non-hidden directories'

  set -f dotfiles

  for aa in (ldir *) do
      set -a dotfiles (ldot $aa)
  end

  for dotfile in $dotfiles
      test -f "$dotfile"
      and printf '%s\n' $dotfile
  end | sort | uniq

end
