## Setup Kanagawa based colorscheme for fish

# Examples: https://github.com/dmi3/fish/blob/master/colors.fish
#           https://github.com/fish-shell/fish-shell/issues/3443

if not set -q kanagawa_colors_set

    # Kanagawa inspired color pallet
    set -l foreground c0caf5  #9cd7ba
    set -l selection 33467c   #33467c
    set -l comment 818ecd     #818ecd
    set -l red f7768e         #c34043
    set -l orange ff9e64      #ff9e64
    set -l yellow e0af68      #c0a36e
    set -l green 9ece6a       #76946a
    set -l purple bb9af7      #957fb8
    set -l blue 7dcfff        #7e9cd8
    set -l cyan 0cb4c0        #0cb4c0

    # Syntax highlighting colors
    set -U fish_color_autosuggestion $comment
    set -U fish_color_cancel -r
    set -U fish_color_cwd $green
    set -U fish_color_cwd_root $red
    set -U fish_color_command $blue
    set -U fish_color_comment $comment
    set -U fish_color_end $cyan
    set -U fish_color_error --background=$red
    set -U fish_color_escape $red
    set -U fish_color_history_current --bold
    set -U fish_color_host $red
    set -U fish_color_host_remote $yellow
    set -U fish_color_keyword $purple
    set -U fish_color_normal $foreground
    set -U fish_color_operator $cyan
    set -U fish_color_param $purple
    set -U fish_color_quote $green
    set -U fish_color_redirection $cyan
    set -U fish_color_search_match --background=$selection
    set -U fish_color_selection --background=$selection
    set -U fish_color_status $orange
    set -U fish_color_user $cyan
    set -U fish_color_valid_path --underline

    # Completion pager colors
    set -U fish_pager_color_completion $foreground
    set -U fish_pager_color_description $comment
    set -U fish_pager_color_prefix $blue
    set -U fish_pager_color_progress $comment
    set -U fish_pager_color_selected_background -r

    set -U kanagawa_colors_set
end
