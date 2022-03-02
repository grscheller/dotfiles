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
    print('Installing packer, close and reopen Neovim...')
end

require('packer').startup(function(use)

    --[[ Packer manages itself ]]
    use { 'wbthomason/packer.nvim' }

    --[[ Used by many other plugins ]] 
    use { 'nvim-lua/plenary.nvim' }

    --[[ Setup colorscheme & statusline ]]
    -- Colorize hexcodes & names like Blue, Yellow or Green
    use {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup()
        end
    }

    -- Provide icons and colorizes theme
    --   Needs a patched fort like Noto Mono Nerd Font
    --   https://github.com/ryanoasis/nerd-fonts
    use {
        'kyazdani42/nvim-web-devicons',
         config = function()
            require('nvim-web-devicons').setup {
                default = true;
            }
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

    -- Statusline written in pure Lua
    use {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    theme = 'tokyonight',
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

    --[[ Treesitter - install language modules ]]
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdateSync',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = 'maintained',
                highlight = {enable = true}
            }
        end
    }

    --[[ Telescope - highly extendable fuzzy finder over lists ]]
    use { 'nvim-telescope/telescope-ui-select.nvim' }
    use {
        'nvim-telescope/telescope.nvim',
        config = function()
            require('telescope').setup {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown {
                    }
                }
            }
            require('telescope').load_extension('ui-select')
        end
    }

    --[[ LSP configuration ]]
    -- Plugins for Neovim's built-in LSP client
    use { 'neovim/nvim-lspconfig' }  -- Provided by core neovim team
    use { 'ziglang/zig.vim' }  -- File detection and syntax highlighting for Zig
    use { 'simrat39/rust-tools.nvim' }  -- Extra functionality over rust analyzer
    use { 'scalameta/nvim-metals' }  -- Config for Scala Metals

    -- Nvim LSP Installer
    use { 'williamboman/nvim-lsp-installer' }  -- Good when Pacman not an option

    --[[ Completion and snippet support ]]
    -- Completion sources
    use { 'hrsh7th/cmp-nvim-lsp' }
    use { 'hrsh7th/cmp-buffer' }
    use { 'hrsh7th/cmp-path' }
    use { 'hrsh7th/cmp-cmdline' }
    use { 'hrsh7th/cmp-nvim-lua' }

    -- Snippets support
    use { 'L3MON4D3/LuaSnip' }
    use { 'saadparwaiz1/cmp_luasnip' }
    use { 'rafamadriz/friendly-snippets' }

    use {
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            vim.o.completeopt = "menuone,noinsert,noselect"
            local myHasWordsBefore = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            -- I think the "mappings" defined below are artifacts of
            -- popup completion windows and not true nvim keybindings.
            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end
                },
                mapping = {
                    ['<C-P>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 'c'}),
                    ['<C-N>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 'c'}),
                    ['<C-D>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
                    ['<C-F>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
                    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
                    ['<C-E>'] = cmp.mapping(cmp.mapping.close(), {'i', 'c'}),
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true },
                    ['<Tab>'] = cmp.mapping(
                        function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item()
                            elseif luasnip.expand_or_jumpable() then
                                luasnip.expand_or_jump()
                            elseif myHasWordsBefore() then
                                cmp.complete()
                            else
                                fallback()
                            end
                        end, {"i", "s"}),
                    ['<S-Tab>'] = cmp.mapping(
                        function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item()
                            elseif luasnip.jumpable(-1) then
                                luasnip.jump(-1)
                            else
                                fallback()
                            end
                        end, {"i", "s"})
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lua' },
                    { name = 'luasnip'  }
                }, {
                    { name = 'buffer'   },
                    { name = 'path'     }
                })
            }

            cmp.setup.cmdline('/', {
                sources = cmp.config.sources(
                    {{ name = 'buffer'  }},
                    {{ name = 'cmdline' }})
            })

            cmp.setup.cmdline(':', {
                sources = cmp.config.sources(
                    {{ name = 'path'     }},
                    {{ name = 'cmdline'  }},
                    {{ name = 'nvim-lua' }})
            })

        end
    }

    --[[ WhichKey - used to
         - define keybindings
         - show keybindings in a popup
         - provide extra spell checking functionality ]]
    use {
        'folke/which-key.nvim',
        config = function()
            require('which-key').setup {
                plugins = {
                    spelling = {
                        enabled = true,
                        suggestions = 36
                    }
                }
            }
        end
    }

    --[[ Automatically Sync Packer if just installed ]]
    if packerBootstrapped then
        -- vim.cmd[[ :PackerSync ]]
        require('packer').sync()
        print('Packer installed.  Exit and restart Neovim...')
    end
end )
