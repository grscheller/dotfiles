function df_install_fisher
    set -l fisher_bundle https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish

    curl -sL $fisher_bundle | source
    if not contains 1 $pipestatus
        if not fisher install jorgebucaran/fisher
            printf 'Error: fisher plugin manager failed to install itself\n' >&2
            return 1
        end
    else
        printf 'Error: fisher plugin manager failed to bootstrap\n' >&2
        return 2
    end
end

function df_update_terminfo
    # Give the user's xterm-256color terminfo entry the `Smulx` (undercurl)
    # capability, so Neovim emits undercurl on terminals it can't auto-detect
    # (e.g. COSMIC Terminal, which doesn't answer Nvim's identification query).
    # Idempotent; safe to run on every install pass.

    # Need the ncurses tooling.
    if not command -q tic; or not command -q infocmp
        printf '%s\n' "update_terminfo: tic or infocmp not found; skipping" >&2
        return 0
    end

    # Need a base entry to extend.
    if not infocmp -x xterm-256color >/dev/null 2>&1
        printf '%s\n' "update_terminfo: no xterm-256color entry; skipping" >&2
        return 0
    end

    # Already present: system entry has it, or a previous run added it.
    # Note: -x is required, Smulx is an extended (user-defined) capability.
    if infocmp -x xterm-256color 2>/dev/null | grep -q 'Smulx='
        return 0
    end

    # Alacritty's exact Smulx string, single literal backslashes. Handed to awk
    # as an environment value, which undergoes NO escape processing, so the
    # bytes reach `tic` verbatim.
    set -lx DF_SMULX 'Smulx=\E[4\:%p1%dm,'

    # Insert it after the entry's name header, then compile into ~/.terminfo.
    # tic creates the dir and shadows the system entry, never leaving this machine.
    if infocmp -x xterm-256color |
            awk '!d && /^[^#[:space:]]/ {print; print "\t" ENVIRON["DF_SMULX"]; d=1; next} {print}' |
            tic -x -o "$HOME/.terminfo" -
        printf '%s\n' "update_terminfo: added Smulx to ~/.terminfo/xterm-256color" >&2
    else
        printf '%s\n' "update_terminfo: tic failed" >&2
        return 1
    end
end
