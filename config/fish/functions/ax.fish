function ax --description 'Archive eXtractor: usage: ax <file>'

    set -l exFile $argv[1]

    if test -z (string trim $exFile)
        printf '\nError: no argument given\n'
        return 1
    else if test ! -f $exFile
        printf '\nError: \'%s\' is not a file\n' $exFile[1]
        return 1
    end

    switch $exFile[1]
        case '*.tar'
            tar -xvf $exFile[1]
        case '*.tar.bz2' '*.tbz2'
            tar -xjvf $exFile[1]
        case '*.tar.gz' '*.tgz'
            tar -xzvf $exFile[1]
        case '*.tar.Z'
            tar -xZvf $exFile[1]
        case '*.gz'
            gunzip $exFile[1]
        case '*.bz2'
            bunzip2 $exFile[1]
        case '*.zip'
            unzip $exFile[1]
        case '*.Z'
            uncompress $exFile[1]
        case '*.rar'
            unrar x $exFile[1]
        case '*.tar.xz'
            xz -dc $exFile[1] | tar -xvf -
        case '*.tar.7z'
            7za x -so $exFile[1] | tar -xvf -
        case '*.7z'
            7z x $exFile[1]
        case '*.tar.zst'
            zstd -dc $exFile[1] | tar -xvf -
        case '*.zst'
            zstd -d $exFile[1]
        case '*.cpio'
            cpio -idv < $exFile[1]
        case '*'
            printf '\nError: \'%s\' unknown file type\n' $exFile[1] >&2
            return 2
    end
end
