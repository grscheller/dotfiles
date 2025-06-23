--[[ Needed by multiple plugins or important to infrastructure ]]

local opts = {
   plugins = {
      spelling = {
         enabled = true,
         suggestions = 36,
      },
   },
}

local keys = {
   {
      '<c-b>',
      group = 'blackhole',
      mode = { 'n', 'v' },
   },

   --[[ Which Key related ]]

   {
      '<leader>?',
      function()
         require('which-key').show { global = false }
      end,
      desc = 'Buffer Local Keymaps (which-key)',
   },

   --[[ Treesitter related ]]

   {
      '<leader>t',
      '<cmd>TSBufToggle highlight<cr>',
      desc = 'toggle treesitter highlighting'
   },

   --[[ DAP & Diagnostic related ]]

   {
      '<bslash>',
      group = 'diagnostics & dap',
   },
   {
      '<bslash><bslash>',
      group = 'dap',
   },

   --[[ Plugin related ]]

   {
      '<leader>L',
      '<cmd>Lazy<cr>',
      desc = 'Lazy gui'
   },
   {
      '<leader>M',
      '<cmd>Mason<cr>',
      desc = 'Mason gui'
   },
   {
      '<c-s>',
      group = 'system clipboard',
      mode = { 'n', 'v' },
   },
}

return {
   {
      -- Makes keymaps discoverable.
      'folke/which-key.nvim',
      event = 'VeryLazy',
      opts = opts,
      keys = keys,
   },
}
