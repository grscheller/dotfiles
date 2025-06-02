--[[ Configure mason.nvim ]]

opts = {
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
      'williamboman/mason.nvim',
      event = 'VeryLazy',
      opts = opts,
   },
}
