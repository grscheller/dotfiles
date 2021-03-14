function fish_prompt
    set_color green
    printf '\n%s' (pwd)
    printf '\n$ '
    set_color normal
end
