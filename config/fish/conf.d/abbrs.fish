## Set up abriviations

# Gui programs
abbr -a tm fishterm
abbr -a gq 'geeqie &; disown'

# Shell terminal cmds
abbr -a da date
abbr -a dp digpath
abbr -a nv nvim
abbr -a pa 'string join \n $PATH'
abbr -a -- pst ps -ejH

abbr -a sw '$HOME/bin/startw'

# enable/disable touchpad
abbr -a tpd disable_touch_pad
abbr -a tpe enable_touch_pad

# Git related cmds - anything more complicated, I want to think about
abbr -a ga git add .
abbr -a gc git commit
abbr -a gco git checkout
abbr -a gd git diff
abbr -a gf git fetch
abbr -a gl git log
abbr -a gp git pull
abbr -a gh git push
abbr -a gs git status  # gs steps on ghostscript
abbr -a gb git 'branch --list|cat'

# So I can run these outside the dotfiles repo
abbr -a dfInstall '$DOTFILE_GIT_REPO/dfInstall'
abbr -a sfInstall 'sudo $DOTFILE_GIT_REPO/sfInstall'

# Shell environment cmds
abbr -a re 'cd; REDO_ENV=yes fish'
abbr -a ue UPDATE_ENV=yes fish
