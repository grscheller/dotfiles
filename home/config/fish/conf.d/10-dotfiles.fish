function df_install_fisher
    # Install the fisher plugin manager.
    set -l fisher_bundle https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish

    curl -sL $fisher_bundle | source
    if contains 1 $pipestatus
        printf 'df_install_fisher: fisher plugin manager failed to bootstrap\n' >&2
        return 2
    end

    if not fisher install jorgebucaran/fisher
        printf 'Error: fisher plugin manager failed to install itself\n' >&2
        return 1
    end
end

function df_update_terminfo
    # Give user's xterm-256color terminfo entry the `Smulx` (undercurl)
    # capability. Needed for COSMIC Terminal, which doesn't answer nvim's
    # identification query. Idempotent, safe to run on every install pass.

    # Need ncurses tooling.
    if not command -q tic; or not command -q infocmp
        printf '%s\n' "df_update_terminfo: tic or infocmp not found; punting" >&2
        return 0
    end

    # Need a base xterm-256color entry to extend.
    if not infocmp -x xterm-256color >/dev/null 2>&1
        printf '%s\n' "df_update_terminfo: no xterm-256color entry; punting" >&2
        return 0
    end

    # Already present: system entry has it, or a previous run added it.
    # The -x is required, Smulx is an extended (user-defined) capability.
    if infocmp -x xterm-256color 2>/dev/null | grep -q 'Smulx='
        return 0
    end

    # Alacritty's exact Smulx string, single literal backslashes. Handed to awk
    # as an environment value, which undergoes NO escape processing, so the
    # bytes reach `tic` verbatim.
    set -lx DF_SMULX 'Smulx=\E[4\:%p1%dm,'

    # Insert it after the entry's name header, then compile into ~/.terminfo/ directory.
    if infocmp -x xterm-256color |
            awk '!d && /^[^#[:space:]]/ {print; print "\t" ENVIRON["DF_SMULX"]; d=1; next} {print}' |
                tic -x -o "$HOME/.terminfo" -
        printf '%s\n' "df_update_terminfo: added Smulx to xterm-256color under ~/.terminfo/" >&2
    else
        printf '%s\n' "df_update_terminfo: tic failed" >&2
        return 1
    end
end
