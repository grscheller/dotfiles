--[[ Configure parsers for treesitter to install, indicate what tools mason
     to install, what LSP servers to configure via nvim-lspconfig, and what
     null-ls builtins to configure via null-ls.nvim. ]]

-- Factoids:
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
-- The nvim-dap plugin is a DAP client.  It has no notion of "default" or
-- "builtin" configurations and must be configured for the dap server invoked,
-- usually by some build system.
--
-- The null-ls plugin acts like a language server by running external programs
-- like linters, formatters, syntax checkers and providing their output to
-- the built in Neovim LSP client.  It has a number of "built in"
-- configuratinons for this.  Users can also define their own configurations.
-- I suspect this plugin configures nvim's builtin LSP client directly itself.
--
-- Mason will install all keys from the mason tables below.  The keys used
-- are lspconfig, dap, and null-ls builtin names, not Mason package names.
--
-- Other plugins, like nvim-metals or rust-tools.nvim, can either involk
-- lspconfig, dap, and null-ls themselves, or configure the Neovim LSP client
-- directly.

-- Note: The PATH inherited from the shell ends ~/.local/share/nvim/mason/bin
--       ensuring nvim can find mason installed tools for lspconfig.  System
--       installed tools will take presedent.
--
-- Note: Package managers and configuration tools should not be too tightly
--       coupled together with each other.

local M = {}

-- document reasons for true and false choices
local auto = true    -- automatically config via lspconfig or null-ls
local man = false    -- manually configure
local tool = false   -- configured via another tool
local ignore = false -- place holder

-- lspconfig table: if true, configure with nvim-lspconfig
M.LspTbl = {
   mason = {
      groovyls = ignore,
      html = auto,
      jsonls = auto,
      marksman = auto,
      zls = auto,
   },
   system = {
      bashls = auto,
      clangd = auto,
      gopls = ignore,
      hls = auto,
      lua_ls = auto,
      metals = tool,         -- nvim-metals configures LSP client directly
      pyright = auto,
      rust_analyzer = tool,  -- rust-tools configures using nvim-lspconfig
      taplo = auto,
      zls = auto,
   },
}

-- nvim-dap table: must be configured manually or via another tool
M.DapTbl = {
   mason = {
      bash = man,
      cppdbg = man,
      codelldb = man,
   },
   system = {},
}

-- null-ls table: if true builtins configured for null-ls
M.BuiltinTbls = {
   code_actions = {
      mason = {
      },
      system = {
      },
   },
   completion = {
      mason = {
      },
      system = {
      },
   },
   diagnostics = {
      mason = {
         markdownlint = auto,
      },
      system = {
         cppcheck = auto,
         cpplint = auto,
         selene = auto,
         yamllint = auto,
      },
   },
   formatting = {
      mason = {
      },
      system = {
         stylua = auto,
      },
   },
   hover = {
      mason = {
      },
      system = {
      },
   },
}

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

return M
