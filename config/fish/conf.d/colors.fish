## Setup Kanagawa based colorscheme for fish

# Examples: https://github.com/dmi3/fish/blob/master/colors.fish
#           https://github.com/fish-shell/fish-shell/issues/3443

if not set -q kanagawa_colors_set

    # Kanagawa inspired color pallet
    set -l foreground dcd7ba  #dcd7ba
    set -l selection 33467c   #33467c
    set -l comment 727169     #727169
    set -l red c34043         #c34043
    set -l orange ff9e64      #ff9e64
    set -l yellow c0a36e      #c0a36e
    set -l green 76946a       #76946a
    set -l purple 957fb8      #957fb8
    set -l blue 7dcfff        #7e9cd8
    set -l cyan 7aa89f        #7aa89f
    set -l pink d27e99        #d27e99

    # Syntax highlightin  colors
    set -U fish_color_autosuggestion $comment
    set -U fish_color_cancel -r
    set -U fish_color_cwd $green
    set -U fish_color_cwd_root $red
    set -U fish_color_command $cyan
    set -U fish_color_comment $comment
    set -U fish_color_end $orange
    set -U fish_color_error $red
    set -U fish_color_escape $pink
    set -U fish_color_history_current --bold
    set -U fish_color_host $red
    set -U fish_color_host_remote $yellow
    set -U fish_color_keyword $pink
    set -U fish_color_normal $foreground
    set -U fish_color_operator $green
    set -U fish_color_param $purple
    set -U fish_color_quote $yellow
    set -U fish_color_redirection $foreground
    set -U fish_color_search_match --background=$selection
    set -U fish_color_selection --background=$selection
    set -U fish_color_status $orange
    set -U fish_color_user $cyan
    set -U fish_color_valid_path --underline

    # Completion pager colors
    set -U fish_pager_color_completion $foreground
    set -U fish_pager_color_description $comment
    set -U fish_pager_color_prefix $cyan
    set -U fish_pager_color_progress $comment
    set -U fish_pager_color_selected_background -r

    set -U kanagawa_colors_set
end
