function fish_prompt --description 'Customize prompt'
    set -g __fish_git_prompt_showupstream auto verbose
    set -g __fish_git_prompt_showstashstate
    set -g __fish_git_prompt_showdirtystate
    set -g __fish_git_prompt_describe_style branch
    set -g __fish_git_prompt_use_informative_chars
    set -g __fish_git_prompt_showcolorhints
    set -g __fish_git_prompt_color cyan
    set_color blue
    printf '\n[%s: %s]%s' (hostnamectl hostname) (string replace -r "^$HOME" '~' (pwd)) (fish_git_prompt) 
    set_color blue
    printf '\n$ '
    set_color normal
end
