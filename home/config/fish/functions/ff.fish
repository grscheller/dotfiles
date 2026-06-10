function ff --description 'Launch Firefox in new window, not new instance'
    if type -q firefox
        if test (count $argv) -gt 0
            run firefox --new-window $argv
        else
            run firefox
        end
    else
        printf 'Not found on path: firefox' >&2
        return 127
    end
end
