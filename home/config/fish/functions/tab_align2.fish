function tab_align2 --description 'Align the rows of two columns'

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
        eval set -f col1 \$$argv[1]
        eval set -f col2 \$$argv[2]
    else
        printf 'Error align2: wrong number of arguments given\n' >&2
    end

    set -f cnt1 (count $col1)
    set -f cnt2 (count $col2)

    # Nothing to do.
    if test $cnt1 -eq 0 -a $cnt2 -eq 0
        return 0
    end

    # Determine number of rows to columnate and starting point to add missing rows.
    set -l num_rows (math max $cnt1,$cnt2)
    set -l diff (math abs \( $cnt1 - $cnt2 \))
    if test $diff -ne $num_rows
        set start (math $diff + 1)
    else
        set start 1
    end

    # Add empty strings for missing final rows for first array.
    if test $cnt2 -gt $cnt1
        set col1[$start..$num_rows] (
            string replace 'x' '' (
                string split '' (string repeat -n $diff 'x')
            )
        )
    end

    # Add empty strings for missing final rows for second array.
    if test $cnt1 -gt $cnt2
        set col2[$start..$num_rows] (
            string replace 'x' '' (
                string split '' (string repeat -n $diff 'x')
            )
        )
    end

    set -l len
    set -l stops
    set -l max_stops 0
    set -l tabstops
    set -l addstops

    for str in $col1
        set -l len (count (string split '' "$str"))
        set len (math $len - $len % 1)
        set stops (math $len / $tabstop)
        set stops (math $stops - $stops % 1 + 1)
        set -a tabstops $stops
        set max_stops (math max $stops,$max_stops)
    end

    for stops in $tabstops
        set -a addstops (math $max_stops - $stops + 1)
    end

    for ii in (seq $num_rows)
        printf '%s%s%s\n' $col1[$ii] (string repeat -n $addstops[$ii] '	') $col2[$ii]
    end

    return 0

end
