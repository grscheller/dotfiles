--[[ LSP Configuration ]]

local autogrp = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local km = require 'grs.config.keymaps'
local configMason = require 'grs.config.mason'
local masonUtils = require 'grs.plugins.mason.utils'

local LspTbl = configMason.LspTbl
local m = configMason.MasonEnum

local grs_metals = {}

return {
   -- let LSP servers know about nvim.cmp completion capabilities
   {
      'hrsh7th/cmp-nvim-lsp',
      dependencies = {
         'hrsh7th/nvim-cmp',
      },
      event = { 'LspAttach' },
   },

   -- give feedback regarding LSP server progress
   {
      'j-hui/fidget.nvim',
      config = function()
         require('fidget').setup()
      end,
   },

   -- nvim-cmp source for neovim Lua API
   {
      'hrsh7th/cmp-nvim-lua',
      dependencies = {
         'hrsh7th/cmp-nvim-lsp',
      },
      ft = { 'lua' },
   },

   -- Neovim plugin to manage global & project-local settings
   {
      'folke/neoconf.nvim',
      cmd = 'Neoconf',
      config = true,
   },

   -- Setup for Neovim init.lua and plugin development with full
   -- signature help, docs and completion for the nvim lua API.
   {
      'folke/neodev.nvim',
      opts = {
         experimental = { pathStrict = true },
      },
   },

   -- auto/manual configure lsp servers and null-ls builtins
   {
      'neovim/nvim-lspconfig',
      version = false,
      event = { 'BufReadPre', 'BufNewFile' },
      dependencies = {
         'folke/neoconf.nvim',
         'folke/neodev.nvim',
         'j-hui/fidget.nvim',
         'hrsh7th/cmp-nvim-lsp',
         'jose-elias-alvarez/null-ls.nvim',
         'williamboman/mason.nvim',
      },
      config = function()  -- Initialize LSP servers & Null-ls builtins
         local lspconf = require 'lspconfig'
         local capabilities = require('cmp_nvim_lsp').default_capabilities()

         -- Add LSP serves we are letting lspconfig automatically configure
         for _, lspServer in ipairs(masonUtils.serverList(LspTbl, m.auto)) do
            lspconf[lspServer].setup {
               capabilities = capabilities,
               on_attach = function(_, bufnr)
                  km.lsp(bufnr)
               end,
            }
         end

         -- Initialize Null-ls builtins
         require('grs.plugins.lsp.nullLs').setup()

         -- Manual LSP, DAP, and Null-ls configurations as well as
         -- other development environment configurations.

         --[[ Lua Configuration - affected by neodev.nvim ]]
         if LspTbl.system.lua_ls == m.man or LspTbl.mason.lua_ls == m.man then
            lspconf['lua_ls'].setup {
               capabilities = capabilities,
               on_attach = function(_, bufnr)
                  km.lsp(bufnr)
               end,
               settings = {
                  Lua = { completion = { callSnippet = 'Replace' } },
               },
            }
         end

         --[[ Haskell Configuration ]]
         if LspTbl.system.hls == m.man or LspTbl.mason.hls == m.man then
            lspconf['hls'].setup {
               capabilities = capabilities,
               filetypes = { 'haskell', 'lhaskell', 'cabal' },
               on_attach = function(_, bufnr)
                  km.lsp(bufnr)
                  km.haskell(bufnr)
               end,
            }
         end

      end,
   },

   -- Rust-Tools directly configures lspconfig for rust-analyzer itself
   --
   -- Initially followed both https://github.com/simrat39/rust-tools.nvim
   -- and https://github.com/sharksforarms/neovim-rust.
   --
   -- Todo: see https://davelage.com/posts/nvim-dap-getting-started/
   --       and :help dap-widgets
   --       
   {
      'simrat39/rust-tools.nvim',
      dependencies = {
         'hrsh7th/cmp-nvim-lsp',
         'mfussenegger/nvim-dap',
         'saecki/crates.nvim',
         'nvim-lua/plenary.nvim',
         'nvim-telescope/telescope.nvim',
         'neovim/nvim-lspconfig',
         'j-hui/fidget.nvim',
      },
      enabled = LspTbl.system.rust_tools == m.man,
      ft = { 'rust' },
      init = function()
         autogrp('GrsRustTools', { clear = true })
      end,
      config = function()
         local dap = require 'dap'
         local dap_ui_widgets = require 'dap.ui.widgets'
         dap.configurations.rust = {
            { type = 'rust', request = 'launch', name = 'rt_lldb' },
         }
         local rt = require('rust-tools')
         rt.setup {
            tools = {
               runnables = { use_telescope = true },
               inlay_hints = {
                  auto = true,
                  show_parameter_hints = false,
                  parameter_hints_prefix = '',
                  other_hints_prefix = '',
               },
            },
            -- The server table contains nvim-lspconfig opts
            -- overriding the defaults set by rust-tools.nvim.
            server = {
               capabilities = require('cmp_nvim_lsp').default_capabilities(),
               on_attach = function(_, bufnr)
                  -- set up keymaps
                  km.lsp(bufnr)
                  km.rust(bufnr, rt)
                  km.dap(bufnr, dap, dap_ui_widgets)

                  -- show diagnostic popup when cursor lingers on line with errors
                  autocmd('CursorHold', {
                     buffer = bufnr,
                     callback = function()
                        vim.diagnostic.open_float {
                           bufnr = bufnr,
                           scope = 'line',
                           focusable = false,
                        }
                     end,
                     group = autogrp('GrsRustTools', { clear = false }),
                     desc = 'Open floating diagnostic window for Rust-Tools',
                  })
               end,
            },
         }
      end
   },

   -- Scala Metals directly configures lspconfig itself
   --    Latest Metals Server: https://scalameta.org/metals/docs
   --    Following: https://github.com/scalameta/nvim-metals/discussions/39
   --               https://github.com/scalameta/nvim-metals/discussions/279
   {
      'scalameta/nvim-metals',
      dependencies = {
         'hrsh7th/cmp-nvim-lsp',
         'mfussenegger/nvim-dap',
         'neovim/nvim-lspconfig',
         'nvim-lua/plenary.nvim',
         'j-hui/fidget.nvim',
      },
      enabled = LspTbl.system.scala_metals == m.man,
      ft = { 'scala', 'sbt' },
      init = function()
         autocmd('FileType', {
            pattern = { 'scala', 'sbt' },
            callback = function()
               grs_metals.metals.initialize_or_attach(grs_metals.config)
            end,
            group = autogrp('GrsMetals', { clear = true }),
         })
      end,
      config = function()
         grs_metals.metals = require 'metals'
         grs_metals.config = grs_metals.metals.bare_config()
         grs_metals.config.settings = {
            showImplicitArguments = true,
            serverVersion = '0.11.11',
         }
         grs_metals.config.capabilities = require('cmp_nvim_lsp').default_capabilities()
         grs_metals.config.init_options.statusBarProvider = 'on'

         local dap = require 'dap'
         local dap_ui_widgets = require 'dap.ui.widgets'
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
         function grs_metals.config.on_attach(_, bufnr)
            -- set up dap
            grs_metals.metals.setup_dap()

            -- set up keymaps
            km.lsp(bufnr)
            km.metals(bufnr, grs_metals.metals)
            km.dap(bufnr, dap, dap_ui_widgets)

            -- show diagnostic popup when cursor lingers on line with errors
            autocmd('CursorHold', {
               buffer = bufnr,
               callback = function()
                  vim.diagnostic.open_float {
                     bufnr = bufnr,
                     scope = 'line',
                     focusable = false,
                  }
               end,
               group = autogrp('GrsMetals', { clear = false }),
               desc = 'Open floating diagnostic window for Scala-Metals',
            })
         end
      end,
   },

}
