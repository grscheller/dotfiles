function tm --description 'Launch fish shell running in Alacritty terminal'

    # Define usage function
    function __tm_usage
        printf '\nUsage: tm [-l] [-c \'cmd args\']' >&2
        printf '\n       tm -h\n' >&2
        printf '\n  where -l: invoke a login shell' >&2
        printf '\n        -h: show help for tm' >&2
        printf '\n        -c cmd args: execute cmd after invoking shell,' >&2
        printf '\n\n' >&2
    end

    # Process arguments
    set -l cmd ()
    set -l lFlag ()
    set -l do_it yes

    set -l index 1
    set -l cnt (count $argv)
    while [ $index -le $cnt ]
        switch $argv[$index]
            case -l --login
                set lFlag -l
                set index (math "$index+1")
            case -h --help -help
                __tm_usage
                set do_it no
                break
            case -c -C --command
                # Argument needed for -c option
                if [ $index -lt $cnt ]
                    set index (math "$index+1")
                    test -z (string trim -- $argv[$index])
                    and begin
                        printf '\nError: Command evaluated null for a -c option\n'
                        printf '\nFor help: tm -h\n\n'
                        set do_it no
                        break
                    end
                    set --append cmd -C
                    set --append cmd (string trim -- $argv[$index])
                    set index (math "$index+1")
                else
                    printf '\nError: No command given for a -c option\n'
                    printf '\nFor help: tm -h\n\n'
                    set do_it no
                    break
                end
            case '*'
                printf '\nError: unexpect option or argument "%s" given\n' "$argv[$index]"
                printf '\nFor help: tm -h\n\n'
                set do_it no
                break
        end
    end

    # Clean up function namespace
    functions -e __tm_usage

    # Launch alacritty or punt
    if [ $do_it[1] = yes ]
        alacritty -e fish $lFlag $cmd &
        disown
    else
        return 1
    end

end
