--[[ Configure mason.nvim ]]

local opts = {
   ui = {
      icons = {
         package_installed = '✓',
         package_pending = '➜',
         package_uninstalled = '✗',
      },
   },
   PATH = 'append',
}

return {
   {
      'mason-org/mason.nvim',
      opts = opts,
   },
}
