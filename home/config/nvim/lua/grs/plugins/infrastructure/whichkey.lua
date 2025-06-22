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
   --[[ Which Key related ]]

   {
      '<leader>?',
      function()
         require('which-key').show { global = false }
      end,
      desc = 'Buffer Local Keymaps (which-key)',
   },

   --[[ LSP related ]]

   {
      '<leader>r',
      ':IncRename ',
      desc = 'Incremental Rename',
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

   --[[ Treesitter related ]]

   {
      '<leader>t',
      '<cmd>TSBufToggle highlight<cr>',
      desc = 'toggle treesitter highlighting'
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

   --[[ Not related to any plugin ]]

   {
      '<c-b>',
      group = 'blackhole',
      mode = { 'n', 'v' },
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
