function ud
    # Jump up multiple directories, default is 1
    set -l upDir ..
    set -l nDirs $argv[1]
    if string match -qr '[1-9]\d*' $nDirs
        while [ $nDirs -gt 1 ]
            set upDir ../$upDir
            set nDirs (math $nDirs - 1)
        end
    end
    cd $upDir
end
