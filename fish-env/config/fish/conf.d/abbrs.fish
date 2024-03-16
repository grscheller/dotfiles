#source (pyenv init - | psub)# Set up abbreviations

# Git related cmds - anything more complicated, I want to think about
abbr -a ga git add .
abbr -a gb git branch
abbr -a gbl git 'branch --list|cat'
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

# So I can run these outside their repos - single quotes intentional
abbr -a sfInstall 'sudo $DOTFILE_GIT_REPO/bin/sfInstall'
abbr -a dfInstall '$DOTFILE_GIT_REPO/bin/dfInstall'
abbr -a nvInstall '$DOTFILE_GIT_REPO/nvim-env/nvimInstall'
abbr -a fInstall  '$DOTFILE_GIT_REPO/fish-env/fishInstall'
abbr -a hInstall  '$DOTFILE_GIT_REPO/home-env/homeInstall'
abbr -a swInstall '$DOTFILE_GIT_REPO/sway-env/swayInstall'

# Python virtual environment for system python
abbr -a -- p3_11clr 'pip uninstall -y (pip list|tail +3|fields 1|grep -Ev "(pip|setuptools)")'
abbr -a -- p3_12clr 'pip uninstall -y (pip list|tail +3|fields 1|grep -Ev "(pip)")'
abbr -a -- pypyclr 'pip uninstall -y (pip list|tail +3|fields 1|grep -Ev "(pip|setuptools|cffi|greenlet|hpy|readline|wheel)")'
abbr -a -- vdredo 'pip install --upgrade ipython pytest pdoc3 flit "python-lsp-server[all]" jedi-language-server'
abbr -a -- vgredo 'pip install --upgrade ipython fonttools grscheller.circular-array grscheller.datastructures grscheller.boring-math "python-lsp-server[all]" jedi-language-server'
abbr -a -- vjredo 'pip install --upgrade jupyterlab'
abbr -a -- vnredo 'pip install --upgrade neovim pynvim mypy ruff black'
abbr -a -- vpredo 'pip install --upgrade ipython pytest'
abbr -a pl pip list|cat
abbr -a -- ipy ipython --TerminalInteractiveShell.editing_mode=vi

# other aliases
abbr -a dp digpath
abbr -a -- pst ps -ejH
abbr -a nv nvim
abbr -a pa 'string join \n $PATH'
abbr -a sw '$HOME/bin/startw'
# Website scrapping - pull down a subset of a website
abbr -a Wget -- /usr/bin/wget -p --convert-links -e robots=off
# Pull down more -- Not good for large websites
abbr WgetM -- /usr/bin/wget --mirror -p --convert-links -e robots=off

# Shell environment cmds
abbr -a re 'cd; REDO_ENV=yes fish'
abbr -a ue UPDATE_ENV=yes fishsource (pyenv init - | psub)
