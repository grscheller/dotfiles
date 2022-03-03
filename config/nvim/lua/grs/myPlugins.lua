--[[ Using Packer as the plugin manager ]]

--[[ Bootstrap Packer if not already installed ]]
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_src = 'https://github.com/wbthomason/packer.nvim'
local packerBootstrapped = nil

if vim.fn.empty(vim.fn.glob(install_path)) == 1 then
    packerBootstrapped = vim.fn.system {
        'git',
        'clone',
        '--depth',
        '1',
        packer_src,
        install_path
    }
    vim.cmd[[packadd packer.nvim]]
end

local ok, packer = pcall(require, 'packer')
if not ok then
    print('Warning: Packer not installed - no plugins')
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

return packer.startup(function(use)

    -- Packer manages itself
    use { 'wbthomason/packer.nvim' }

    -- Utilities used by many other plugins
    use { 'nvim-lua/plenary.nvim' }

    -- Setup colorscheme & statusline
    use { 'norcalli/nvim-colorizer.lua' }
    use { 'kyazdani42/nvim-web-devicons' }
    use { 'folke/tokyonight.nvim' }
    use { 'nvim-lualine/lualine.nvim' }

    -- Install language modules for built-in treesitter 
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdateSync' }

    --[[ Telescope - highly extendable fuzzy finder over lists ]]
    use { 'nvim-telescope/telescope-ui-select.nvim' }
    use { 'nvim-telescope/telescope.nvim' }

    --[[ LSP configuration - for Neovim's built-in LSP client ]]
    use { 'neovim/nvim-lspconfig' }  -- Provided by core neovim team
    use { 'ziglang/zig.vim' }        -- File detection and syntax highlighting for Zig
    use { 'simrat39/rust-tools.nvim' }  -- Extra functionality over rust analyzer
    use { 'scalameta/nvim-metals' }     -- Config for Scala Metals

    -- Nvim LSP Installer
    use { 'williamboman/nvim-lsp-installer' }

    -- Completion sources
    use { 'hrsh7th/cmp-nvim-lsp' }
    use { 'hrsh7th/cmp-buffer' }
    use { 'hrsh7th/cmp-path' }
    use { 'hrsh7th/cmp-cmdline' }
    use { 'hrsh7th/cmp-nvim-lua' }

    -- Snippet support
    use { 'L3MON4D3/LuaSnip' }
    use { 'saadparwaiz1/cmp_luasnip' }
    use { 'rafamadriz/friendly-snippets' }

    -- Completions
    use { 'hrsh7th/nvim-cmp' }

    -- manages keybindings
    use { 'folke/which-key.nvim' }

    --[[ Automatically Sync Packer if just got installed ]]
    if packerBootstrapped then
        packer.sync()
    end
end)
