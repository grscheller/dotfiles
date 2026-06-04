ensure_undercurl_terminfo() {
    # Give the user's xterm-256color terminfo entry the `Smulx` (undercurl)
    # capability, so Neovim emits undercurl on terminals it can't auto-detect
    # (e.g. COSMIC Terminal, which doesn't answer Nvim's identification query).
    # POSIX sh (dash/bash); idempotent; safe to run on every install pass.

    # Need the ncurses tooling.
    if ! command -v tic >/dev/null 2>&1 || ! command -v infocmp >/dev/null 2>&1; then
        printf '%s\n' "ensure_undercurl_terminfo: tic/infocmp not found; skipping" >&2
        return 0
    fi

    # Need a base entry to extend.
    if ! infocmp -x xterm-256color >/dev/null 2>&1; then
        printf '%s\n' "ensure_undercurl_terminfo: no xterm-256color entry; skipping" >&2
        return 0
    fi

    # Already present (system entry has it, or a previous run added it)? Done.
    # NB: -x is required, Smulx is an extended (user-defined) capability.
    if infocmp -x xterm-256color 2>/dev/null | grep -q 'Smulx='; then
        return 0
    fi

    # Insert Alacritty's exact Smulx string after the entry's name header,
    # then compile into ~/.terminfo (tic creates the dir; it shadows the
    # system entry and never leaves this machine).
    if infocmp -x xterm-256color \
        | awk '!d && /^[^#[:space:]]/ {print; print "\tSmulx=\\E[4\\:%p1%dm,"; d=1; next} {print}' \
        | tic -x -o "$HOME/.terminfo" -
    then
        printf '%s\n' "ensure_undercurl_terminfo: added Smulx to ~/.terminfo/xterm-256color"
    else
        printf '%s\n' "ensure_undercurl_terminfo: tic failed" >&2
        return 1
    fi
}
