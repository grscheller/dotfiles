--[[ Configure mason.nvim ]]

return {
   {
      -- Package manager for external tooling
      [1] = 'mason-org/mason.nvim',
      event = 'VeryLazy',
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
