# Launch fish shell running in Alacritty terminal.
#
# Under Wayland and Gnome, Alacritty uses a non-native title bar
# which is semi-functional, does not display title, and is bright
# and annoying.  This can be avoided by running Alacritty
# under XWayland.  That said, we still want the fish shell
# running in Alacritty to be aware of the Wayland environment
# and have any launched applications run under Wayland, not XWayland.
function tm --description 'Launch fish shell running in Alacritty terminal'

    set -g _tm_do_it yes
    set WD ()
    set WD_ORIG $WAYLAND_DISPLAY

    # Define private functions
    function __tm_usage
        printf '\nUsage: tm [-w] [-h]' >&2
        printf '\n  where' >&2
        printf '\n    -w: run alacrity under wayland' >&2
        printf '\n    -h: show help for tm' >&2
    end

    function __tm_punt
        set _tm_do_it no
        if test (count $argv) -gt 0
            printf '\nError: %s' "$argv" >&2
            __tm_usage
        else
            __tm_usage
        end
    end

    function __tm_cleanup
        functions -e __tm_usage __tm_punt __tm_cleanup
        set -e _tm_do_it
    end

    # Process arguments
    set index 1
    set cnt (count $argv)
    while [ $index -le $cnt ]
        switch $argv[$index]
            case -h --help -help
                __tm_punt
                break
            case -w --wayland
                set WD $WD_ORIG
                set index (math "$index+1")
            case '*'
                __tm_punt "Unexpected option or argument \"$argv[$index]\" given"
                break
        end
    end

    # Launch alacritty, if not punting
    if [ $_tm_do_it[1] = yes ]
        WAYLAND_DISPLAY=$WD alacritty -e fish -C "set -x WAYLAND_DISPLAY $WD_ORIG" &
        disown
    end

    # Clean up
    __tm_cleanup

end
