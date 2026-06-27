--[[ Configure mason.nvim ]]

local opts = {
   ui = {
      icons = {
         package_installed = '✓',
         package_pending = '➜',
         package_uninstalled = '✗',
      },
   },
   PATH = 'prepend',
}

return {
   {
      -- Package manager for external tooling
      'mason-org/mason.nvim',
      opts = opts,
   },
}
