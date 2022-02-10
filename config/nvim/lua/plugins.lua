--[[ To bootstrap Packer for the first time, run the command

       $ ~/bin/bsPacker

     Whenever changes are made to this file, or you just bootstrapped
     Packer with the above method, from within nvim run the command

       :PackerSync

     Packer stores the packages it manages here

       ~/.local/share/nvim/site/pack/packer      ]]

return require'packer'.startup(function()
    -- Packer manages itself
    use 'wbthomason/packer.nvim'

    -- Colorize hexcodes and names like Blue, Yellow or Green
    use {
        'norcalli/nvim-colorizer.lua',
        config = function()
            vim.o.termguicolors = true
            require'colorizer'.setup()
        end
    }

    -- Tokyo Night colorscheme
    use {
        'folke/tokyonight.nvim',
        config = function()
            vim.g.tokyonight_style = "night"
            vim.g.tokyonight_colors = {bg = "#000000"}
            vim.g.tokyonight_italic_functions = 1
            vim.g.tokyonight_sidebars = {"qf", "vista_kind", "terminal", "packer"}

            vim.cmd[[colorscheme tokyonight]]
        end
    }

    -- Statusline - fork of hoob3rt/lualine.nvim
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function()
            require'lualine'.setup {
                options = {
                    icons_enabled = true,
                    theme = 'moonfly',
                    component_separators = {left = ' ', right = ' '},
                    section_separators = {left = ' ', right = ' '},
                    disabled_filetypes = {},
                    always_divide_middle = true
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff', {'diagnostics', sources = {'nvim_diagnostic'}}},
                    lualine_c = {'filename'},
                    lualine_x = {'filetype', 'encoding'},
                    lualine_y = {'location'},
                    lualine_z = {'progress'}
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {'filename'},
                    lualine_x = {'location'},
                    lualine_y = {'progress'},
                    lualine_z = {}
                },
                tabline = {},
                extensions = {}
            }
        end
    }

    -- define keybindings, show keybindings in popup
    use {
        'folke/which-key.nvim',
        config = function()
            require'which-key'.setup {
                plugins = {
                    spelling = {
                        enabled = true,
                        suggestions = 36
                    }
	            }
            }
        end
    }

    -- Install language modules for built-in treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require'nvim-treesitter.configs'.setup {
                ensure_installed = 'maintained',
                highlight = {enable = true}
            }
        end
    }

    -- Fuzzy finder over lists
    use {
        'nvim-telescope/telescope.nvim',
        requires = {'nvim-lua/plenary.nvim'}
    }

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
