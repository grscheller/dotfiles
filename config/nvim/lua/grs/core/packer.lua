--[[ Using Packer as the plugin manager ]]

--[[
     The packer plugin turns itself and all the plugins configured
     below into a single Neovim Package.

     This file configures and loads the packer.nvim plugin
     manager.  Once loaded, packer manages all of your plugins,
     including itself.

     To bootstrap, put the packer plugin here,
     "~/.local/share/nvim/site/pack/packer/start/packer.nvim",
     where nvim will be able to find it.

     To keep plugin repos up to date, periodically run

       :PackerSync

     When this file gets updated, and you don't
     want to Sync with the Git repos, then run

       :PackerCompile

     Not always necessary, but I'd restart Neovim after
     running either of the above commands.
--]]

local msg = require('grs.lib.libVim').msg_hit_return_to_continue

local ok, packer = pcall(require, 'packer')
if not ok or not packer then
   local message = 'Warning: Packer not installed/configured - no plugins,\n'
       .. '         to bootstrap, exit Neovim and run: ~/bin/bsPacker'
   msg(message)
   return
end

local packer_util = require 'packer.util'

packer.init {
   display = {
      open_fn = function() return packer_util.float { border = 'rounded' } end,
   },
}

vim.api.nvim_create_autocmd('User', {
   pattern = 'PackerComplete',
   callback = function() print '  Packer has finished!' end,
})

local use = packer.use

return packer.startup(function()
   -- Packer manages itself
   use { 'wbthomason/packer.nvim' }

   -- Library used by other plugins
   use { 'nvim-lua/plenary.nvim' }

   -- Make keybindings discoverable with Whick-Key
   use { 'folke/which-key.nvim' }

   -- General purpose text editing plugins
   use {
      'numToStr/Comment.nvim',
      'justinmk/vim-sneak',
      'tpope/vim-surround',
      'tpope/vim-repeat',
   }

   -- Colorscheme, statusline & zen-mode
   use {
      'rebelot/kanagawa.nvim',
      'nvim-lualine/lualine.nvim',
      'kyazdani42/nvim-web-devicons',
      'norcalli/nvim-colorizer.lua',
      'folke/zen-mode.nvim',
      'folke/twilight.nvim',
   }

   -- Install language modules for built-in treesitter
   use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdateSync' }

   -- Telescope - highly extendable fuzzy finder over lists
   use {
      'nvim-telescope/telescope.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      'nvim-telescope/telescope-frecency.nvim',
      'kkharji/sqlite.lua',
   }

   -- Snippet support
   use { 'L3MON4D3/LuaSnip', 'rafamadriz/friendly-snippets' }

   -- Completion support
   use {
      'hrsh7th/nvim-cmp',
      requires = {
         'hrsh7th/cmp-buffer',
         'hrsh7th/cmp-cmdline',
         'hrsh7th/cmp-nvim-lsp',
         'hrsh7th/cmp-nvim-lsp-signature-help',
         'hrsh7th/cmp-nvim-lua',
         'hrsh7th/cmp-path',
         'onsails/lspkind.nvim',
         'lukas-reineke/cmp-rg',
         'lukas-reineke/cmp-under-comparator',
         'saadparwaiz1/cmp_luasnip',
      },
   }

   -- LSP & DAP support
   use {
      'folke/neodev.nvim',
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      'jose-elias-alvarez/null-ls.nvim',
      'williamboman/mason.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'simrat39/rust-tools.nvim',
      'scalameta/nvim-metals',
   }
end)
