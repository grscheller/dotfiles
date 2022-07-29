## Setup Tokyo Night based colors for fish to use

# Examples: https://github.com/dmi3/fish/blob/master/colors.fish
#           https://github.com/fish-shell/fish-shell/issues/3443

if not set -q tokyo_night_colors_set

    # TokyoNight based colors consistent with my alacritty configuration
    set -l foreground c0caf5  #c0caf5  bright white
    set -l selection 33467c   #33467c
    set -l comment 818ecd     #818ecd
    set -l red f7768e         #f7768e  red
    set -l orange ff9e64      #ff9e64  index color 16
    set -l yellow e0af68      #e0af68  yellow
    set -l green 9ece6a       #9ece6a  green
    set -l purple bb9af7      #bb9af7  magenta
    set -l blue 7dcfff        #7aa2f7
    set -l cyan 0cb4c0        #0cb4c0  my cyan

    # Syntax highlighting colors
    set -U fish_color_autosuggestion $comment
    set -U fish_color_cancel -r
    set -U fish_color_cwd $green
    set -U fish_color_cwd_root $red
    set -U fish_color_command $azure
    set -U fish_color_comment $comment
    set -U fish_color_end $azure
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
    set -U fish_pager_color_prefix $azure
    set -U fish_pager_color_progress $comment
    set -U fish_pager_color_selected_background -r

    set -U tokyo_night_colors_set
end
