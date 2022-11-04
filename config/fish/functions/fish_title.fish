function fish_title --description 'Set terminal title'
    set -l MyHostName (hostnamectl hostname)
    switch $MyHostName[1]
        case 'rvsllschellerg2'
            set MyHostName voltron
        case 'SpaceCAMP31'
            set MyHostName sc31
    end
    printf '%s@%s' (id -un) $MyHostName
end
