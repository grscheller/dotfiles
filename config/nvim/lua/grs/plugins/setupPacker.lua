--[[ Using Packer as the plugin manager

     To keep plugin repos up to date, periodically run

       :PackerSync

     When this file gets updated, and you don't
     want to Sync, then run

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
    --
    --   bug: Does not recognize 'git diff' as producing
    --        a 'diff' file.  For this and other edge
    --        cases use ':setf git' or ':setf diff' as
    --        work arounds.
    --
    --   note: In 0.7 there will be a filetype.lua
    --
    --         let g:do_filetype_lua = 1     -- to opt into filetype.lua
    --         let g:did_load_filetypes = 0  -- to opt out of filetype.vim
    --         let g:did_load_filetypes = 1  -- to opt out of both
    --
    --   see: https://www.reddit.com/r/neovim/comments/rvwsl3/introducing_filetypelua_and_a_call_for_help/
    --
    use { 'nathom/filetype.nvim' }

    -- Manage keybindings with Whick Key
    use { 'folke/which-key.nvim' }

    -- Colorize names & hexcodes like Purple Blue #15aadd
    use { 'norcalli/nvim-colorizer.lua' }

    -- Setup colorscheme & statusline
    use { 'folke/tokyonight.nvim' }
    use { 'nvim-lualine/lualine.nvim',
          requires = { 'kyazdani42/nvim-web-devicons' } }

    -- Install language modules for built-in treesitter 
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdateSync' }

    -- Telescope - highly extendable fuzzy finder over lists
    use { 'nvim-telescope/telescope.nvim',
          after = 'folke/which-key.nvim',
          requires = { 'nvim-lua/plenary.nvim',
                       'nvim-lua/popup.nvim',
                       'nvim-telescope/telescope-ui-select.nvim' } }

    -- Snippet support
    use { 'L3MON4D3/LuaSnip',
          requires = { 'rafamadriz/friendly-snippets' } }

    -- Completion
    use { 'hrsh7th/nvim-cmp',
          requires = { 'hrsh7th/cmp-buffer',
                       'hrsh7th/cmp-cmdline',
                       'hrsh7th/cmp-nvim-lsp',
                       'hrsh7th/cmp-nvim-lua',
                       'hrsh7th/cmp-path',
                       'lukas-reineke/cmp-rg',
                       'saadparwaiz1/cmp_luasnip' } }

    -- LSP configuration
    use { { 'neovim/nvim-lspconfig', after = 'folke/which-key.nvim' },
          'simrat39/rust-tools.nvim',
          'scalameta/nvim-metals',
          'williamboman/nvim-lsp-installer' }

    -- File detection & syntax highlighting
    use { 'ziglang/zig.vim' }

  end)
