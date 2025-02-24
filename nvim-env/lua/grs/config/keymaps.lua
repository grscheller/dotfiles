--[[ Which-key defined keymaps needed by multiple modules ]]

local M = {}

local check = function (client)
   if client then
      if type(client) == 'number' then
         client = vim.lsp.get_client_by_id(client)
      end
      if type(client) == 'table' then
         return client
      end
   end
   local msg = 'LSP: Failed to obtain handle to client'
   vim.notify(msg, vim.log.levels.ERROR)
   return nil
end

function M.set_lsp_keymaps(client, bufnr)
   client = check(client)
   if not client then
      return false
   end

   local wk = require 'which-key'
   local tb = require 'telescope.builtin'

   wk.add {
      { '<leader>c', group = 'code action', buffer = bufnr },
      { '<leader>ca', vim.lsp.buf.code_action, desc = 'code action', buffer = bufnr },
      { '<leader>cl', vim.lsp.codelens.refresh, desc = 'code lens refresh', buffer = bufnr },
      { '<leader>cr', vim.lsp.codelens.run, desc = 'code lens run', buffer = bufnr },
      { '<leader>d', group = 'document', buffer = bufnr },
      { '<leader>ds', tb.lsp_document_symbols, desc = 'document symbols', buffer = bufnr },
      { '<leader>f', group = 'format', buffer = bufnr },
      { '<leader>fl', vim.lsp.buf.format, desc = 'format with LSP', buffer = bufnr },
      { '<leader>g', group = 'goto', buffer = bufnr },
      { '<leader>gd', tb.lsp_definitions, desc = 'definitions', buffer = bufnr },
      { '<leader>gi', tb.lsp_implementations, desc = 'implementations', buffer = bufnr },
      { '<leader>gr', tb.lsp_references, desc = 'references', buffer = bufnr },
      { '<leader>w', group = 'workspace', buffer = bufnr },
      { '<leader>ws', tb.lsp_dynamic_workspace_symbols, desc = 'workspace symbols', buffer = bufnr },
      { '<leader>wa', vim.lsp.buf.add_workspace_folder, desc = 'add workspace folder', buffer = bufnr },
      { '<leader>wr', vim.lsp.buf.remove_workspace_folder, desc = 'remove workspace folder', buffer = bufnr},
      { '<leader>gD', vim.lsp.buf.declaration, desc = 'goto type declaration', buffer = bufnr },
      { '<leader>K', vim.lsp.buf.signature_help, desc = 'signature help', buffer = bufnr },
      { '<leader><leader>r', vim.lsp.buf.rename, desc = 'rename', buffer = bufnr },
      { 'K',         vim.lsp.buf.hover, desc = 'hover document', buffer = bufnr },
   }

   -- Configure inlay hints if LSP supports it
   if client.supports_method('textDocument/inlayHint', { buffer = bufnr }) then
      vim.lsp.inlay_hint.enable(false, { buffer = bufnr })

      wk.add {
         {
            '<leader>ti',
            function ()
               vim.lsp.inlay_hint.enable(
                  not vim.lsp.inlay_hint.is_enabled { buffer = bufnr },
                  { buffer = bufnr }
               )

               if vim.lsp.inlay_hint.is_enabled { buffer = bufnr } then
                  local msg = 'LSP: inlay hints were enabled'
                  vim.notify(msg, vim.log.levels.info)
               else
                  local msg = 'LSP: inlay hints were disabled'
                  vim.notify(msg, vim.log.levels.info)
               end
            end,
            desc = 'toggle inlay hints',
            buffer = bufnr,
         }
      }

      local msg = string.format('LSP: Client = "%s" supports inlay hints', client.name)
      vim.notify(msg, vim.log.levels.INFO)
   end

   return true
end

function M.set_hls_keymaps(bufnr)
   local wk = require 'which-key'
   wk.add {
      '<leader>fh',
      "<cmd>'<,'>!stylish-haskell<cr>",
      desc = 'stylish haskell',
      mode = {'n', 'v'},
      buffer = bufnr
   }
end

-- Rust-Tools related keymaps
function M.set_rust_keymaps(bufnr)
   local rt = require('rust-tools')
   require('which-key').add {
      { '<leader><leader>R', group = 'rust tools', buffer = bufnr },
      { '<leader><leader>Rh', rt.hover_actions.hover_actions, desc = 'hover actions', buffer = bufnr },
      { '<leader><leader>Ra', rt.code_action_group.code_action_group, desc = 'code action group', buffer = bufnr },
   }
end

-- Scala Metals related keymaps
function M.set_metals_keymaps(bufnr)
   local metals = require 'metals'
   require('which-key').add {
      { '<leader><leader>M',  group = 'scala metals', buffer = bufnr },
      { '<leader><leader>Mh', metals.hover_worksheet, desc = 'hover worksheet', buffer = bufnr },
   }
end

--[[ DAP (Debug Adapter Protocol) related keymaps ]]

function M.set_dap_keymaps(bufnr)
   local dap = require 'dap'
   local dap_ui_widgets = require 'dap.ui.widgets'

   require('which-key').add {
      { '<bslash>c', dap.continue, desc = 'dap continue', buffer = bufnr },
      { '<bslash>h', dap_ui_widgets.hover, desc = 'dap hover', buffer = bufnr },
      { '<bslash>l', dap.run_last, desc = 'dap run last', buffer = bufnr },
      { '<bslash>o', dap.step_over, desc = 'dap step over', buffer = bufnr },
      { '<bslash>i', dap.step_into, desc = 'dap step into', buffer = bufnr },
      { '<bslash>b', dap.toggle_breakpoint, desc = 'dap toggle breakpoint', buffer = bufnr },
      { '<bslash>r', dap.repl.toggle, desc = 'dap repl toggle', buffer = bufnr },
   }
end

return M

