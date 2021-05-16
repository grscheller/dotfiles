function ldot --description 'List all .files, except . & .., in current directory'
    set dotFiles .*
    if test -n "$dotFiles"
        ls -Ad $dotFiles
    end
end
