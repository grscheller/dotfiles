function fm --description 'Launch desktop\'s file manager app'
    set -l DiR $argv[1]
    test -z $DiR; and set DiR $PWD
    if test -d $DiR
        xdg-open $DiR 2>/dev/null &
    else
        printf 'Error: "%s" is not a directory\n' $DiR
    end
end
