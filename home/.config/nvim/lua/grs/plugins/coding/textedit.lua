--[[ Plugins for general Text editing Related tasks ]]

return {
   -- Show line indentations when editing code
   {
      'lukas-reineke/indent-blankline.nvim',
      event = 'InsertEnter',
      main = 'ibl',
      opts = {
         indent = { char = '│' },
      },
   },

   -- when re-editing a file, return to last place file changed
   { "mrcjkb/nvim-lastplace" },

   -- Colorize color names, hexcodes, and other color formats
   {
      'norcalli/nvim-colorizer.lua',
      keys = {
         { '<leader>c', '<cmd>ColorizerToggle<cr>', desc = 'toggle colorizer' },
      },
      opts = {
         '*',
         css = { rgb_fn = true },
         html = { names = false },
      },
   },

   -- Comment out or restore lines and blocks of code
   {
      'numToStr/Comment.nvim',
      keys = {
         { 'gc', mode = { 'n', 'x' }, desc = 'comment line' },
         { 'gb', mode = { 'n', 'x' }, desc = 'comment block' },
      },
      config = true,
   },

   -- Surround text objects with matching symbols
   {
      'kylechui/nvim-surround',
      event = 'InsertEnter',
      opt = {
         keymaps = {
            normal = 'gz',
            normal_cur = 'gZ',
            normal_line = 'gzz',
            normal_cur_line = 'gZZ',
            visual = 'gz',
            visual_line = 'gZ',
            delete = 'gzd',
            change = 'gzc',
            change_line = 'gzC',
         },
      },
   },

   -- Quickly jump around window - like sneak but on steroids
   {
      'ggandor/leap.nvim',
      keys = {
         { 's', mode = { 'n', 'x', 'o' }, desc = 'leap forward to' },
         { 'S', mode = { 'n', 'x', 'o' }, desc = 'leap backward to' },
         { 'gs', mode = { 'n', 'x', 'o' }, desc = 'leap from window' },
      },
      config = function()
         local leap = require 'leap'
         leap.opts.case_sensitive = true
         leap.add_default_mappings(true)
      end,
   },
}
