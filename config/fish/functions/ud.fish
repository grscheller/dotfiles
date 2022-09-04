function ud --description 'Jump up multiple directories, default is 1'
    set -l upDir ..
    set -l findTarget ''
    set -l nDirs "$argv[1]"
    set -l maxUp (math (string split / (pwd) | count) - 1)

    if string match -qr -- '^[1-9]\d*$' $nDirs
        # if argument is a number, jump up that number of directories
        if [ $nDirs -gt $maxUp ]
            set nDirs $maxUp
        end
        while [ $nDirs -gt 1 ]
            set upDir ../$upDir
            set nDirs (math $nDirs - 1)
        end
    else
        # look for argument in one of the parent directories
        set findTarget $nDirs
        if [ -n "$findTarget" ]
            set cnt 1
            while [ $cnt -le $maxUp ]
                test -e $upDir/$findTarget
                and break
                set upDir ../$upDir
                set cnt (math $cnt + 1)
            end
        end
    end

    set -l target "$upDir/$findTarget"
    if [ ! -e "$target" ]
        # let user know if target not found in any parent directory
        printf '"%s" not found in any parent directory\n' $findTarget >&2
        return 2
    else if [ -d $target ]
        # drop into target if a directory
        cd "$target"
    else
        # otherwise go directly to parent directory of target
        cd $upDir
    end

    return 0
end
