# Make sure $fish_features is set in universal scope
if [ -z "$fish_features" ]
    set -U fish_features stderr-nocaret qmark-noglob regex-easyesc
    set_color red
    printf '\nWarning: fish_features was not universally set,'
    printf '\n         restart fish for them to take effect.\n\n'
    set_color normal
end

# Enable vi keybindings - Alacritty not supported for fish <= 3.1.2
fish_vi_key_bindings
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual underscore blink
