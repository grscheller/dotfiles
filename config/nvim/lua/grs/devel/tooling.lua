--[[ Software Devel Tooling ]]

--[[
     Using Mason as a 3rd party package manager (pm).

     When a server/tool is not provided in the underlying
     os/environment by some package manager such as
     Pacman, Apt, Nix, Brew, SDKMAN, Cocolately, MSYS2, ...
     or by Packer (packer.nvim).

     The overiding principle is to configure only what I
     actually use, not to install and configure everything
     I might possibly like to use someday.

--]]

local libTooling = require 'grs.devel.lib.libTooling'

local m = libTooling.configEnum -- (auto, manual, install, ignore)

--[[ The next 3 tables are the main drivers for lspconfig, dap, and null-ls ]]

-- Lspconfig uses a default configurations for items marked m.auto. 
-- Mason installs packages in the mason tables not marked m.ignore.
-- Both lists use the LSP module (lspconfig) names, not Mason package names.
-- For system table, anything not m.auto is really just informational.
local LspServerTbl = {
   mason = {
      cssls = m.auto,
      groovyls = m.ignore,
      html = m.auto,
      jsonls = m.auto,
      marksman = m.auto,
      rust_analyzer = m.manual,
      zls = m.auto,
   },
   system = {
      bashls = m.auto,
      clangd = m.auto,
      gopls = m.auto,
      hls = m.manual,
      pyright = m.ignore,
      rust_tools = m.manual,   -- uses lspconfig and dap
      scala_metals = m.manual, -- uses lspconfig and dap
      sumneko_lua = m.manual,  -- right now geared to editing Neovim configs
      taplo = m.auto,
      yamlls = m.auto,
   },
}

-- Nvim-dap itself does not have any "default" or "builtin" configurations.
-- There is no reason marking anything as m.auto. 
-- Mason installs packages from the mason tables not marked m.ignore.
-- Names used are DAP (nvim-dap) names, not Mason package names.
-- For system table, m.manual will turn on a manual config if it exists.
local DapServerTbl = {
   mason = {
      bash = m.install,
      cppdbg = m.install,
   },
   system = {
      rust_tools = m.manual,
      scala_metals = m.manual,
   },
}

local BuiltinToolTbls = {
   -- Null-ls uses default "builtin" configurations for certain tools,
   -- items marked m.auto will be configured with these builtin configs. 
   -- Mason will installs packages in the mason tables not marked m.ignore.
   -- Names used are Null-ls (null-ls.nvim) names, not Mason package names.
   -- For system tables, anything not m.auto is just informational.
   code_actions = {
      mason = {},
      system = {}
   },
   completions = {
      mason = {},
      system = {}
   },
   diagnostics = {
      mason = {
         markdownlint = m.auto,
      },
      system = {
         cppcheck = m.auto,
         cpplint = m.auto,
      },
   },
   formatting = {
      mason = {},
      system = {
         stylua = m.auto,
      },
   },
   hover = {
      mason = {},
      system = {},
   },
}

local keymaps = require 'grs.core.keybindings'
local libVim = require 'grs.lib.libVim'
local libLsp = require 'grs.devel.lib.libLsp'
local libMason = require 'grs.devel.lib.libMason'
local libDap = require 'grs.devel.lib.libDap'
local libNullLs = require 'grs.devel.lib.libNullLs'

local msg = libVim.msg_hit_return_to_continue
local cmd = vim.api.nvim_command

-- Fetch select LSP & DAP Servers and Null-ls Builtins using Mason
libMason.setup(LspServerTbl, DapServerTbl, BuiltinToolTbls)

-- Initialize LSP, DAP & Null-ls, also auto-configure.servers & builtins.
local neodev, lspconf, capabilities = libLsp.setup(LspServerTbl)
local dap, dap_ui_widgets = libDap.setup()
local nullLs = libNullLs.setup(BuiltinToolTbls)

-- Manual LSP, DAP, and Null-ls configurations as well as other
-- development environment tweaks.
if not neodev then msg 'Warning: Neodev setup failed.' end
if not (lspconf and dap and nullLs and capabilities) then
   if not lspconf then msg 'Error: Setup LSP servers failed!' end
   if not dap then msg 'Error: Setup DAP servers failed!' end
   if not nullLs then msg 'Error: Setup null-ls builtins failed!' end
   if not capabilities then msg 'Error: Setup LSP complitions failed!' end
   return
end

--[[ Lua Configuration - affected by neodev.nvim ]]
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

--[[ Haskell Configuration ]]
if LspServerTbl.hls == m.manual then
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
vim.g.python3_host_prog = os.getenv 'HOME' .. '/.local/share/pyenv/shims/python'

--[[ Rust-Tools directly configures lspconfig

     Following: https://github.com/simrat39/rust-tools.nvim
                https://github.com/sharksforarms/neovim-rust
--]]
local ok_rust, rust_tools = pcall(require, 'rust-tools')
if ok_rust and dap and LspServerTbl.rust_tools == m.manual then
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
   if LspServerTbl.rust_tools == m.manual then
      msg 'Problem in tooling.lua with rust-tools'
   end
end

--[[ Scala Metals directly configures lspconfig

     Latest Metals Server: https://scalameta.org/metals/docs
     Following: https://github.com/scalameta/nvim-metals/discussions/39
                https://github.com/scalameta/nvim-metals/discussions/279

--]]
local ok_metals, metals = pcall(require, 'metals')
if ok_metals and dap and LspServerTbl.scala_metals == m.manual then
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
   vim.api.nvim_create_augroup('scala-metals', { clear = true })

   vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'scala', 'sbt' },
      callback = function() metals.initialize_or_attach(metals_config) end,
      group = scala_metals_group,
   })
else
   if LspServerTbl.scala_metals == m.manual then
      msg 'Problem in tooling.lua with scala metals'
   end
end
