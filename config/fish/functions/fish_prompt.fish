function fish_prompt --description 'Customize prompt'
    set_color cyan
    printf '\n[%s: %s]\n$ ' (hostname) (string replace -r "^$HOME" '~' (pwd))
end
