function iv --description 'Launch eog image viewer'
    if type --no-functions --query eog
        eog $argv 2>/dev/null &; disown
    else
        printf '\nCannot find eog executable.\n'
        return 1
    end
end
