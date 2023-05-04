--[[ Drives LSP, Null-Ls, and DAP related Client/Server Configurations ]]

-- Using both Mason and the underlying os/environment for server install.
--
-- The Mason plugin is a 3rd party package manager for language servers,
-- null-ls built-ins (like linters or formatters), and dap servers.  It
-- only installs these servers, it does not configure them.
--
-- The nvim-lspconfig plugin is is used to configure the built-in Neovim LSP
-- client.  It provides "cooked in" configurations for a variety of lsp servers.
-- These server specific configurations can be adjusted by providing their setup
-- function an opts table, but otherwise are fairly generic.
--
-- The nvim-dap plugin is a DAP client.  It has no notion of any sort of
-- "default" or "builtin" configurations.  It must be configured for each
-- dap server it invokes.
--
-- The null-ls plugin is a language server that can run external programs like
-- linters, formatters, syntax checkers and provide their information to the
-- built in Neovim lsp client.  It has a number of "built in" configuratinons
-- for this.  Users can also define own configurations.
--
-- Mason will install packages from the mason tables not marked m.ignore.
-- The names used below are lspconfig, dap, and null-ls names, not Mason
-- package names.
--
-- TODO: split m.man up into m.man & m.other
--
local M = {}

M.MasonEnum = {
   auto = 1, -- nvim configuration invokes either lspconfig or null-ls (for built-ins)
   man = 2, -- user manually configures nvim LSP client, null-ls, or dap
   other = 3, -- configured with 3rd party tool (like Scala-Metals or Rust-Tools)
   install = 4, -- install but don't configure, 
   ignore = 5, -- don't install nor configure
}

local m = M.MasonEnum

--[[ The next 3 tables are the main drivers for lspconfig, dap, and null-ls ]]

-- lspconfig table
M.LspTbl = {
   mason = {
      groovyls = m.auto,
      html = m.auto,
      jsonls = m.auto,
      marksman = m.auto,
      zls = m.auto,
   },
   system = {
      bashls = m.auto,
      clangd = m.auto,
      gopls = m.auto,
      hls = m.man,
      pyright = m.auto,
      rust_analyzer = m.install,
      rust_tools = m.man,   -- directly calls lspconfig and dap
      scala_metals = m.man, -- directly calls dap & configures Neovim LSP client 
      lua_ls = m.man,
      taplo = m.auto,
      yamlls = m.auto,
      zls = m.auto,
   },
}

-- nvim-dap table
M.DapTbl = {
   mason = {
      bash = m.install,
      cppdbg = m.install,
      codelldb = m.install,
   },
   system = {},
}

-- NullLs builtin table
M.BuiltinTbls = {
   code_actions = {
      mason = {},
      system = {},
   },
   completions = {
      mason = {},
      system = {},
   },
   diagnostics = {
      mason = {
         markdownlint = m.auto,
      },
      system = {
         cppcheck = m.auto,
         cpplint = m.auto,
         selene = m.auto,
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

return M
