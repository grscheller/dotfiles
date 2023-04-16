--[[ Software Development Tooling ]]

local km = require 'grs.config.keymaps'
local confMason = require 'grs.config.mason'
local utilMason = require 'grs.util.mason'

local LspTbl = confMason.LspTbl
local m = confMason.MasonEnum

local grs_metals = {}

return {

   -- Neovim plugin to manage global & project-local settings
   {
      'folke/neoconf.nvim',
      cmd = 'Neoconf',
      config = true,
   },

   -- Neovim setup for init.lua and plugin development with
   -- full signature help, docs and completion for the nvim lua API.
   {
      'folke/neodev.nvim',
      opts = {
         experimental = { pathStrict = true },
      },
   },

   {
      'neovim/nvim-lspconfig',
      version = false,
      event = { 'BufReadPre', 'BufNewFile' },
      dependencies = {
         'folke/neoconf.nvim',
         'folke/neodev.nvim',
         'hrsh7th/cmp-nvim-lsp',
         'williamboman/mason.nvim',
         'jose-elias-alvarez/null-ls.nvim',
      },
      config = function()  -- Initialize LSP servers & Null-ls builtins
         local lspconf = require 'lspconfig'
         local capabilities = require('cmp_nvim_lsp').default_capabilities()

         -- Add LSP serves we are letting lspconfig automatically configure
         for _, lspServer in ipairs(utilMason.serverList(LspTbl, m.auto)) do
            lspconf[lspServer].setup {
               capabilities = capabilities,
               on_attach = function(_, bufnr)
                  km.lsp(bufnr)
               end,
            }
         end

         -- Initialize Null-ls builtins
         require('grs.util.nullLs').setup()

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
                  Lua = {
                     completion = {
                        callSnippet = 'Replace'
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
               on_attach = function(_, bufnr)
                  km.lsp(bufnr)
                  km.haskell(bufnr)
               end,
            }
         end

      end,
   },

   {
      -- Rust-Tools directly configures lspconfig
      --
      -- Initially followed both https://github.com/simrat39/rust-tools.nvim
      -- and https://github.com/sharksforarms/neovim-rust.
      --
      -- Todo: see https://davelage.com/posts/nvim-dap-getting-started/
      --           :help dap-widgets
      --
      'simrat39/rust-tools.nvim',
      dependencies = {
         'hrsh7th/cmp-nvim-lsp',
         'mfussenegger/nvim-dap',
         'neovim/nvim-lspconfig',
         'nvim-lua/plenary.nvim',
      },
      enabled = LspTbl.system.rust_tools == m.man,
      ft = { 'rust' },
      config = function()
         local dap = require 'dap'
         local dap_ui_widgets = require 'dap.ui.widgets'
         dap.configurations.rust = {
            {
               type = 'rust',
               request = 'launch',
               name = 'rt_lldb',
            },
         }
         require('rust-tools').setup {
            server = {
               capabilities = require('cmp_nvim_lsp').default_capabilities(),
               on_attach = function(_, bufnr)
                  km.lsp(bufnr)
                  km.dap(bufnr, dap, dap_ui_widgets)
               end,
            },
         }
      end
   },

   {
      -- Scala Metals directly configures lspconfig
      --    Latest Metals Server: https://scalameta.org/metals/docs
      --    Following: https://github.com/scalameta/nvim-metals/discussions/39
      --               https://github.com/scalameta/nvim-metals/discussions/279
      'scalameta/nvim-metals',
      dependencies = {
         'hrsh7th/cmp-nvim-lsp',
         'mfussenegger/nvim-dap',
         'neovim/nvim-lspconfig',
         'nvim-lua/plenary.nvim',
      },
      enabled = LspTbl.system.scala_metals == m.man,
      ft = { 'scala', 'sbt' },
      init = function()
         vim.api.nvim_create_autocmd('FileType', {
            pattern = { 'scala', 'sbt' },
            callback = function()
               grs_metals.metals.initialize_or_attach(grs_metals.config)
            end,
            group = vim.api.nvim_create_augroup('grs_scala_metals', {
               clear = true
            })
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
            grs_metals.metals.setup_dap()
            km.lsp(bufnr)
            km.metals(bufnr, grs_metals.metals)
            km.dap(bufnr, dap, dap_ui_widgets)
         end
      end,
   },
}
