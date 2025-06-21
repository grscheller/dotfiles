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
      '<leader>?',
      function()
         require('which-key').show { global = false }
      end,
      desc = 'Buffer Local Keymaps (which-key)',
   },
   {
      '<bslash>',
      group = 'diagnostics & dap',
   },
   {
      '<bslash><bslash>',
      group = 'dap',
   },
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
      '<leader>t',
      '<cmd>TSBufToggle highlight<cr>',
      desc = 'toggle treesitter highlighting'
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
