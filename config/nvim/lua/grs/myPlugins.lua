--[[ Using Packer as the plugin manager

     To keep plugin repos up to date, periodically run

       :PackerSync

     When this file gets updated, you need to run

       :PackerCompile
  ]]

local ok, packer = pcall(require, 'packer')
if not ok then
    print('Warning: Packer not installed/configured - no plugins')
    return
end

local packer_util = require('packer.util')

packer.init {
    display = {
        open_fn = function ()
            return packer_util.float { border = 'rounded' }
        end
    }
}

local use = packer.use

return packer.startup(function()

    -- Packer manages itself
    use 'wbthomason/packer.nvim'

    -- Utilities used by other plugins
    use { 'nvim-lua/plenary.nvim' }

    -- Colorize hexcodes & names like #05aadd Blue Purple
    use { 'norcalli/nvim-colorizer.lua',
          config = function()
              require('colorizer').setup()
          end
    }

    -- Setup colorscheme & statusline
    use { { 'kyazdani42/nvim-web-devicons',
             config = function()
                 require('nvim-web-devicons').setup { default = true }
             end },

          { 'folke/tokyonight.nvim',
            config = function()
                require('grs.plugins.setupTokyoNight')
            end },

          { 'nvim-lualine/lualine.nvim',
            config = function()
                require('grs.plugins.setupLualine')
            end,
            requires = {'kyazdani42/nvim-web-devicons'} }
    }

    -- Install language modules for built-in treesitter 
    use {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = 'maintained',
                highlight = {enable = true}
            }
        end,
        run = ':TSUpdateSync'
    }

    --[[ Telescope - highly extendable fuzzy finder over lists ]]
    use {
        'nvim-telescope/telescope-ui-select.nvim',
        'nvim-telescope/telescope.nvim'
    }

    -- LSP configuration
    use {
        'neovim/nvim-lspconfig',
        'williamboman/nvim-lsp-installer',
        'ziglang/zig.vim',
        'simrat39/rust-tools.nvim',
        'scalameta/nvim-metals'
    }

    -- Completion & snippet support
    use {
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        'rafamadriz/friendly-snippets',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/nvim-cmp'
    }

    -- Manage keybindings
    use {
        'folke/which-key.nvim'
    }
end)
