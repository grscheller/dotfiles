function fish_title --description 'Set terminal title'
    set MyHostName (hostnamectl hostname)
    switch $MyHostName[1]
        case 'rvsllschellerg2'
            set MyHostName voltron
        case 'SpaceCAMP31'
            set MyHostName SC31
    end
    printf '%s@%s' (id -un) $MyHostName
end
