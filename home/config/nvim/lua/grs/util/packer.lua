--[[ Using Packer as the plugin manager

     Manages the plugins I install as a Neovim Package.

     This file configures the packer.nvim plugin which
     creates and manages the plugin package.  This package
     is located here: ~/.local/share/nvim/site/pack/packer
     and the autogenerated plugin loader code, is located
     here: ~/.config/nvim/plugin/packer_compiled.lua

     To keep plugin repos up to date, periodically run

       :PackerSync

     When this file gets updated, and you don't
     want to Sync with the Git repos, then run

       :PackerCompile

     Not always necessary, but I'd restart Neovim after
     running either of the above commands. ]]

local ok, packer = pcall(require, 'packer')
if not ok or not packer then
   print('Warning: Packer not installed/configured - no plugins, ')
   print('         to bootstrap, exit Neovim and run: ~/bin/bsPacker ')
   print(' ')
   print(packer)
   return
end

local packer_util = require('packer.util')

packer.init {
   display = {
      open_fn = function()
         return packer_util.float { border = 'rounded' }
      end
   }
}

local use = packer.use

return packer.startup(
   function()
      -- Packer manages itself
      use { 'wbthomason/packer.nvim' }

      -- Library used by other plugins
      use { 'nvim-lua/plenary.nvim' }

      -- Make keybindings discoverable with Whick-Key
      use { 'folke/which-key.nvim' }

      -- General purpose text editing plugins
      use { 'numToStr/Comment.nvim' }
      use { 'justinmk/vim-sneak' }
      use { 'tpope/vim-surround' }
      use { 'tpope/vim-repeat' }

      -- Colorscheme, statusline & zen-mode
      use { 'norcalli/nvim-colorizer.lua' }
      use { 'rebelot/kanagawa.nvim' }
      use { 'nvim-lualine/lualine.nvim',
         requires = { 'kyazdani42/nvim-web-devicons' }
      }
      use { 'folke/zen-mode.nvim',
         requires = { 'folke/twilight.nvim' }
      }

      -- Install language modules for built-in treesitter
      use { 'nvim-treesitter/nvim-treesitter',
         run = ':TSUpdateSync'
      }

      -- Telescope - highly extendable fuzzy finder over lists
      use { 'nvim-telescope/telescope.nvim' }
      use { 'nvim-telescope/telescope-ui-select.nvim' }
      use { 'nvim-telescope/telescope-file-browser.nvim' }
      use { 'nvim-telescope/telescope-fzf-native.nvim',
         run = 'make'
      }
      use { 'nvim-telescope/telescope-frecency.nvim',
         requires = { 'kkharji/sqlite.lua' }
      }

      -- Completion & snippet support
      use { 'L3MON4D3/LuaSnip' }
      use { 'rafamadriz/friendly-snippets' }
      use { 'onsails/lspkind.nvim' }
      use { 'hrsh7th/nvim-cmp',
         requires = {
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-path',
            'lukas-reineke/cmp-rg'
         }
      }

      -- DAP Debug Adapter Protocol
      use { 'mfussenegger/nvim-dap' }

      -- LSP Language Server Protocol
      use { 'neovim/nvim-lspconfig' }
      use { 'williamboman/nvim-lsp-installer' }
      use { 'simrat39/rust-tools.nvim' }
      use { 'scalameta/nvim-metals' }

      -- File detection/syntax highlighting for zig
      use { 'ziglang/zig.vim' }
   end
)
