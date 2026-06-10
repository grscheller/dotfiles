function run --description 'Launch app outside terminal cgroup, modern method'
    systemd-run --user --scope --quiet -- $argv & disown
end
