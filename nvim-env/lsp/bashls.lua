--[[ LSP Configuration - bashls ]]

local km = require 'grs.config.keymaps.late'

local capabilities = vim.tbl_deep_extend('force',
   vim.lsp.protocol.make_client_capabilities(),
   require('cmp_nvim_lsp').default_capabilities()
)

-- Bash and POSIX Shell
return {
   cmd = { 'bash-language-server', 'start' },
   filetypes = { 'bash', 'sh' },
   root_markers = {
      '.git',
   },
--   capabilities = capabilities,
   settings = {
      bashIde = {
         globPattern = '**/*@(.sh|.inc|.bash|.command)',
      },
   },
}
