--[[ Ensure linters and formatters are installed ]]

return {
   'WhoIsSethDaniel/mason-tool-installer.nvim',
   dependencies = { 'mason-org/mason.nvim' },
   event = 'VeryLazy',
   opts = {
      ensure_installed = require('config.tools').linters_and_formatters,
      auto_update = true,
      run_on_start = true,
      debounce_hours = 0,
   },
}
