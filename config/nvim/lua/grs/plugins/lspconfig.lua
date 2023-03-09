--[[ Software Development Tooling ]]

return {

   {
      'neovim/nvim-lspconfig',
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
         { 'folke/neoconf.nvim', cmd = 'Neoconf', config = true },
         { 'folke/neodev.nvim', opts = { experimental = { pathStrict = true } } },
         'hrsh7th/cmp-nvim-lsp',
         'williamboman/mason.nvim',
         'mfussenegger/nvim-dap',
         'jose-elias-alvarez/null-ls.nvim',
         'simrat39/rust-tools.nvim',
         'scalameta/nvim-metals',
      },
      config = function()
         local keymaps = require 'grs.config.keymaps'
         local confMason = require 'grs.config.mason'
         local utilLspconfig = require 'grs.plugins.util.lspconfig'
         local utilDap = require 'grs.plugins.util.dap'
         local utilNullLs = require 'grs.plugins.util.nullLs'

         local m = confMason.MasonEnum
         local LspTbl = confMason.LspTbl

         -- Initialize LSP, DAP & Null-ls & auto-configure servers & builtins
         local lspconf, capabilities = utilLspconfig.setup()
         local dap, dap_ui_widgets = utilDap.setup()
         utilNullLs.setup()

         -- Manual LSP, DAP, and Null-ls configurations as well as
         -- other development environment configurations.

         --[[ Lua Configuration - affected by neodev.nvim ]]
         if LspTbl.system.sumneko_lua == m.man or LspTbl.mason.sumneko_lua == m.man then
            lspconf['sumneko_lua'].setup {
               capabilities = capabilities,
               on_attach = function(client, bufnr)
                  keymaps.lsp_km(client, bufnr)
               end,
               settings = {
                  Lua = {
                     completion = { callSnippet = 'Replace' },
                     diagnostics = {
                        globals = { 'vim' },
                     },
                  },
               },
            }
         end

         --[[ Haskell Configuration ]]
         if LspTbl.system.hls == m.man or LspTbl.mason.hls == m.man then
            lspconf['hls'].setup {
               capabilities = capabilities,
               filetypes = { 'haskell', 'lhaskell', 'cabal' },
               on_attach = function(client, bufnr)
                  keymaps.lsp_km(client, bufnr)
                  keymaps.haskell_km(bufnr)
               end,
            }
         end

         --[[ Rust-Tools directly configures lspconfig

              Following: https://github.com/simrat39/rust-tools.nvim
                         https://github.com/sharksforarms/neovim-rust
         --]]
         if LspTbl.system.rust_tools == m.man then
            local rust_tools = require 'rust-tools'
            dap.configurations.rust = {
               {
                  type = 'rust',
                  request = 'launch',
                  name = 'rt_lldb',
               },
            }
            rust_tools.setup {
               runnables = {
                  use_telescope = true,
               },
               server = {
                  capabilities = capabilities,
                  on_attach = function(client, bufnr)
                     keymaps.lsp_km(client, bufnr)
                     keymaps.dap_km(bufnr, dap, dap_ui_widgets)
                  end,
                  standalone = true,
               },
               dap = {
                  adapter = {
                     type = 'executable',
                     command = 'lldb-vscode',
                     name = 'rt_lldb',
                  },
               },
            }
         end

         --[[ Scala Metals directly configures lspconfig

              Latest Metals Server: https://scalameta.org/metals/docs
              Following: https://github.com/scalameta/nvim-metals/discussions/39
                         https://github.com/scalameta/nvim-metals/discussions/279

         --]]
         if LspTbl.system.scala_metals == m.man then
            local metals = require 'metals'
            local metals_config = metals.bare_config()

            metals_config.settings = {
               showImplicitArguments = true,
               serverVersion = '0.11.11',
            }
            metals_config.capabilities = capabilities
            metals_config.init_options.statusBarProvider = 'on'

            function metals_config.on_attach(client, bufnr)
               dap.configurations.scala = {
                  {
                     type = 'scala',
                     request = 'launch',
                     name = 'RunOrTest',
                     metals = {
                        runType = 'runOrTestFile',
                        --args = { 'firstArg', 'secondArg, ...' }
                     },
                  },
                  {
                     type = 'scala',
                     request = 'launch',
                     name = 'Test Target',
                     metals = {
                        runType = 'testTarget',
                     },
                  },
               }
               metals.setup_dap()
               keymaps.lsp_km(client, bufnr)
               keymaps.metals_km(bufnr, metals)
               keymaps.dap_km(bufnr, dap, dap_ui_widgets)
            end

            local scala_metals_group = vim.api.nvim_create_augroup('scala-metals', { clear = true })

            vim.api.nvim_create_autocmd('FileType', {
               pattern = { 'scala', 'sbt' },
               callback = function()
                  metals.initialize_or_attach(metals_config)
               end,
               group = scala_metals_group,
            })
         end
      end,
   }

}
