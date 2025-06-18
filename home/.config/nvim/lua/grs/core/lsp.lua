--[[ Enable LSP configs and supporting infrastructure ]]

-- Servers to enable - configured in ~/.config/nvim/lsp
local lsp_servers_to_enable = {
   'bashls',
   'cssls',
   'css_variables',
   'css_modules_ls',
   'html',
   'lua_ls',
   'marksman',
   'pylsp',
   'ruff',
   'taplo',
   'zls',
}

vim.lsp.enable(lsp_servers_to_enable)
