--[[ Mason Related Configurations ]]

-- Using Mason as a 3rd party package manager when a server, linter or formatter
-- is not provided in the underlying os/environment.

local M = {}

M.MasonEnum = {
   auto = 1,     -- automatically configure with lspconf or null-ls
   man = 2,      -- manually configure
   install = 3,  -- install but don't configure
   ignore = 4,   -- don't install nor configure
}

local m = M.MasonEnum

--[[ The next 3 tables are the main drivers for lspconfig, dap, and null-ls ]]

-- Lspconfig uses default configurations for items marked m.auto.  Mason installs packages in
-- the Mason tables not marked m.ignore.  Both lists use the LSP module (lspconfig) names, not the
-- Mason package names.  In system table, anything not either m.auto or m.man is just informational.
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
      rust_tools = m.man,      -- will directly use lspconfig and dap
      scala_metals = m.man,    -- will directly use lspconfig and dap
      lua_ls = m.man,
      taplo = m.auto,
      yamlls = m.auto,
      zls = m.auto,
   },
}

-- Nvim-dap itself does not have any "default" or "builtin" configurations, hence there is no reason
-- to mark anything as m.auto.  Mason installs packages from the mason tables not marked m.ignore.
-- Names used are DAP (nvim-dap) names, not Mason package names.  For system table, m.man will turn
-- on a manual config if it exists.
M.DapTbl = {
   mason = {
      bash = m.install,
      cppdbg = m.install,
   },
   system = {},
}

M.BuiltinTbls = {
   -- Null-ls uses default "builtin" configurations for certain tools, items marked m.auto will be
   -- configured with these builtin configs.  Mason will installs packages in the mason tables not
   -- marked m.ignore.  Names used are Null-ls names, not Mason package names.  For system tables,
   -- anything not m.auto is just informational.
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
      mason = {
         lua_format = m.auto,
      },
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
