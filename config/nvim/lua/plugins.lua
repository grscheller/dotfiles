--[[ To bootstrap Packer for the first time, run the command

       $ ~/bin/bsPacker

     Whenever changes are made to this file, or you just bootstrapped
     Packer with the above method, from within nvim run the command

       :PackerSync

     Packer stores the packages it manages here

       ~/.local/share/nvim/site/pack/packer      ]]

-- Without doing anything fancy, I'll just load the
-- plugins in the same way I did with Paq (for now).
return require'packer'.startup(function()
    -- Packer manages itself
    use 'wbthomason/packer.nvim'

    -- Colorize hexcodes and names like Blue, Yellow or Green
    use 'norcalli/nvim-colorizer.lua'

    -- Tokyo Night colorscheme
    use 'folke/tokyonight.nvim'

    -- Statusline - fork of hoob3rt/lualine.nvim
    use 'nvim-lualine/lualine.nvim'

    -- define keybindings, show keybindings in popup
    use 'folke/which-key.nvim'

    -- Install language modules for built-in treesitter
    use 'nvim-treesitter/nvim-treesitter'

    -- Fuzzy finder over lists
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-lua/popup.nvim'
    use 'sharkdp/fd'

    -- Configs for Neovim's built-in LSP client
    use 'neovim/nvim-lspconfig'  -- Provided by core neovim team
    use 'ziglang/zig.vim'  -- File detection and syntax highlighting for Zig
    use 'simrat39/rust-tools.nvim'  -- Extra functionality over rust analyzer
    use 'scalameta/nvim-metals'  -- Config for Scala Metals

    -- Nvim LSP Installer
    use 'williamboman/nvim-lsp-installer'  -- Good when Pacman not an option

    -- Completion support via nvim-cmp
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lua'

    -- Snippets support
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use 'rafamadriz/friendly-snippets'

end)
