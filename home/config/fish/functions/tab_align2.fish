function tab_align2 --description 'Align the rows of two columns'

    set -f dollar '$'
    set -f tabstop 8

    if argparse s/spaces t/tabstop= -- $argv
        set -q _flag_tabstop
        and set tabstop $_flag_tabstop
    else
        return 1
    end

    if test (count $argv) -eq 2
        if not set -q $argv[1] || not set -q $argv[2]
            if not set -q $argv[1]
                printf "Error tab_align2: shell variable \"$argv[1]\" not defined\n" >&2
            end
            if not set -q $argv[2]
                printf "Error tab_align2: shell variable \"$argv[2]\" not defined\n" >&2
            end
            return 1
        end
        eval set -f col1 $dollar$argv[1]
        eval set -f col2 $dollar$argv[2]
    else
        printf 'Error align2: wrong number of arguments given\n' >&2
    end

    set -f cnt1 (count $col1)
    set -f cnt2 (count $col2)

    # Nothing to do.
    if test $cnt1 -eq 0 -a $cnt2 -eq 0
        return 0
    end

    # Determine number of rows to columnate.
    set -f rows (math max $cnt1,$cnt2)
    set -l diff (math abs \( $cnt1 - $cnt2 \))
    if test $diff -ne $rows
        set start (math $diff + 1)
    else
        set start 1
    end
    # Add empty strings for missing final rows.
    if test $cnt1 -gt $cnt2
        set col2[$start..$rows] (
        #   string replace 'x' '' (
                string split '' (string repeat --count $diff 'x')
        #   )
        )
    else if test $cnt2 -gt $cnt1
        set col1[$start..$rows] (
        #   string replace 'x' ' ' (
                string split '' (string repeat --count $diff 'x')
        #   )
        )
    end

    set -f len1
    set -f len2
    set -f len

    for str in $col1
        set len (count (string split '' "$str"))
        set -a len1 len
        set stops1 (math $len - $len % 1)
    end

    for str in $col2
        set len (count (string split '' "$str"))
        set -a len2 len
        set stops2 (math $len - $len % 1)
    end

    for ii in (seq $cnt1)
        printf '%s\t%s\n' $col1[$ii] $col2[$ii]
    end

    return 0

end
