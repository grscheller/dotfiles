--[[ Originally in init.lua ]]

local comment_overrides = {
   opleader = {
      line = 'gc ',
      block = 'gb ',
   },
   extra = {
      above = 'gcO',
      below = 'gco',
      eol = 'gcA',
   },
}

return {
   { 'numToStr/Comment.nvim', opts = comment_overrides },
   { 'tpope/vim-sleuth' }, -- Detect tabstop and shiftwidth automatically
   {
      'folke/which-key.nvim',
      event = 'VimEnter',
      config = function()
         local wk = require 'which-key'
         local keymaps = require 'grs.config.keymaps'
         wk.setup()
         keymaps.wk_prefixes(wk)
         require('which-key').register({
            ['<leader>c'] = { 'code' },
            ['<leader>d'] = { 'document' },
            ['<leader>r'] = { 'rename' },
            ['<leader>s'] = { 'search' },
            ['<leader>w'] = { 'workspace' },
            ['<leader>t'] = { 'toggle' },
         }, { mode = 'n' })

         require('which-key').register({
            ['<leader>h'] = { 'git hunk' },
         }, { mode = { 'n', 'v' } })
      end,
   },
   {
      'nvim-telescope/telescope.nvim',
      event = 'VimEnter',
      branch = '0.1.x',
      dependencies = {
         { 'nvim-lua/plenary.nvim' },
         {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
               return vim.fn.executable 'make' == 1
            end,
         },
         { 'nvim-telescope/telescope-ui-select.nvim' },
         { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      },
      config = function()
         -- Two important keymaps to use while in Telescope are:
         --    - Insert mode: <c-/>
         --    - Normal mode: ?
         -- This opens a window showing all the keymaps for the current picker.
         require('telescope').setup {
            defaults = {
               mappings = {
                  i = { ['<c-enter>'] = 'to_fuzzy_refine' },
               },
            },
            pickers = {},
            extensions = {
               ['ui-select'] = {
                  require('telescope.themes').get_dropdown(),
               },
            },
         }
         pcall(require('telescope').load_extension, 'fzf')
         pcall(require('telescope').load_extension, 'ui-select')

         -- See `:help telescope.builtin`
         local builtin = require 'telescope.builtin'
         vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'search help' })
         vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'search kymaps' })
         vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'search files' })
         vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = 'search select telescope' })
         vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'search current word' })
         vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'search by grep' })
         vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'search diagnostics' })
         vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'search resume' })
         vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = 'search recent files ("." for repeat)' })
         vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = 'Find existing buffers' })

         -- Slightly advanced example of overriding default behavior and theme
         vim.keymap.set('n', '<leader>/', function()
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
               winblend = 10,
               previewer = false,
            })
         end, { desc = '[/] Fuzzily search in current buffer' })

         -- It's also possible to pass additional configuration options.
         vim.keymap.set('n', '<leader>s/', function()
            builtin.live_grep {
               grep_open_files = true,
               prompt_title = 'Live Grep in Open Files',
            }
         end, { desc = 'search / in Open Files' })

         -- Shortcut for searching your Neovim configuration files
         vim.keymap.set('n', '<leader>sn', function()
            builtin.find_files { cwd = vim.fn.stdpath 'config' }
         end, { desc = '[S]earch [N]eovim files' })
      end,
   },

   { -- LSP Configuration & Plugins
      'neovim/nvim-lspconfig',
      dependencies = {
         -- Automatically install LSP's & related tools to Neovim's stdpath
         { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
         'williamboman/mason-lspconfig.nvim',
         'WhoIsSethDaniel/mason-tool-installer.nvim',

         -- Give user feedback on LSP activity
         { 'j-hui/fidget.nvim', opts = {} },

         -- Configures Lua LSP for your Neovim configs, runtime and plugins.
         -- Used for completion, annotations and signatures for Neovim API's.
         { 'folke/neodev.nvim', opts = {} },
      },
      config = function()
         vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('grs-lsp-attach', { clear = true }),
            callback = function(event)
               local map = function(keys, func, desc)
                  vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
               end

               map('gd', require('telescope.builtin').lsp_definitions, 'goto definition')

               -- Find references for the word under your cursor.
               map('gr', require('telescope.builtin').lsp_references, 'goto references')

               -- Jump to the implementation of the word under your cursor.
               --  Useful when your language has ways of declaring types without an actual implementation.
               map('gI', require('telescope.builtin').lsp_implementations, 'goto implementation')

               -- Jump to the type of the word under your cursor.
               --  Useful when you're not sure what type a variable is and you want to see
               --  the definition of its *type*, not where it was *defined*.
               map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'type definition')

               -- Fuzzy find all the symbols in your current document.
               map('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'document symbols')

               -- Fuzzy find all the symbols in your current workspace.
               map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

               -- Rename the variable under your cursor. Most Language Servers support
               -- renaming across workspace files.
               map('<leader>rn', vim.lsp.buf.rename, 'rename')

               -- Execute a code action, usually cursor needs to be on top of an error or suggestion
               -- for this to activate.
               map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

               -- Opens a popup that displays documentation about the word under
               -- your cursor. See :help K for why this keymap was choosen.
               map('K', vim.lsp.buf.hover, 'Hover Documentation')

               -- Goto Declaration. For example, in C this would take you to the header.
               map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

               -- The following two autocommands are used to highlight references of the word under
               -- the cursor. See :help CursorHold for when this is executed. When the cursor is
               -- moved, the highlights will be cleared by the second autocommand.
               local client = vim.lsp.get_client_by_id(event.data.client_id)

               if client and client.server_capabilities.documentHighlightProvider then
                  local highlight_augroup = vim.api.nvim_create_augroup('grs-lsp-highlight', { clear = false })
                  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                     buffer = event.buf,
                     group = highlight_augroup,
                     callback = vim.lsp.buf.document_highlight,
                  })

                  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                     buffer = event.buf,
                     group = highlight_augroup,
                     callback = vim.lsp.buf.clear_references,
                  })

                  vim.api.nvim_create_autocmd('LspDetach', {
                     group = vim.api.nvim_create_augroup('grs-lsp-detach', { clear = true }),
                     callback = function(event2)
                        vim.lsp.buf.clear_references()
                        vim.api.nvim_clear_autocmds { group = 'grs-lsp-highlight', buffer = event2.buf }
                     end,
                  })
               end

               -- Sometimes inlay hints are unwanted. This autocommand is used to toggle them off.
               if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                  map('<leader>th', function()
                     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                  end, '[T]oggle Inlay [H]ints')
               end
            end,
         })

         --  Communicate new capabilities provided by nvim-cmp, to the LSP servers.
         local capabilities = vim.lsp.protocol.make_client_capabilities()
         capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

         -- Enable the following language servers
         --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
         --
         --  Add any additional override configuration in the following tables. Available keys are:
         --  - cmd (table): Override the default command used to start the server
         --  - filetypes (table): Override the default list of associated filetypes for the server
         --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
         --  - settings (table): Override the default settings passed when initializing the server.
         --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
         local servers = {
            -- clangd = {},
            -- gopls = {},
            -- pyright = {},
            -- rust_analyzer = {},
            -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
            --
            -- Some languages (like typescript) have entire language plugins that can be useful:
            --    https://github.com/pmizio/typescript-tools.nvim
            --
            -- But for many setups, the LSP (`tsserver`) will work just fine
            -- tsserver = {},
            --

            lua_ls = {
               -- cmd = {...},
               -- filetypes = { ...},
               -- capabilities = {},
               settings = {
                  Lua = {
                     completion = {
                        callSnippet = 'Replace',
                     },
                     -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                     -- diagnostics = { disable = { 'missing-fields' } },
                  },
               },
            },
         }

         -- Ensure the servers and tools above are installed
         --  To check the current status of installed tools and/or manually install
         --  other tools, you can run
         --    :Mason
         --
         --  You can press `g?` for help in this menu.
         require('mason').setup()

         -- You can add other tools here that you want Mason to install
         -- for you, so that they are available from within Neovim.
         local ensure_installed = vim.tbl_keys(servers or {})
         vim.list_extend(ensure_installed, {
            'stylua', -- Used to format Lua code
         })
         require('mason-tool-installer').setup { ensure_installed = ensure_installed }

         require('mason-lspconfig').setup {
            handlers = {
               function(server_name)
                  local server = servers[server_name] or {}
                  -- This handles overriding only values explicitly passed
                  -- by the server configuration above. Useful when disabling
                  -- certain features of an LSP (for example, turning off formatting for tsserver)
                  server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                  require('lspconfig')[server_name].setup(server)
               end,
            },
         }
      end,
   },

   { -- Autoformat
      'stevearc/conform.nvim',
      lazy = false,
      keys = {
         {
            '<leader>f',
            function()
               require('conform').format { async = true, lsp_fallback = true }
            end,
            mode = '',
            desc = '[F]ormat buffer',
         },
      },
      opts = {
         notify_on_error = false,
         format_on_save = function(bufnr)
            -- Disable "format_on_save lsp_fallback" for languages that don't
            -- have a well standardized coding style. You can add additional
            -- languages here or re-enable it for the disabled ones.
            local disable_filetypes = { c = true, cpp = true }
            return {
               timeout_ms = 500,
               lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
            }
         end,
         formatters_by_ft = {
            lua = { 'stylua' },
            -- Conform can also run multiple formatters sequentially
            -- python = { "isort", "black" },
            --
            -- You can use a sub-list to tell conform to run *until* a formatter
            -- is found.
            -- javascript = { { "prettierd", "prettier" } },
         },
      },
   },

   { -- Autocompletion
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
         -- Snippet Engine & its associated nvim-cmp source
         {
            'L3MON4D3/LuaSnip',
            build = (function()
               -- Build Step is needed for regex support in snippets.
               -- This step is not supported in many windows environments.
               -- Remove the below condition to re-enable on windows.
               if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                  return
               end
               return 'make install_jsregexp'
            end)(),
            dependencies = {
               -- `friendly-snippets` contains a variety of premade snippets.
               --    See the README about individual language/framework/plugin snippets:
               --    https://github.com/rafamadriz/friendly-snippets
               -- {
               --   'rafamadriz/friendly-snippets',
               --   config = function()
               --     require('luasnip.loaders.from_vscode').lazy_load()
               --   end,
               -- },
            },
         },
         'saadparwaiz1/cmp_luasnip',

         -- Adds other completion capabilities.
         --  nvim-cmp does not ship with all sources by default. They are split
         --  into multiple repos for maintenance purposes.
         'hrsh7th/cmp-nvim-lsp',
         'hrsh7th/cmp-path',
      },
      config = function()
         -- See `:help cmp`
         local cmp = require 'cmp'
         local luasnip = require 'luasnip'
         luasnip.config.setup {}

         cmp.setup {
            snippet = {
               expand = function(args)
                  luasnip.lsp_expand(args.body)
               end,
            },
            completion = { completeopt = 'menu,menuone,noinsert' },

            -- For an understanding of why these mappings were
            -- chosen, you will need to read `:help ins-completion`
            --
            -- No, but seriously. Please read `:help ins-completion`, it is really good!
            mapping = cmp.mapping.preset.insert {
               -- Select the [n]ext item
               ['<C-n>'] = cmp.mapping.select_next_item(),
               -- Select the [p]revious item
               ['<C-p>'] = cmp.mapping.select_prev_item(),

               -- Scroll the documentation window [b]ack / [f]orward
               ['<C-b>'] = cmp.mapping.scroll_docs(-4),
               ['<C-f>'] = cmp.mapping.scroll_docs(4),

               -- Accept ([y]es) the completion.
               --  This will auto-import if your LSP supports it.
               --  This will expand snippets if the LSP sent a snippet.
               ['<C-y>'] = cmp.mapping.confirm { select = true },

               -- If you prefer more traditional completion keymaps,
               -- you can uncomment the following lines
               --['<CR>'] = cmp.mapping.confirm { select = true },
               --['<Tab>'] = cmp.mapping.select_next_item(),
               --['<S-Tab>'] = cmp.mapping.select_prev_item(),

               -- Manually trigger a completion from nvim-cmp.
               --  Generally you don't need this, because nvim-cmp will display
               --  completions whenever it has completion options available.
               ['<C-Space>'] = cmp.mapping.complete {},

               -- Think of <c-l> as moving to the right of your snippet expansion.
               --  So if you have a snippet that's like:
               --  function $name($args)
               --    $body
               --  end
               --
               -- <c-l> will move you to the right of each of the expansion locations.
               -- <c-h> is similar, except moving you backwards.
               ['<C-l>'] = cmp.mapping(function()
                  if luasnip.expand_or_locally_jumpable() then
                     luasnip.expand_or_jump()
                  end
               end, { 'i', 's' }),
               ['<C-h>'] = cmp.mapping(function()
                  if luasnip.locally_jumpable(-1) then
                     luasnip.jump(-1)
                  end
               end, { 'i', 's' }),

               -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
               --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
            },
            sources = {
               { name = 'nvim_lsp' },
               { name = 'luasnip' },
               { name = 'path' },
            },
         }
      end,
   },

   { -- Colorscheme
      'rebelot/kanagawa.nvim',
      lazy = false,
      priority = 1000,
      opts = {
         compile = true,
         undercurl = true,
         colors = {
            theme = {
               dragon = {
                  ui = {
                     bg_dim = '#282727', -- dragonBlack4
                     bg_gutter = '#12120f', -- dragonBlack1
                     bg = '#12120f', -- dragonBlack1
                  },
               },
            },
         },
         overrides = function(colors) -- add/modify highlights
            return {
               ColorColumn = { bg = colors.palette.dragonBlack3 },
            }
         end,
      },
      config = function(_, opts)
         local kanagawa = require 'kanagawa'
         kanagawa.setup(opts)
         kanagawa.compile()
         kanagawa.load 'dragon'
      end,
   },

   { -- Collection of various small independent plugins/modules
      'echasnovski/mini.nvim',
      config = function()
         -- Better Around/Inside textobjects
         --
         -- Examples:
         --  - va)  - [V]isually select [A]round [)]paren
         --  - yinq - [Y]ank [I]nside [N]ext [']quote
         --  - ci'  - [C]hange [I]nside [']quote
         require('mini.ai').setup { n_lines = 500 }
         -- Add/delete/replace surroundings (brackets, quotes, etc.)
         --
         -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
         -- - sd'   - [S]urround [D]elete [']quotes
         -- - sr)'  - [S]urround [R]eplace [)] [']
         require('mini.surround').setup()

         -- Simple and easy statusline.
         --  You could remove this setup call if you don't like it,
         --  and try some other statusline plugin
         local statusline = require 'mini.statusline'
         -- set use_icons to true if you have a Nerd Font
         statusline.setup { use_icons = vim.g.have_nerd_font }

         -- You can configure sections in the statusline by overriding their
         -- default behavior. For example, here we set the section for
         -- cursor location to LINE:COLUMN
         ---@diagnostic disable-next-line: duplicate-set-field
         statusline.section_location = function()
            return '%2l:%-2v'
         end

         -- ... and there is more!
         --  Check out: https://github.com/echasnovski/mini.nvim
      end,
   },

   { -- Highlight, edit, and navigate code
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      opts = {
         ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' },
         -- Autoinstall languages that are not installed
         auto_install = true,
         highlight = {
            enable = true,
            -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
            --  If you are experiencing weird indenting issues, add the language to
            --  the list of additional_vim_regex_highlighting and disabled languages for indent.
            additional_vim_regex_highlighting = { 'ruby' },
         },
         indent = { enable = true, disable = { 'ruby' } },
      },
      config = function(_, opts)
         -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

         -- Prefer git instead of curl in order to improve connectivity in some environments
         require('nvim-treesitter.install').prefer_git = true
         ---@diagnostic disable-next-line: missing-fields
         require('nvim-treesitter.configs').setup(opts)

         -- There are additional nvim-treesitter modules that you can use to interact
         -- with nvim-treesitter. You should go explore a few and see what interests you:
         --
         --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
         --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
         --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
      end,
   },

   -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
   -- init.lua. If you want these files, they are in the repository, so you can just download them and
   -- place them in the correct locations.

   -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
   --
   --  Here are some example plugins that I've included in the Kickstart repository.
   --  Uncomment any of the lines below to enable them (you will need to restart nvim).
   --
   require 'grs.plugins.debug',
   require 'grs.plugins.indent_line',
   require 'grs.plugins.lint',
   require 'grs.plugins.autopairs',
   require 'grs.plugins.neo-tree',
   require 'grs.plugins.gitsigns', -- adds gitsigns recommend keymaps
}
