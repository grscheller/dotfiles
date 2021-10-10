function fields --description 'Extract fields from lines'

    # Parse cmdline options
    argparse -n 'fields' -N 1 's/separator=' 'h/help' -- $argv
    or begin
        printf '        For usage type: fields -h\n' >&2
        return 4
    end

    # Print help message and quit
    if set -q _flag_help
        printf 'Description: Extract fields from lines, from\n' >&2
        printf '             files or stdin.  Basically a\n'    >&2
        printf '             wrapper for an awk command.\n\n'   >&2
        printf 'Usage: fields'                                   >&2
        printf ' [-s|--separator str] n m ... file1 file2 ...\n' >&2
        printf '       fields [-h|--help]\n'                     >&2
        printf '       where n m are field positions,\n'         >&2
        printf '       str is a string separating the fields,\n' >&2
        printf '       file1 file2 are file names\n\n'           >&2
        printf 'Output: prints matches to stdout,\n'          >&2
        printf '        print help to stderr if -h given\n\n' >&2
        printf 'Exit Status: Exit status of underlying awk command\n'    >&2
        printf '             3 if -h or --help option given\n'           >&2
        printf '             4 if an invalid option or argument given\n' >&2
        return 3
    end

    # If argument null, not interested in existence of containing directory.
    set -l Arg
    set -l Fields ()
    set -l Files ()
    for Arg in $argv
        if string match -qr '^[1-9]\d*$' $Arg
            set -a Fields $Arg
        else if [ -f $Arg ] && [ -r $Arg ]
            set -a Files $Arg
        else
            printf '\nArgument "%s" is neither a Field position' $Arg[1] >&2
            printf ' nor a readable regular file\n' >&2
            return 4
        end
    end

    if set -q _flag_separator
        awk -F $_flag_separator[1] '{ print '(string join ', ' \$$Fields)' }' $Files
    else
        awk '{ print '(string join ', ' \$$Fields)' }' $Files
    end

end
