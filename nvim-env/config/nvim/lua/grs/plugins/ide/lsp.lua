--[[ Config Neovim LSP client and Mason toolchain ]]

-- To provide overrides to customize the default configurations
-- pushed to LSP servers.

local km = require 'grs.config.keymaps'

return {

   { -- LSP Configuration & Plugins
      'neovim/nvim-lspconfig',
      event = 'VeryLazy', -- plugin itself is "lazy"
      dependencies = {
         -- Automatically install LSP's & related tools to Neovim's stdpath
         'williamboman/mason.nvim', -- NOTE: Must be loaded first
         'williamboman/mason-lspconfig.nvim',

         -- Configures Lua LSP for your Neovim configs, runtime and plugins.
         -- Used for completion, annotations and signatures for Neovim API's.
         { 'folke/neoconf.nvim', cmd = 'Neoconf', config = true },
         { 'folke/neodev.nvim', opts = {} },

         -- Give user feedback on LSP activity
         { 'j-hui/fidget.nvim', opts = {} },

         -- Show line indentations when when editing code
         'lukas-reineke/indent-blankline.nvim'
      },
      config = function()
         require('mason').setup {}
         require('mason-lspconfig').setup {}

         -- setup before configuring any LSP servers with lspconfig
         require('neoconf').setup {
            experimental = { pathStrict = true },
         }
         require('neodev').setup {}

         local lspconfig = require 'lspconfig'

         capabilities = vim.tbl_deep_extend(
            'force',
            vim.lsp.protocol.make_client_capabilities(),
            require('cmp_nvim_lsp').default_capabilities()
         )



         -- TODO: Move to config/keymaps.lua
         vim.api.nvim_create_autocmd('LspAttach', {
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
               map('gD', vim.lsp.buf.declaration, 'goto declaration')
            end,
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
            desc = 'Get rid of this stupid thing'
         })

         -- Configure Neovim builtin lsp client with the default configurations
         -- provided by the lspconfig plugin.
         local defaultConfiguredLspServers = {
            'clangd',
         }

         for _, lspServer in ipairs(defaultConfiguredLspServers) do
            lspconfig[lspServer].setup {
               capabilities = capabilities,
               on_attach = function(_, bufnr)
                  km.lsp(bufnr)
               end,
            }
         end

         lspconfig.lua_ls.setup {
            lua_ls = {
               filetypes = { 'lua', 'luau' },
               capabilities = capabilities,
               settings = {
                  Lua = {
                     completion = {
                        callSnippet = 'Replace',
                     },
                     -- diagnostics = { disable = { 'missing-fields' } },
                  },
               },
            },
         }

         -- Configure Haskell Language Server
         lspconfig.hls.setup {
            capabilities = capabilities,
            on_attach = function(_, bufnr)
               km.lsp(bufnr)
            end,
            settings = {
               hls = {
                  filetypes = { 'haskell', 'lhaskell', 'cabal' },
                  on_attach = function(_, bufnr)
                     km.lsp(bufnr)
                     km.haskell(bufnr)
                  end,
               },
            },
         }

         -- Manually configure lsp client for python-lsp-server,
         -- using jdhao configs as a starting point.
         lspconfig.pylsp.setup {
            capabilities = capabilities,
            on_attach = function(_, bufnr)
               km.lsp(bufnr)
            end,
            flags = { debounce_text_changes = 200 },
            settings = {
               pylsp = {
                  plugins = {
                     -- formatter options
                     black = { enabled = false },
                     autopep8 = { enabled = false },
                     yapf = { enabled = false },
                     -- linter options
                     pylint = { enabled = false },
                     ruff = { enabled = true },
                     pyflakes = { enabled = false },
                     pycodestyle = { enabled = false },
                     -- type checker
                     pylsp_mypy = {
                        enabled = true,
                     },
                     -- refactoring
                     rope = { enable = true },
                  },
               },
            },
         }
      end,
   },



   -- {
   --    'mfussenegger/nvim-dap',
   --    dependencies = {
   --       -- Creates a beautiful debugger UI
   --       'rcarriga/nvim-dap-ui',

   --       -- Required dependency for nvim-dap-ui
   --       'nvim-neotest/nvim-nio',

   --       -- Installs the debug adapters for you
   --       'williamboman/mason.nvim',
   --       'jay-babu/mason-nvim-dap.nvim',

   --       -- Add your own debuggers here
   --       'leoluz/nvim-dap-go',
   --    },
   --    config = function()
   --       local dap = require 'dap'
   --       local dapui = require 'dapui'

   --       require('mason-nvim-dap').setup {
   --          -- Makes a best effort to setup the various debuggers with
   --          -- reasonable debug configurations
   --          automatic_installation = true,

   --          -- You can provide additional configuration to the handlers,
   --          -- see mason-nvim-dap README for more information
   --          handlers = {},

   --          -- You'll need to check that you have the required things installed
   --          -- online, please don't ask me how to install them :)
   --          ensure_installed = {
   --             -- Update this to ensure that you have the debuggers for the langs you want
   --             'delve',
   --          },
   --       }

   --       -- Basic debugging keymaps, feel free to change to your liking!
   --       vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
   --       vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
   --       vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
   --       vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
   --       vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
   --       vim.keymap.set('n', '<leader>B', function()
   --          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
   --       end, { desc = 'Debug: Set Breakpoint' })

   --       -- Dap UI setup
   --       -- For more information, see |:help nvim-dap-ui|
   --       dapui.setup {
   --          -- Set icons to characters that are more likely to work in every terminal.
   --          --    Feel free to remove or use ones that you like more! :)
   --          --    Don't feel like these are good choices.
   --          icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
   --          controls = {
   --             icons = {
   --                pause = '⏸',
   --                play = '▶',
   --                step_into = '⏎',
   --                step_over = '⏭',
   --                step_out = '⏮',
   --                step_back = 'b',
   --                run_last = '▶▶',
   --                terminate = '⏹',
   --                disconnect = '⏏',
   --             },
   --          },
   --       }

   --       -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
   --       vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

   --       dap.listeners.after.event_initialized['dapui_config'] = dapui.open
   --       dap.listeners.before.event_terminated['dapui_config'] = dapui.close
   --       dap.listeners.before.event_exited['dapui_config'] = dapui.close

   --       -- Install golang specific config
   --       require('dap-go').setup {
   --          delve = {
   --             -- On Windows delve must be run attached or it crashes.
   --             -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
   --             detached = vim.fn.has 'win32' == 0,
   --          },
   --       }
   --    end,
   -- }
}
