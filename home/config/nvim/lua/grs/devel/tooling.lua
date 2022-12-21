--[[ Software Development Tooling ]]

local keymaps = require 'grs.conf.keybindings'
local confMason = require 'grs.conf.mason'
local Vim = require 'grs.lib.Vim'
local utilLspconf = require 'grs.util.lspconf'
local utilDap = require 'grs.util.dap'
local utilNullLs = require 'grs.util.nullLs'

local msg = Vim.msg_hit_return_to_continue
local cmd = Vim.api.nvim_command
local m = confMason.MasonEnum
local LspTbl = confMason.LspSrvTbl

-- Initialize LSP, DAP & Null-ls, also auto-configure servers & builtins.

local lspconf, capabilities = utilLspconf.setup()
local dap, dap_ui_widgets = utilDap.setup()
local nullLs = utilNullLs.setup()
if not (lspconf and dap and nullLs and capabilities) then
   return
end

-- Manual LSP, DAP, and Null-ls configurations as well as
-- other development environment configurations.

--[[ Lua Configuration - affected by neodev.nvim ]]
if LspTbl.system.sumneko_lua == m.man or LspTbl.mason.sumneko_lua == m.man then
   lspconf['sumneko_lua'].setup {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
         keymaps.lsp_kb(client, bufnr)
         cmd [[setlocal shiftwidth=3 softtabstop=3 expandtab]]
      end,
      settings = {
         Lua = {
            completion = { callSnippet = 'Replace' },
         },
      },
   }
end

--[[ Haskell Configuration ]]
if LspTbl.system.hls == m.man or LspTbl.mason.hls == m.man then
   lspconf['hls'].setup {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
         keymaps.lsp_kb(client, bufnr)
         keymaps.haskell_kb(bufnr)
         cmd [[setlocal shiftwidth=2 softtabstop=2 expandtab]]
      end,
   }
end

--[[ Python Configuration - both pipenv and pynvim need to be installed. ]]
Vim.g.python3_host_prog = string.format('%s%s',
   os.getenv('HOME'),
   '/.local/share/pyenv/shims/python')

--[[ Rust-Tools directly configures lspconfig

     Following: https://github.com/simrat39/rust-tools.nvim
                https://github.com/sharksforarms/neovim-rust
--]]
if LspTbl.system.rust_tools == m.man then
   local ok_rust, rust_tools = pcall(require, 'rust-tools')
   if ok_rust and dap then
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
               keymaps.lsp_kb(client, bufnr)
               keymaps.dap_kb(bufnr, dap, dap_ui_widgets)
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
   else
      msg 'Problem in tooling.lua with rust-tools'
   end
end

--[[ Scala Metals directly configures lspconfig

     Latest Metals Server: https://scalameta.org/metals/docs
     Following: https://github.com/scalameta/nvim-metals/discussions/39
                https://github.com/scalameta/nvim-metals/discussions/279

--]]
if LspTbl.system.scala_metals == m.man then
   local ok_metals, metals = pcall(require, 'metals')
   if ok_metals and dap then
      local metals_config = metals.bare_config()

      metals_config.settings = {
         showImplicitArguments = true,
         serverVersion = '0.11.9',
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
         keymaps.lsp_kb(client, bufnr)
         keymaps.metals_kb(bufnr, metals)
         keymaps.dap_kb(bufnr, dap, dap_ui_widgets)
         cmd [[setlocal shiftwidth=2 softtabstop=2 expandtab]]
         cmd [[setlocal shiftwidth=2 softtabstop=2 expandtab]]
      end

      local scala_metals_group =
      Vim.api.nvim_create_augroup('scala-metals', { clear = true })

      Vim.api.nvim_create_autocmd('FileType', {
         pattern = { 'scala', 'sbt' },
         callback = function() metals.initialize_or_attach(metals_config) end,
         group = scala_metals_group,
      })
   else
      msg 'Problem in tooling.lua with scala metals'
   end
end