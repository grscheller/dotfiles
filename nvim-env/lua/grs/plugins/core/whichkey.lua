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
      { '<bslash><bslash>', group = 'dap' },
      { '<leader>', group = 'space' },
      { '<c-b>', group = 'blackhole' },
      { '<c-s>', group = 'system clipboard' },
   }

   wk.add {
      mode = { 'v' },
      { '<c-b>', group = 'blackhole' },
      { '<c-s>', group = 'system clipboard' },
   }

   --[[ Logical keymap groupings spanning multiple plugins ]]

   wk.add {
      -- used by multiple plugins
      { '<leader>s', group = 'search' },
      -- plugin/package managers keymaps
      { '<leader>L', '<cmd>Lazy<cr>', desc = 'Lazy gui' },
      { '<leader>M', '<cmd>Mason<cr>', desc = 'Mason gui' },
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
