# Launch fish shell running in Alacritty terminal.
#
# Under Wayland and Gnome, Alacritty uses a non-native title bar
# which is semi-functional, does not display title, and is bright
# and annoying.  This can be avoided by running Alacritty
# under XWayland.  That said, we still want the fish shell
# running in Alacritty to be aware of a Wayland environment
# and have any launched applications run under Wayland, not XWayland.
#
function fishterm --description 'Launch fish shell running in Alacritty terminal'

    set -g _fishterm_do_it yes
    set -l wFlag ()
    set -l xFlag ()
    set -l WD $WAYLAND_DISPLAY
    set _fishterm_wd_orig $WAYLAND_DISPLAY

    # Define private functions
    function __fishterm_usage
        printf '\nUsage: fishterm [-w|-x] [-h]' >&2
        printf '\n  where' >&2
        printf '\n    -w: run alacritty under Wayland' >&2
        printf '\n    -x: run alacritty under XWayland or Xorg' >&2
        printf '\n    -h: show help for fishterm\n' >&2
    end

    function __fishterm_punt
        set _fishterm_do_it no
        if test (count $argv) -gt 0
            printf '%s\n' $argv >&2
            printf '\nFor help: fishterm -h\n' >&2
        end
    end

    function __fishterm_cleanup
        functions -e __fishterm_usage __fishterm_punt __fishterm_cleanup
        set -e _fishterm_do_it _fishterm_wd_orig
    end

    # Sanity check
    if [ -z "$WAYLAND_DISPLAY" -a -z "$DISPLAY" ]
        printf 'Error: Neither $WAYLAND_DISPLAY nor $DISPLAY is set.\n' >&2
        __fishterm_punt
    end

    # Process arguments
    set index 1
    set cnt (count $argv)
    test $_fishterm_do_it = yes
    and while [ $index -le $cnt ]
        switch $argv[$index]
          case -h --help -help
              __fishterm_usage
              __fishterm_punt
              break
          case -w --wayland
              if [ -z $xFlag[1] ]
                  if [ -z "$WAYLAND_DISPLAY" ]
                      __fishterm_punt 'Error: Wayland session requested,' \
                                      '       but $WAYLAND_DISPLAY is not set.'
                      break
                  end 
                  set wFlag yes
                  set index (math "$index+1")
              else
                  __fishterm_punt 'Error: Options -x and -w both cannot be set.'
                  break
              end
          case -x --xwayland --xorg
              if [ -z $wFlag[1] ]
                  if [ -z "$DISPLAY" ]
                      __fishterm_punt 'Error: XOrg or XWayland session requested,' \
                                      '       but $DISPLAY is not set.'
                      break
                  end 
                  set xFlag yes
                  set WD ()
                  set index (math "$index+1")
              else
                  __fishterm_punt 'Error: Options -w and -x both cannot be set.'
                  break
              end
          case '*'
              __fishterm_punt "Error: Unexpected option or argument \"$argv[$index]\" given."
              break
        end
    end

    # Launch alacritty, if not punting
    if [ $_fishterm_do_it[1] = yes ]
        WAYLAND_DISPLAY=$WD alacritty -e fish -C "set -x WAYLAND_DISPLAY $_fishterm_wd_orig" &
        disown
    end

    # Clean up
    __fishterm_cleanup

end
