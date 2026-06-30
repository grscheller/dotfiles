--[[ Ensure linters and formatters are installed ]]

return {
   'WhoIsSethDaniel/mason-tool-installer.nvim',
   dependencies = { 'mason-org/mason.nvim' },
   opts = {
      ensure_installed = { 'stylua', 'ruff', 'shfmt' },
   },
}
