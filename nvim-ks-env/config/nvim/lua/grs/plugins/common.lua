--[[ Plugins with no good place or could go multiple places ]]

local ensureInstalled = require('grs.config.treesitter').ensure_installed

return {

   -- Once bootstrapped, lazy.nvim will keep itself updated
   { 'folke/lazy.nvim' },

   -- library used by many other plugins
   { 'nvim-lua/plenary.nvim' },

   -- makes some plugins dot-repeatable, if they "opt-in"
   { 'tpope/vim-repeat', lazy = false },

   -- Terminal needs patched fonts - see https://github.com/ryanoasis/nerd-fonts
   {
      'nvim-tree/nvim-web-devicons',
      enabled = vim.g.have_nerd_font,
      opts = {
         color_icons = true,
         default = true,
         strict = true,
      },
   },

   -- Config neovim built-in treesitter & install language modules to it
   {
      'nvim-treesitter/nvim-treesitter',
      event = { 'BufReadPre', 'BufNewFile' },
      build = '<cmd>TSUpdate<cr>',
      opts = {
         ensure_installed = ensureInstalled,
         auto_install = true,
         ignore_install = {},
         highlight = {
            enable = true,
            additional_vim_regex_highlighting = { 'ruby' },
         },
         indent = { enable = true, disable = { 'ruby' } },
      },
      config = function(_, opts)
         require('nvim-treesitter.install').prefer_git = true
         require('nvim-treesitter.configs').setup(opts)

         -- Check out these nvim-treesitter modules:
         --   - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
         --   - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
         --   - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
      end,
   },

}
