function fm --description 'Launch desktop\'s file manager app'
    set -l open_cmd
    if type -q xdg-open
        # Probably on a Unix
        set open_cmd xdg-open
    else if type -q open
        # Maybe on a Mac
        set open_cmd open
    else
        printf 'Error: Cannot identify proper program launcher for DE'
        return 1
    end

    set -l DiR $argv[1]
    test -z $DiR; and set DiR $PWD
    if test -d $DiR
        $open_cmd $DiR 2>/dev/null &
    else
        printf 'Error: "%s" is not a directory\n' $DiR
        return 1
    end
end
