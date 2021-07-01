function ud --description 'Jump up multiple directories, default is 1'
    set upDir ..
    set findDir ''
    set nDirs $argv[1]
    if string match -qr '[1-9]\d*' $nDirs
        while [ $nDirs -gt 1 ]
            set upDir ../$upDir
            set nDirs (math $nDirs - 1)
        end
    else
        set findDir (string trim $nDirs)
        if [ -n $findDir ]
            set cnt 1
            set maxUp (math (string split / (pwd) | count) - 1)
            while [ $cnt -le $maxUp ]
                test -d $upDir/$findDir
                and break
                set upDir ../$upDir
                set cnt (math $cnt + 1)
            end
        end
    end
    test -d
    and cd $upDir/$findDir
end
