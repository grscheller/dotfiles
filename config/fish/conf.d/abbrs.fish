## Set up abriviations
if not set -q fish_abbr_initialized

    # Gui programs
    abbr -a tm fishterm
    abbr -a gq 'geeqie &; disown'

    # Shell terminal cmds
    abbr -a da date
    abbr -a dp digpath
    abbr -a nv nvim
    abbr -a pa 'string join \n $PATH'
    abbr -a -- pst ps -ejH

    # Exec sway if not already running
    abbr -a sw 'set -qx SWAYSOCK; or cd && exec sway'

    # enable/disable touchpad
    abbr -a tpd disable_touch_pad
    abbr -a tpe enable_touch_pad

    # Git related cmds - anything more complicated, I want to think about
    abbr -a ga git add .
    abbr -a gc git commit
    abbr -a gd git diff
    abbr -a gf git fetch
    abbr -a gl git log
    abbr -a gm git mv
    abbr -a gp git pull
    abbr -a gh git push
    abbr -a gs git status  # gs steps on ghostscript

    # Restart SSH key-agent adding your private key: ~/.ssh/id_rsa
    abbr -a addkey 'eval (ssh-agent -c); and ssh-add'

    # Shell environment cmds
    abbr -a re 'cd; unguard_universals; REDO_ENV=yes fish -l'
    abbr -a ue UPDATE_ENV=yes fish

    set -U fish_abbr_initialized
end
