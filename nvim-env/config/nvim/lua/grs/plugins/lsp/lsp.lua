--[[ Configure LSP client with lspconfig & auto_install servers with lazy-lsp ]]

-- To provide overrides to customize the default configurations
-- pushed to LSP servers. TODO: Finish replacing null-ls with
-- mfussenegger/nvim-lint & mhartington/formatter.nvim.

local km = require 'grs.config.keymaps'

return {

   {
      -- Manually installed LSP servers configured via lspconfig.
      -- See https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
      -- for a list of the LSP server names and configuration defaults.
      'neovim/nvim-lspconfig',
      dependencies = {
         { 'folke/neoconf.nvim', cmd = 'Neoconf', config = true },
         { 'folke/neodev.nvim', opts = {} },
      },
      config = function()
         local lspconfig = require 'lspconfig'
         local capabilities = require('cmp_nvim_lsp').default_capabilities()

         -- needs to run before configuring any LSP servers via lspconfig
         require('neoconf').setup {
            experimental = { pathStrict = true },
         }

         -- Configure Neovim builtin lsp client with the default configurations
         -- provided by the lspconfig pluggin.
         local defaultConfiguredLspServers = {
            'bashls',
            'clangd',
            'lua_ls',
            'zls',
         }

         for _, lspServer in ipairs(defaultConfiguredLspServers) do
            lspconfig[lspServer].setup {
               capabilities = capabilities,
               on_attach = function(_, bufnr)
                  km.lsp(bufnr)
               end,
            }
         end

         -- Configure Haskell Language Server
         lspconfig.hls.setup {
            capabilities = capabilities,
            on_attach = function(_, bufnr)
               km.lsp(bufnr)
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

         -- Manually configure lsp client for python-lsp-server,
         -- using jdhao configs as a starting point.
         --   ruff linter (pip)
         --   black formatter (pip)
         --   jedi auto completion (pacman)
         lspconfig.pylsp.setup {
            capabilities = capabilities,
            on_attach = function(_, bufnr)
               km.lsp(bufnr)
            end,
            flags = { debounce_text_changes = 200 },
            settings = {
               pylsp = {
                  plugins = {
                     -- formatter options
                     black = { enabled = false },
                     autopep8 = { enabled = false },
                     yapf = { enabled = true },
                     -- linter options
                     pylint = { enabled = false, executable = "pylint" },
                     ruff = { enabled = true },
                     pyflakes = { enabled = false },
                     pycodestyle = { enabled = false },
                     -- type checker
                     pylsp_mypy = {
                        enabled = true,
                        overrides = {
                           "--python-executable",
                           vim.g.python3_host_prog,
                           report_progress = true,
                           live_mode = false,
                        },
                     },
                     -- auto-completion options
                     jedi_completion = { fuzzy = true },
                     -- import sorting
                     isort = { enabled = true },
                     -- refactoring
                     rope = { enable = true },
                  },
               },
            },
         }
      end,
   },

   {
      -- LSP servers auto-installed with Nix & configured via lspconfig.
      -- See https://github.com/dundalek/lazy-lsp.nvim/blob/master/servers.md
      -- for a list of supported servers,
      'dundalek/lazy-lsp.nvim',
      dependencies = {
         'neovim/nvim-lspconfig',
      },
      event = { 'BufReadPre', 'BufNewFile' },
      config = function()
         local capabilities = require('cmp_nvim_lsp').default_capabilities()

         require('lazy-lsp').setup {
            excluded_servers = {
               'ccls',          -- using clangd instead
               'ltex',          -- tags JS keywords as spelling mistakes
               'sqls',          -- deprecated in lspconfig in favor of sqlls
               'rome',          -- misbehaving
               'vale',          -- not using vale for prose
               'zk',            -- not using Zettelkasten for note taking
            },
            preferred_servers = {
               hls = {},
               lua = {},
               java = {},
               markdown = { 'marksman' },
               python = {},
               scala = {},
               rust = {},
            },
            -- Default config passed to all servers to specify on_attach
            -- callback and other options.
            default_config = {
               flags = {
                  debounce_text_changes = 250,
               },
               on_attach = function(_, bufnr)
                  km.lsp(bufnr)
               end,
               capabilities = capabilities,
            },
            -- Additional configs for specific servers which will be merged
            -- into default lspconfig configs.
            configs = {},
         }
      end,
   },

}
