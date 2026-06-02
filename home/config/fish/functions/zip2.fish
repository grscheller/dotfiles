function zip2 --description 'Print 2 shell arrays zipped together with separator'

    set -f dollar '$'
    set -f sep ' '

    if argparse s/sep= -- $argv
        set -q _flag_sep
        and set sep $_flag_sep
    else
        return 1
    end

    if test (count $argv) -eq 2
        if not set -q $argv[1] || not set -q $argv[2]
            if not set -q $argv[1]
                printf "Error zip2: shell variable \"$argv[1]\" not defined\n" >&2
            end
            if not set -q $argv[2]
                printf "Error zip2: shell variable \"$argv[2]\" not defined\n" >&2
            end
            return 1
        end
        eval set -f arr1 $dollar$argv[1]
        eval set -f arr2 $dollar$argv[2]
    else
        printf 'Error zip2: wrong number of arguments given\n' >&2
    end

    set -l len1 (count $arr1)
    set -l len2 (count $arr2)
    if test "$len1" -lt "$len2"
        set -f len $len1
    else
        set -f len $len2
    end

    for ii in (seq $len)
        printf '%s%s%s\n' $arr1[$ii] $sep $arr2[$ii]
    end

end
