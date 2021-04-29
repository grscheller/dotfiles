function digpath --description 'Drill down through $PATH to look for executable files'
    argparse q/quiet h/help -- $argv
    or begin
        printf '\n'
        printf 'Error: invalid options given, for usage try\n'
        printf '       digpath -h\n\n'
        return 3
    end


    if set -q _flag_help
        printf '\n'
        printf 'Usage: digpath [-q|--quiet] file1 file2 ...\n' >&2
        printf '       digpath [-h|--help]\n\n' >&2
        printf 'Returns: 0 (true) if match found on $PATH\n' >&2
        printf '         1 (false) if no match found\n' >&2
        printf '         2 if -h or --help option given\n' >&2
        printf '         3 if an invalid option given\n\n' >&2
        printf 'Side Effects: prints matches to stdout, ' >&2
        printf 'suppress output if -q option given\n\n' >&2
        return 2
    end

    set -l found 1

    # Translated from bash version, but with no globbing
    for File in $argv
        test -z (string trim $File); and continue
        for Dir in $PATH
            if test -d $Dir
                test -x $Dir/$File
                and begin
                    set found 0
                    if not set -q _flag_quiet
                        printf '%s\n' "$Dir/$File"
                    end
                end
            else
                continue
            end
        end
    end

    return $found

end
