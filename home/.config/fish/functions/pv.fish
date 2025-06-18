function pv --description 'Launch evince document viewer'
    if type --no-functions --query evince
        evince $argv 2>/dev/null &; disown
    else
        printf '\nCannot find evince executable.\n'
        return 1
    end
end
