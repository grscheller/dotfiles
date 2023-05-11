--[[ Which-Key - helps make keymaps user discoverable ]]

return {

   {
      'folke/which-key.nvim',
      lazy = false,
      priority = 800,
      config = function()
         local wk = require('which-key')
         wk.setup {
            plugins = {
               spelling = {
                  enabled = true,
                  suggestions = 36,
               },
            }
         }

         -- for Which-Key menus
         wk.register({ name = 'dap' },       { prefix = '<\\>' })
         wk.register({ name = 'lsp+g' },     { prefix = 'g' })
         wk.register({ name = 'lsp+z' },     { prefix = 'z' })
         wk.register({ name = '<space>' },   { prefix = '<leader>' })
         wk.register({ name = '<comma>' },   { prefix = ',', mode = { 'n', 'x'} })
         wk.register({ name = 'lazy' },      { prefix = '<leader>l' })
         wk.register({ name = 'mason' },     { prefix = '<leader>m' })
         wk.register({ name = 'telescope' }, { prefix = '<leader>t' })
         wk.register({ name = 'clipboard'},  { prefix = ',s', mode = { 'n', 'x' } })
      end,
   }

}
