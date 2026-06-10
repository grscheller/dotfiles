function fm --description 'Launch DE file manager app'
    set -l folder
    if test (count $argv) -gt 0
        set folder $argv[1]
    else
        set folder (pwd)
    end
    if test -d "$folder"
        xdg-open $folder
    else
        printf 'Error: "%s" is not a directory\n' $folder
        return 1
    end
end
