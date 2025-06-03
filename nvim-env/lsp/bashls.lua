--[[ LSP Configuration - bashls ]]

-- local capabilities = vim.tbl_deep_extend('force',
--    vim.lsp.protocol.make_client_capabilities(),
--    require('cmp_nvim_lsp').default_capabilities()
-- )

local km = require 'grs.config.keymaps_whichkey'

-- Bash, POSIX, Csh Shells
return {
   cmd = { 'bash-language-server', 'start' },
   filetypes = { 'bash', 'sh', 'ksh', 'csh' },
   root_markers = {
      '.git',
   },
--   capabilities = capabilities,
   settings = {
      bashIde = {
         globPattern = '**/*@(.sh|.inc|.bash|.command)',
      },
   },
   on_attach = km.set_lsp_keymaps,
}
