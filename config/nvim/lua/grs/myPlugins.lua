--[[ Using Packer as the plugin manager

     To keep plugin repos up to date, periodically run

       :PackerSync

     When this file gets updated, you need to run

       :PackerCompile
  ]]

local ok, packer = pcall(require, 'packer')
if not ok then
    print('Warning: Packer not installed/configured - no plugins')
    print('    To bootstrap, exit Neovim and run: ~/bin/bsPacker')
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

return packer.startup(
  function()
    -- Packer manages itself
    use { 'wbthomason/packer.nvim' }

    -- Replaces slow filetype.vim that comes with Neovim
    --   bug: does not recognize 'git diff'
    --        as producing a 'diff' file
    use { 'nathom/filetype.nvim' }

    -- Lua libs
    use { 'nvim-lua/popup.nvim',
          'nvim-lua/plenary.nvim' }

    -- Manage keybindings with Whick Key
    use { 'folke/which-key.nvim',
          config = function()
            require('which-key').setup {
                plugins = {
                    spelling = {
                        enabled = true,
                        suggestions = 36
                    }
                }
            }
          end }

    -- Colorize names & hexcodes like Purple Blue #15aadd
    use { 'norcalli/nvim-colorizer.lua',
          config = function()
            require('colorizer').setup()
          end }

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
            requires = { 'kyazdani42/nvim-web-devicons' } } }

    -- Install language modules for built-in treesitter 
    use { 'nvim-treesitter/nvim-treesitter',
          config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = 'maintained',
                highlight = { enable = true }
            }
          end,
          run = ':TSUpdateSync' }

    -- Telescope - highly extendable fuzzy finder over lists
    use { 'nvim-telescope/telescope.nvim',
          config = function()
            require('grs.plugins.setupTelescope')
          end,
          requires = {
              'nvim-lua/plenary.nvim',
              'nvim-lua/popup.nvim',
              'nvim-telescope/telescope-ui-select.nvim' } }

    -- Snippet support
    use { 'L3MON4D3/LuaSnip',
          requires = { 'rafamadriz/friendly-snippets' } }

    -- Completion
    use { 'hrsh7th/nvim-cmp',
          config = function()
            require('grs.plugins.setupCmp')
          end,
          requires = {
              'hrsh7th/cmp-buffer',
              'hrsh7th/cmp-cmdline',
              'hrsh7th/cmp-nvim-lsp',
              'hrsh7th/cmp-nvim-lua',
              'hrsh7th/cmp-path',
              'lukas-reineke/cmp-rg',
              'saadparwaiz1/cmp_luasnip' } }

    -- LSP configuration
    use { 'neovim/nvim-lspconfig',
          'simrat39/rust-tools.nvim',
          'scalameta/nvim-metals',
          'williamboman/nvim-lsp-installer' }

    -- File detection & syntax highlighting
    use { 'ziglang/zig.vim' }

  end
)
