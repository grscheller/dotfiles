--[[ Enable LSP configs and supporting infrastructure ]]

-- Servers to enable - configured in ~/.config/nvim/lsp
local lsp_servers_to_enable = {
   'bashls',
   'cssls',
   'html',
   'lua_ls',
}

vim.lsp.enable(lsp_servers_to_enable)
