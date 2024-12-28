function tm --description 'Launch alacritty retaining current shell environment'
    if type -q alacritty
        alacritty 2>/dev/null &; disown
    else
        printf '\nCannot find alacritty executable.\n'
        return 1
    end
end
