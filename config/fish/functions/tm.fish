function tm
    # Launch fish shell running in Alacritty terminal

    set -l cFlag 0   # -c cmd: execute following command (must be last option)
    set -l cmd
    set -l kFlag 0   # -k:     keep current environment

    set index 1; set cnt (count $argv)
    while [ $index -le $cnt ]
        switch $argv[$index]
            case -k
                set kFlag 1
                set index (math "$index+1")
            case -c
                if [ $index -lt $cnt ]
                    set cFlag 1
                    set cmd $argv[(math "$index+1")..-1]
                    [ -z $cmd[1] ]; and begin
                        printf '\nError: Command evaluated null'
                        return 1
                    end
                else
                    printf '\nError: No command given\n\n'
                    return 1
                end
                break
            case '*'
                printf '\nError: Unexpect option or argument "%s" given\n\n' "$argv[$index]"
                return 1
        end
    end
      echo $index : $kFlag : $cFlag : $cmd : $argv
    alacritty -e fish &; disown
end
