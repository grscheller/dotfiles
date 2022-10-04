function digpath --description 'Look for files on $PATH'

    # Parse cmdline options
    argparse -n 'digpath' q/quiet h/help x/executable -- $argv
    or begin
        printf 'digpath: For usage, type: digpath -h\n' >&2
        return 3
    end

    # Print help message and quit
    if set -q _flag_help
        printf 'Description: Look for files on $PATH, do not\n'                  >&2
        printf '             stop after finding first one.\n\n'                  >&2
        printf 'Usage: digpath [-q|--quiet] [-x|--executable] file1 file2 ...\n' >&2
        printf '       digpath \'glob1*.pat\' glob2\\\*.pat ...\n'               >&2
        printf '       digpath [-h|--help]\n\n'                                  >&2
        printf 'Output: print any matches on $PATH to stdout,\n'                 >&2
        printf '        suppresses output if -q given,\n'                        >&2
        printf '        suppresses nonexecutables if -x given,\n'                >&2
        printf '        print help to stderr if -h given\n\n'                    >&2
        printf 'Exit Status: 0 (true) if match found on $PATH\n'                 >&2
        printf '             1 (false) if no match found\n'                      >&2
        printf '             2 -h or --help option was given\n'                  >&2
        printf '             3 an invalid option was given\n'                    >&2
        printf '             4 no arguments given\n'                             >&2
        return 2
    end

    test (count $argv) -eq 0
    and begin
        printf 'digpath: Invalid number of arguments given\n' >&2
        return 4
    end

    # If argument null, not interested in existence of containing directory.
    set -l File
    set -l Files
    for File in $argv
        test -n (string trim $File)
        and set -a Files $File
    end

    # Ignore non-existent directories
    set -l Dir
    set -l Dirs
    for Dir in $PATH
        test -d $Dir
        and set -a Dirs $Dir
    end

    # See which directories contain which files
    set -l Found
    set -l Target
    set -l Targets
    eval set Targets $Dirs/$Files
    for Target in $Targets
        test -f $Target
        and begin
            test -z "$_flag_executable" -o -x "$Target"
            and set -a Found $Target
        end
    end

    # Report on anything found
    if set -q Found[1]
        if not set -q _flag_quiet
            printf %s\n $Found
        end
        return 0
    else
        return 1
    end

end
