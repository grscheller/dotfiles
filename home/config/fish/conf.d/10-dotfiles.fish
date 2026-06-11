function _df_install_fisher
    set -l fisher_bundle https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish

    curl -sL $fisher_bundle | source
    test "$pipestatus" = '0 0'
    and fisher install jorgebucaran/fisher
end
