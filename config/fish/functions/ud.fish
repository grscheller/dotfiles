function ud --description 'Jump up multiple directories, default is 1'
    set -l upDir ..
    set -l findTarget ''
    set -l nDirs "$argv[1]"
    if string match -qr '^[1-9]\d*$' $nDirs
        # jump up given number of directories
        while [ $nDirs -gt 1 ]
            set upDir ../$upDir
            set nDirs (math $nDirs - 1)
        end
    else
        # jump up and then drop into given directory if found
        set findTarget (string trim $nDirs)
        if [ -n "$findTarget" ]
            set cnt 1
            set maxUp (math (string split / (pwd) | count) - 1)
            while [ $cnt -le $maxUp ]
                test -e $upDir/$findTarget
                and break
                set upDir ../$upDir
                set cnt (math $cnt + 1)
            end
        end
    end
    set target "$upDir/$findTarget"
    if [ -d $target ]
        cd "$target"
    else
        cd $upDir
    end
end
