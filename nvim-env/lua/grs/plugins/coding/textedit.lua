--[[ Plugins for general Text editing Related taske ]]

return {

   -- Colorize color names, hexcodes, and other color formats
   {
      'norcalli/nvim-colorizer.lua',
      keys = {
         { '<leader>tC', '<cmd>ColorizerToggle<cr>', desc = 'toggle colorizer' },
      },
      opts = {
         '*',
         css = { rgb_fn = true },
         html = { names = false },
      },
   },

   -- comment out or restore lines and blocks of code
   {
      'numToStr/Comment.nvim',
      event = 'VeryLazy',
      opts = {
         padding = true,      -- add space b/w comment string and line
         sticky = true,       -- cursor stays at current position
         ignore = nil,        -- lines to be ignored while (un)comment
         toggler = {
            line = 'gcc',     --Line-comment toggle (normal mode)
            block = 'gbc',    --Block-comment toggle (normal mode)
         },
         opleader = {
            line = 'gc',      -- op-pending line-comment (normal & visual mode)
            block = 'gb',     -- block-comment keymap (normal & visual mode)
         },
         extra = {
            above = 'gcO',    -- add new comment on line above (normal mode)
            below = 'gco',    -- add new comment on line below (normal mode)
            eol = 'gcA',      -- add new comment at end of line (normal mode)
         },
         mappings = {
            basic = true,
            extra = true,
         },
         pre_hook = nil,
         post_hook = nil,
      },
   },

   -- Surround text objects with matching symbols
   {
      'kylechui/nvim-surround',
      event = 'VeryLazy',
      config = true,
   },

   -- Quickly jump around window - like sneak but on steroids
   {
      'ggandor/leap.nvim',
      keys = {
         { 's', mode = { 'n', 'x', 'o' }, desc = 'leap forward to' },
         { 'S', mode = { 'n', 'x', 'o' }, desc = 'leap backward to' },
      },
      config = function()
         local leap = require 'leap'
         leap.opts.case_sensitive = true
         leap.add_default_mappings(true)
      end,
   },

   -- Show line indentations when editing code
   {
      'lukas-reineke/indent-blankline.nvim',
      event = 'InsertEnter',
   },

}
