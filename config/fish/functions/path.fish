function path --description 'similar to the old DOS path command'
    if test (count $argv) -eq 0
        set TestPath $PATH
    else
        set TestPath $argv
    end

    for Path in $TestPath
        printf '%s\n' $Path
    end
end
