--[[ Config Neovim LSP client leveraging the Mason toolchain ]]

--[[ My goal is to get:
     - mason
       - to ensure it installs what I explicitly tell it to install
       - and not to install anything else (at least initially)
     - mason-lspconfig
       - to configure both mason installed LSP servers
       - to trigger other plugins to install/configure LSP/DAP servers & tools
         - either by using nvim-lspconf directly themselves (rust-tools)
         - or directly with the Neovim LSP client itself (scala metals)
     - nvim.lspconfig
       - to configure locally installed LSP servers
--]]

local km = require 'grs.config.keymaps'

return {

   -- Give user feedback on LSP activity
   {
      'j-hui/fidget.nvim',
      event = 'LspAttach',
      opts = {},
   },

   -- LSP Configuration
   {
      'neovim/nvim-lspconfig',
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
         'hrsh7th/cmp-nvim-lsp',
         'williamboman/mason.nvim',
         'williamboman/mason-lspconfig.nvim',
         { 'folke/neoconf.nvim', cmd = 'Neoconf', config = true },
         'folke/neodev.nvim',
      },
      config = function()
         require('neodev').setup {}

         require('mason').setup {
            ui = {
                  icons = {
                     package_installed = "✓",
                     package_pending = "➜",
                     package_uninstalled = "✗"
                  }
            }
         }

         local capabilities = vim.tbl_deep_extend('force',
            vim.lsp.protocol.make_client_capabilities(),
            require('cmp_nvim_lsp').default_capabilities()
         )

         require('mason-lspconfig').setup {
            ensure_installed = {
               'taplo',
               'lua_ls',
               'rust_analyzer',
            },
            automatic_installation = {
               exclude = {
                  'pylsp',
               }
            },
            handlers = {
               -- default handler
               function (server_name) -- default handler (optional)
                  require('lspconfig')[server_name].setup {
                     capabilities = capabilities,
                     on_attach = function(client, bufnr)
                        km.lsp(client, bufnr)
                     end,
                  }
               end,

               -- use rust-tools to set of rust-analyzer instead
               --   Mason seems to only configure what it installs. Will
               --   need to use Mason to install rust_analyzer.
               --
               -- TODO: replace with mrcjkb/rustaceanvim
               -- 
               -- ['rust_analyzer'] = function ()
               --    require('rust-tools').setup {}
               -- end,

               -- Configure Haskell Language Server
               ['hls'] = function ()
                  require('lspconfig').hls.setup {
                     capabilities = capabilities,
                     filetypes = { 'haskell' },
                     on_attach = function(client, bufnr)
                        km.lsp(client, bufnr)
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
               end,

               -- Lua language server
               ['lua_ls'] = function ()
                  require('lspconfig').lua_ls.setup {
                     capabilities = capabilities,
                     filetypes = { 'lua', 'luau' },
                     on_attach = function(client, bufnr)
                        km.lsp(client, bufnr)
                     end,
                     settings = {
                        Lua = {
                           completion = {
                              callSnippet = 'Replace',
                           },
                           diagnostics = {
                              globals = { 'vim' },
                              disable = { 'missing-fields' },
                           },
                           hint = { enable = true },
                        },
                     },
                  }
               end,
            },
         }

         local lsp = require('lspconfig')

         -- Configure Python Language Server - not installed by mason
         lsp.pylsp.setup {
            capabilities = capabilities,
            filetypes = { 'python' },
            on_attach = function(client, bufnr)
               km.lsp(client, bufnr)
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
                     pylsp_inlay_hints = { enable = true },
                  },
               },
            },

         }
      end,
   },
}
--
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
