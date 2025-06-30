# Set up abbreviations

# Git related cmds - anything more complicated, I want to think about
abbr -a ga git add .
abbr -a gb git branch
abbr -a gbl 'git branch --list|cat'
abbr -a gc git commit -S
abbr -a gco git checkout
abbr -a gd git diff
abbr -a gf git fetch
abbr -a gh git push
abbr -a gl git log
abbr -a gm git mv
abbr -a gp git pull
abbr -a gs git status
abbr -a gsu git submodule update
abbr -a gsm git submodule update --remote --merge
abbr -a gt 'git tag --list|cat'
abbr -a gw git switch

# dotfile installation scripts - single quotes intentional
abbr -a dfI '$DOTFILES_GIT_REPO/bin/dfInstall'
abbr -a nvI '$DOTFILES_GIT_REPO/bin/nvimInstall'
abbr -a fI '$DOTFILES_GIT_REPO/bin/fishInstall'
abbr -a devI  '$DOTFILES_GIT_REPO/bin/develInstall'

# Python virtual environment related
abbr -a pl pip list|cat
abbr -a -- ipy ipython --TerminalInteractiveShell.editing_mode=vi
abbr -a vep 've; and pypath'

# other aliases
abbr -a dp digpath
abbr -a -- pst ps -ejH
abbr -a nv nvim
abbr -a pa 'string join \n $PATH'
# Website scrapping - pull down a subset of a website
abbr -a Wget -- /usr/bin/wget -p --convert-links -e robots=off
# Pull down more -- Not good for large websites
abbr WgetM -- /usr/bin/wget --mirror -p --convert-links -e robots=off

# Shell environment cmds
abbr -a re 'cd; REDO_ENV=yes fish'
abbr -a ue 'UPDATE_ENV=yes fish'
