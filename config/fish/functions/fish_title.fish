function fish_title --description 'Set terminal title'
    printf '%s@%s' (id -un) (hostnamectl hostname)
end
