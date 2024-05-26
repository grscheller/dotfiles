function enable_touch_pad
    set -l TPInfo (swaymsg -t get_inputs|grep -B1 ' Touchpad",$')
    set -l TouchPadID (string trim -r -c='",' (string replace  -rf '^ *"identifier": "' '' $TPInfo))
    swaymsg input $TouchPadID events enabled
end
