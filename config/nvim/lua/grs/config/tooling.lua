-- Configurations for Treesitter parsers to install,
-- LSP servers to directly configure via lspconfig,
-- Null-Ls builtins to configure directly with 
-- and LSP servers, Null-LS builtDAP

local M = {}

-- Treesitter parsers to ensure installed
M.treesitter_ensure_installed = {
   'awk',
   'bash',
   'c',
   'clojure',
   'cmake',
   'cpp',
   'css',
   'diff',
   'fish',
   'fortran',
   'git_rebase',
   'gitattributes',
   'gitcommit',
   'gitignore',
   'go',
   'haskell',
   'html',
   'java',
   'javascript',
   'json',
   'jsonc',
   'julia',
   'kotlin',
   'latex',
   'llvm',
   'lua',
   'make',
   'markdown',
   'markdown_inline',
   'norg',
   'ocaml',
   'python',
   'query',
   'r',
   'racket',
   'regex',
   'rust',
   'scala',
   'toml',
   'tsx',
   'typescript',
   'vim',
   'vimdoc',
   'yaml',
   'zig',
}

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
-- "default" or "builtin" configurations and must be configured for each
-- dap server it invokes.
--
-- The null-ls plugin is a language server that can run external programs like
-- linters, formatters, syntax checkers and provide their information to the
-- built in Neovim lsp client.  It has a number of "built in" configuratinons
-- for this.  Users can also define own such configurations.

-- Mason will install all keys from the mason tables below.  The keys used
-- are lspconfig, dap, and null-ls builtin names, not Mason package names.
--
-- if true, lspconfig is directly involked to configure
M.LspTbl = {
   mason = {
      groovyls = false,
      html = true,
      jsonls = true,
      marksman = true,
      zls = true,
   },
   system = {
      bashls = true,
      clangd = true,
      gopls = false,
      hls = true,
      pyright = true,
      rust_analyzer = false,  -- Rust-Tools configures this
      lua_ls = true,
      taplo = true,
      yamlls = true,
      zls = true,
   },
}

-- nvim-dap table: must be manually configured (directly of via another tool)
M.DapTbl = {
   mason = {
      bash = false,
      cppdbg = false,
      codelldb = false,
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
         markdownlint = true,
      },
      system = {
         cppcheck = true,
         cpplint = true,
         selene = true,
      },
   },
   formatting = {
      mason = {},
      system = {
         stylua = true,
      },
   },
   hover = {
      mason = {},
      system = {},
   },
}

return M
