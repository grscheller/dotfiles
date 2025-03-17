--[[ Needed by multiple plugins or important to infrastructure ]]

local config_whichkey = function()
   local wk = require 'which-key'
   wk.setup {
      plugins = {
         spelling = {
            enabled = true,
            suggestions = 36,
         },
      },
   }

   --[[ Prefixes for keymaps_early.lua keymaps ]]

   wk.add {
      { '<bslash>', group = 'diagnostics & dap' },
      { '<leader>', group = 'space' },
      { '<c-b>', group = 'blackhole' },
      { '<c-s>', group = 'system clipboard' },
   }

   wk.add {
      mode = { 'v' },
      { '<leader>', group = 'leader' },
      { '<c-b>', group = 'blackhole' },
      { '<c-s>', group = 'system clipboard' },
   }

   --[[ Logical keymap groupings spanning multiple plugins ]]

   wk.add {
      -- used by multiple plugins
      { '<leader>s', group = 'search' },
      -- nvim-surround plugin
      { '<leader>r', group = 'surround' },
      -- plugin/package managers keymaps
      { '<leader>l', '<cmd>Lazy<cr>', desc = 'Lazy gui' },
      { '<leader>m', '<cmd>Mason<cr>', desc = 'Mason gui' },
      -- toggle Treesitter
      { '<leader>t', '<cmd>TSBufToggle highlight<cr>', desc = 'toggle treesitter highlighting' },
   }
end

return {
   {
      'folke/which-key.nvim',
      event = 'VeryLazy',
      config = config_whichkey,
   },
}
