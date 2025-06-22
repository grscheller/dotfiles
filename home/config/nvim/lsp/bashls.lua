--[[ LSP Configuration - bashls ]]

-- local capabilities = vim.tbl_deep_extend('force',
--    vim.lsp.protocol.make_client_capabilities(),
--    require('cmp_nvim_lsp').default_capabilities()
-- )

-- Bash, POSIX, Csh Shells

local mason_bin = require('grs.config.configs').mason_bin
local bash_language_server = mason_bin .. '/bash-language-server'

return {
   cmd = { bash_language_server, 'start' },
   filetypes = { 'bash', 'sh', 'ksh', 'csh' },
   root_markers = { '.git', '.bashrc', '.profile' },
   settings = {
      bashIde = {
         globPattern = '**/*@(.sh|.inc|.bash|.dash|.command)',
      },
   },
}
