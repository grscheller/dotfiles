function tm --description 'Launch terminal retaining current shell environment'
    if type -q 'cosmic-term'
        cosmic-term 2>/dev/null &; disown
    else if type -q alacritty
        alacritty 2>/dev/null &; disown
    else
        printf '\nCannot find alacritty executable.\n'
        return 1
    end
end
