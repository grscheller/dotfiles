function ldir --description 'Hierarchically list just non-hidden directories'
 
    set -f arg
    set -f args
    set -f targets
 
    # If nor arguments given, search everything under current directory
    if test (count $argv) -gt 0
        set args $argv
    else
        set args (ls)
    end
 
    # Arguments which do not exist in the file system are ignored.
    for arg in $args
        if test -e $arg
            set -a targets $arg
        end
    end
 
    # Print just directories.
    for target in {$targets}**
        test -d $target
        and echo $target
    end | sort | uniq
 
end
