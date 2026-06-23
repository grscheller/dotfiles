--[[ Enable LSP configs and supporting infrastructure ]]

-- Servers to enable - configured in ~/.config/nvim/lsp
local lsp_servers_to_enable = {
   'bashls',
   'lua_ls',
   'marksman',
   'pylsp',
   'ruff',
   'tombi',
   'zls',
}

vim.lsp.enable(lsp_servers_to_enable)
