## Setup Kanagawa based color scheme for fish

# Examples: https://github.com/dmi3/fish/blob/master/colors.fish
#           https://github.com/fish-shell/fish-shell/issues/3443

    # Kanagawa inspired color pallet
set -l foreground dcd7ba  #dcd7ba
set -l selection 33467c   #33467c
set -l comment 72716a     #72716a
set -l red c34043         #c34043
set -l orange ff9e64      #ff9e64
set -l yellow c0a36e      #c0a36e
set -l green 76946a       #76946a
set -l purple 957fb8      #957fb8
set -l blue 7e9cd8        #7e9cd8
set -l cyan 7aa89f        #7aa89f
set -l pink d27e99        #d27e99

# Syntax highlighting colors
set -g fish_color_normal $foreground      # default color
set -g fish_color_command $cyan           # color for commands
set -g fish_color_keyword $pink           # fish keywords
set -g fish_color_quote $yellow           # quoted text
set -g fish_color_redirection $blue       # IO redirection
set -g fish_color_end $orange             # process separators like ; or & or |
set -g fish_color_error $red              # syntax errors
set -g fish_color_param $purple           # ordinary command parameters
set -g fish_color_comment $comment        # code comments
set -g fish_color_operator $green         # parameter expansion operators like '*' and '~'
set -g fish_color_escape $pink            # character escapes like '\n' and '\x70'
set -g fish_color_autosuggestion $comment # proposed rest of a command
set -g fish_color_cancel $orange          # CTRL-C indicator
set -g fish_color_user $cyan              # username in default prompt
set -g fish_color_valid_path --underline  # valid path names
set -g fish_color_selection --background=$selection    # selected text in vi visual mode
set -g fish_color_search_match --background=$selection # highlight history search matches

# Completion pager colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $blue
set -g fish_pager_color_selected_background -r
