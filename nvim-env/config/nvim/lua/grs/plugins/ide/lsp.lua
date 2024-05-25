--[[ Config Neovim LSP client leveraging the Mason toolchain ]]

-- To provide overrides to customize the default configurations
-- pushed to LSP servers.

local km = require 'grs.config.keymaps'

return {

   -- Give user feedback on LSP activity
   {
      'j-hui/fidget.nvim',
      event = 'LspAttach',
      opts = {},
   },

   -- LSP Configuration & Plugins
   {
      'neovim/nvim-lspconfig',
      event = 'VeryLazy',
      dependencies = {
         'hrsh7th/cmp-nvim-lsp',
         'williamboman/mason.nvim',
         'williamboman/mason-lspconfig.nvim',
         { 'folke/neoconf.nvim', cmd = 'Neoconf', config = true },
         { 'folke/neodev.nvim', opts = {} },
      },
      config = function()
         capabilities = vim.tbl_deep_extend(
            'force',
            vim.lsp.protocol.make_client_capabilities(),
            require('cmp_nvim_lsp').default_capabilities()
         )

         require('mason').setup {}
         require('mason-lspconfig').setup {
            ensure_installed = {},
            automatic_installation = true,
            handlers = {
               -- default handler
               function (server_name) -- default handler (optional)
                  require('lspconfig')[server_name].setup {
                     -- capabilities = capabilities,
                  }
               end,

               -- ['rust_analyzer'] = function ()
               --    require('rust-tools').setup {}
               -- end,

               ['lua_ls'] = function ()
                  local lspconfig = require('lspconfig')
                  lspconfig.lua_ls.setup {
                     -- capabilities = capabilities,
                     -- on_attach = function(_, bufnr)
                     --    -- km.lsp(bufnr)
                     --    vim.notify('buffer number is ' .. tostring(bufnr))
                     -- end,
                     settings = {
                        Lua = {
                           completion = {
                              callSnippet = 'Replace',
                           },
                           diagnostics = {
                              globals = { 'vim' },
                              disable = { 'missing-fields' },
                           },
                        },
                     },
                  }
               end,
            },
         }

         local lspconfig = require 'lspconfig'

         -- TODO: Make this my own
         --       - https://github.com/nvim-telescope/telescope.nvim
         --       - :h lsp
         --       - :h lsp-inlay_hint
         --
         vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(event)
               local map = function(keys, func, desc)
                  vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
               end

               local client = vim.lsp.get_client_by_id(event.data.client_id)

               if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                  map('<leader>th', function()
                  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                  end, 'toggle inlay hints')
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
               map('<leader>ca', vim.lsp.buf.code_action, 'code action')

               -- Opens a popup that displays documentation about the word under
               -- your cursor. See :help K for why this keymap was chosen.
               map('K', vim.lsp.buf.hover, 'hover documentation')

               map('gD', vim.lsp.buf.declaration, 'goto declaration')

            end,
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
            desc = 'Get rid of this stupid thing or embrace it?'
         })

      end,
   },



   --   -- Configure Haskell Language Server
   --   lspconfig.hls.setup {
   --      capabilities = capabilities,
   --      on_attach = function(_, bufnr)
   --         km.lsp(bufnr)
   --      end,
   --      settings = {
   --         hls = {
   --            filetypes = { 'haskell', 'lhaskell', 'cabal' },
   --            on_attach = function(_, bufnr)
   --               km.lsp(bufnr)
   --               km.haskell(bufnr)
   --            end,
   --         },
   --      },
   --   }

   --   -- Manually configure lsp client for python-lsp-server,
   --   -- using jdhao configs as a starting point.
   --   lspconfig.pylsp.setup {
   --      capabilities = capabilities,
   --      on_attach = function(_, bufnr)
   --         km.lsp(bufnr)
   --      end,
   --      flags = { debounce_text_changes = 200 },
   --      settings = {
   --         pylsp = {
   --            plugins = {
   --               -- formatter options
   --               black = { enabled = false },
   --               autopep8 = { enabled = false },
   --               yapf = { enabled = false },
   --               -- linter options
   --               pylint = { enabled = false },
   --               ruff = { enabled = true },
   --               pyflakes = { enabled = false },
   --               pycodestyle = { enabled = false },
   --               -- type checker
   --               pylsp_mypy = {
   --                  enabled = true,
   --               },
   --               -- refactoring
   --               rope = { enable = true },
   --            },
   --         },
   --      },
   --   }



   -- {
   --    'mfussenegger/nvim-dap',
   --    dependencies = {
   --       -- Creates a beautiful debugger UI
   --       'rcarriga/nvim-dap-ui',
   --
   --       -- Required dependency for nvim-dap-ui
   --       'nvim-neotest/nvim-nio',
   --
   --       -- Installs the debug adapters for you
   --       'williamboman/mason.nvim',
   --       'jay-babu/mason-nvim-dap.nvim',
   --
   --       -- Add your own debuggers here
   --       'leoluz/nvim-dap-go',
   --    },
   --    config = function()
   --       local dap = require 'dap'
   --       local dapui = require 'dapui'
   --
   --       require('mason-nvim-dap').setup {
   --          -- Makes a best effort to setup the various debuggers with
   --          -- reasonable debug configurations
   --          automatic_installation = true,
   --
   --          -- You can provide additional configuration to the handlers,
   --          -- see mason-nvim-dap README for more information
   --          handlers = {},
   --
   --          -- You'll need to check that you have the required things installed
   --          -- online, please don't ask me how to install them :)
   --          ensure_installed = {
   --             -- Update this to ensure that you have the debuggers for the langs you want
   --             'delve',
   --          },
   --       }
   --
   --       -- Basic debugging keymaps, feel free to change to your liking!
   --       vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
   --       vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
   --       vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
   --       vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
   --       vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
   --       vim.keymap.set('n', '<leader>B', function()
   --          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
   --       end, { desc = 'Debug: Set Breakpoint' })
   --
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
   --
   --       -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
   --       vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
   --
   --       dap.listeners.after.event_initialized['dapui_config'] = dapui.open
   --       dap.listeners.before.event_terminated['dapui_config'] = dapui.close
   --       dap.listeners.before.event_exited['dapui_config'] = dapui.close
   --
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
