function fish_prompt --description 'Customize prompt'
    set_color cyan
    printf '\n%s\n$ ' (pwd)
end
