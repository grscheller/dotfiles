--[[ Config Neovim LSP client and Mason toolchain ]]

-- To provide overrides to customize the default configurations
-- pushed to LSP servers.

local km = require 'grs.config.keymaps'

return {

   { -- LSP Configuration & Plugins
      'neovim/nvim-lspconfig',
      dependencies = {
         -- Automatically install LSP's & related tools to Neovim's stdpath
         { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependents
         { 'williamboman/mason-lspconfig.nvim' },
         { 'WhoIsSethDaniel/mason-tool-installer.nvim' },

         -- Give user feedback on LSP activity
         { 'j-hui/fidget.nvim', opts = {} },

         -- Configures Lua LSP for your Neovim configs, runtime and plugins.
         -- Used for completion, annotations and signatures for Neovim API's.
         { 'folke/neoconf.nvim', cmd = 'Neoconf', config = true },
         { 'folke/neodev.nvim', opts = {} },
      },
      config = function()
         vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('grs-lsp-attach', { clear = true }),
            callback = function(event)
               local map = function(keys, func, desc)
                  vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
               end

               map('gd', require('telescope.builtin').lsp_definitions, 'goto definition')

               -- Find references for the word under your cursor.
               map('gr', require('telescope.builtin').lsp_references, 'goto references')

               -- Jump to the implementation of the word under your cursor.
               --  Useful when your language has ways of declaring types without an actual implementation.
               map('gI', require('telescope.builtin').lsp_implementations, 'goto implementation')

               -- Jump to the type of the word under your cursor.
               --  Useful when you're not sure what type a variable is and you want to see
               --  the definition of its *type*, not where it was *defined*.
               map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'type definition')

               -- Fuzzy find all the symbols in your current document.
               map('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'document symbols')

               -- Fuzzy find all the symbols in your current workspace.
               map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

               -- Rename the variable under your cursor. Most Language Servers support
               -- renaming across workspace files.
               map('<leader>rn', vim.lsp.buf.rename, 'rename')

               -- Execute a code action, usually cursor needs to be on top of an error or suggestion
               -- for this to activate.
               map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

               -- Opens a popup that displays documentation about the word under
               -- your cursor. See :help K for why this keymap was choosen.
               map('K', vim.lsp.buf.hover, 'Hover Documentation')

               -- Goto Declaration. For example, in C this would take you to the header.
               map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

               -- The following two autocommands are used to highlight references of the word under
               -- the cursor. See :help CursorHold for when this is executed. When the cursor is
               -- moved, the highlights will be cleared by the second autocommand.
               local client = vim.lsp.get_client_by_id(event.data.client_id)

               if client and client.server_capabilities.documentHighlightProvider then
                  local highlight_augroup = vim.api.nvim_create_augroup('grs-lsp-highlight', { clear = false })
                  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                     buffer = event.buf,
                     group = highlight_augroup,
                     callback = vim.lsp.buf.document_highlight,
                  })

                  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                     buffer = event.buf,
                     group = highlight_augroup,
                     callback = vim.lsp.buf.clear_references,
                  })

                  vim.api.nvim_create_autocmd('LspDetach', {
                     group = vim.api.nvim_create_augroup('grs-lsp-detach', { clear = true }),
                     callback = function(event2)
                        vim.lsp.buf.clear_references()
                        vim.api.nvim_clear_autocmds { group = 'grs-lsp-highlight', buffer = event2.buf }
                     end,
                  })
               end

               -- Sometimes inlay hints are unwanted. This autocommand is used to toggle them off.
               if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                  map('<leader>th', function()
                     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                  end, '[T]oggle Inlay [H]ints')
               end
            end,
         })

         --  Communicate new capabilities provided by nvim-cmp, to the LSP servers.
         local capabilities = vim.lsp.protocol.make_client_capabilities()
         capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

         -- Enable desired language servers
         local servers = {
            clangd = {},
            lua_ls = {
               filetypes = { 'lua', 'luau' },
               capabilities = capabilities,
               settings = {
                  Lua = {
                     completion = {
                        callSnippet = 'Replace',
                     },
                     -- uncomment below to ignore lua_ls's noisy `missing-fields` warnings
                     -- diagnostics = { disable = { 'missing-fields' } },
                  },
               },
            },
            tsserver = {},
         }

         --[[ Install the Mason toolchain

              - Mason: LSP, DAP, Linter, Formatter installer
                - use :Mason to launch GUI
               :Mason
             You can press `g?` for help in this menu. ]]

         require('mason').setup()
         require('mason-tool-installer').setup()
         require('mason-lspconfig').setup {
            handlers = {
               function(server_name)
                  local server = servers[server_name] or {}
                  server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                  require('lspconfig')[server_name].setup(server)
               end,
            },
         }
      end,
   },
}
