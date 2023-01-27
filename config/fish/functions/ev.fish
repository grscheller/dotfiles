function ev --description 'Launch evince document viewer'
    if digpath -q evince
        evince $argv 2>/dev/null &; disown
    else
        printf '\nCannot find evince executable.\n'
        return 1
    end
end
