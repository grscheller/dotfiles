--[[ Configure mason.nvim ]]

return {
   {
      -- Package manager for external tooling
      'mason-org/mason.nvim',
      opts = {
         ui = {
            icons = {
               package_installed = '✓',
               package_pending = '➜',
               package_uninstalled = '✗',
            },
         },
         PATH = 'prepend',
      },
   },
}
