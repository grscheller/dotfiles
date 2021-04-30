function digpath --description 'Look for files on $PATH'

    # Parse cmdline options
    argparse q/quiet h/help -- $argv
    or begin
        printf '\n'
        printf 'Error: invalid options given, for usage try\n'
        printf '       digpath -h\n\n'
        return 3
    end

    # Print help message and quit
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

    # If argument null, not interested in existence of containing directory.
    set -l File
    set -l Files ()
    for File in $argv
        test -n (string trim $File)
        and set -a Files $File
    end

    # Ignore non-existent directories
    set -l Dir
    set -l Dirs ()
    for Dir in $PATH
        test -d $Dir
        and set -a Dirs $Dir
    end

    # See which directories contain which files
    set -l Found ()
    for File in $Dirs/$Files
        test -e $File
        and set -a Found $File
    end

    # Report on anything found
    if set -q Found[1]
        if not set -q _flag_quiet
           printf %s\n $Found
        end
        return 0
    else
        retun 1
    end

end
