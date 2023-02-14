function pathtrim --description 'Canonicalize $PATH'

    set -l Path ()
    set -l NewPath ()

    # Parse cmdline options
    argparse -n 'pathtrim' h/help -- $argv
    and begin
        if [ (count $argv) -gt 0 ]
            set Path $argv
        else
            set Path $PATH
        end
        true
    end
    or begin
           printf '          For usage type: pathtrim -h\n'
           return 2
    end

    # Print help message and quit
    if set -q _flag_help
        printf 'Usage: pathtrim\n'                >&2
        printf '       pathtrim $PATH_VARIABLE\n' >&2
        printf '       pathtrim [-h|--help]\n\n'  >&2
        printf 'Returns: 0 if "happy path" followed\n' >&2
        printf '         1 if -h or --help option given\n'   >&2
        printf '         2 for invalid option or argument number\n\n' >&2
        printf 'Side Effects: Trims off duplicate & non-existant path ' >&2
        printf               'components and print to stdout.\n'        >&2
        printf '              Print help to stderr if -h given.\n'  >&2
        return 1
    end

    # Make sure we have a proper readlink shell utility,
    # iMac shell utilities are old and crusty.
    set -l READLINK readlink
    type -q greadlink && set READLINK greadlink

    # Check if absolute path component exist and are dirctories,
    # also get real locations of these components.
    set -l Dir
    set -l Dirs ()
    for Dir in $Path
        if string match -q -v '/*' $Dir
            set -a Dirs $Dir
        else if test -d $Dir
            set -a Dirs ($READLINK -e $Dir)
        end
    end

    # Delete duplicate directories
    set Path ()
    for Dir in $Dirs
        set -l Found no
        for DirFound in $Path
            test $Dir = $DirFound
            and set Found yes
            and break
        end
        test $Found = no
        and set -a Path $Dir
    end

    # Print cleaned up path to stdout
    printf %s\n $Path

    return 0

end
