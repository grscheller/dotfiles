function fm --description 'Launch desktop\'s file manager app'
    set -l DiR "$argv[1]"
    test -n $DiR[1] || set DiR "$PWD"
    xdg-open "$DiR[1]"
end
