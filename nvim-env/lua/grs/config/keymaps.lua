--[[ Which-key defined keymaps needed by multiple modules ]]

local M = {}

local function check(client)
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
      { '<leader>c', group = 'code action', { bufnr = bufnr } },
      { '<leader>ca', vim.lsp.buf.code_action, desc = 'code action', { bufnr = bufnr } },
      { '<leader>cl', vim.lsp.codelens.refresh, desc = 'code lens refresh', { bufnr = bufnr } },
      { '<leader>cr', vim.lsp.codelens.run, desc = 'code lens run', { bufnr = bufnr } },
      { '<leader>d', group = 'document', { bufnr = bufnr } },
      { '<leader>ds', tb.lsp_document_symbols, desc = 'document symbols', { bufnr = bufnr } },
      { '<leader>f', group = 'format', { bufnr = bufnr } },
      { '<leader>fl', vim.lsp.buf.format, desc = 'format with LSP', { bufnr = bufnr } },
      { '<leader>g', group = 'goto', { bufnr = bufnr } },
      { '<leader>gd', tb.lsp_definitions, desc = 'definitions', { bufnr = bufnr } },
      { '<leader>gi', tb.lsp_implementations, desc = 'implementations', { bufnr = bufnr } },
      { '<leader>gr', tb.lsp_references, desc = 'references', { bufnr = bufnr } },
      { '<leader>w', group = 'workspace', { bufnr = bufnr } },
      { '<leader>ws', tb.lsp_dynamic_workspace_symbols, desc = 'workspace symbols', { bufnr = bufnr } },
      { '<leader>wa', vim.lsp.buf.add_workspace_folder, desc = 'add workspace folder', { bufnr = bufnr } },
      { '<leader>wr', vim.lsp.buf.remove_workspace_folder, desc = 'remove workspace folder', { bufnr = bufnr } },
      { '<leader>gD', vim.lsp.buf.declaration, desc = 'goto type declaration', { bufnr = bufnr } },
      { '<leader>K', vim.lsp.buf.signature_help, desc = 'signature help', { bufnr = bufnr } },
      { '<leader><leaader>r', vim.lsp.buf.rename, desc = 'rename', { bufnr = bufnr } },
      { 'K',         vim.lsp.buf.hover, desc = 'hover document', { bufnr = bufnr } },
   }

   wk.add {
      { '<leader>f', group = 'format' },
      { '<leader>fl', vim.lsp.buf.format, desc = 'format with LSP', { bufnr = bufnr, mode = 'v' } },
   }

   -- Configure inlay hints if LSP supports it
   if client.supports_method('textDocument/inlayHint', { bufnr = bufnr }) then
      vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })

      wk.add {
         {
            '<leader>ti',
            function()
               vim.lsp.inlay_hint.enable(
                  not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr },
                  { bufnr = bufnr }
               )

               if vim.lsp.inlay_hint.is_enabled { bufnr = bufnr } then
                  local msg = 'LSP: inlay hints were enabled'
                  vim.notify(msg, vim.log.levels.info)
               else
                  local msg = 'LSP: inlay hints were disabled'
                  vim.notify(msg, vim.log.levels.info)
               end
            end,
            desc = 'toggle inlay hints',
            { bufnr = bufnr }
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
       { buffer = bufnr },
       { '<leader>fh', '<cmd>%!stylish-haskell<cr>', desc = 'stylish haskell' },
   }
   wk.add {
      '<leader>fh',
      "<cmd>'<,'>!stylish-haskell<cr>",
      desc = 'stylish haskell',
      { buffer = bufnr, mode = 'v' }
   }
end

-- Rust-Tools related keymaps
function M.set_rust_keymaps(bufnr)
   local rt = require('rust-tools')
   require('which-key').add {
      { '<leader><leader>R', group = 'rust tools', { bufnr = bufnr } },
      { '<leader><leader>Rh', rt.hover_actions.hover_actions, desc = 'hover actions', { bufnr = bufnr }},
      { '<leader><leader>Ra', rt.code_action_group.code_action_group, desc = 'code action group', { bufnr = bufnr } },
   }
end

-- Scala Metals related keymaps
function M.set_metals_keymaps(bufnr)
   local metals = require 'metals'
   require('which-key').add {
      { '<leader><leader>M',  group = 'scala metals', { bufnr = bufnr } },
      { '<leader><leader>Mh', metals.hover_worksheet, desc = 'hover worksheet', { bufnr = bufnr } },
   }
end

--[[ DAP (Debug Adapter Protocol) related keymaps ]]

function M.set_dap_keymaps(bufnr)
   local dap = require 'dap'
   local dap_ui_widgets = require 'dap.ui.widgets'

   require('which-key').add {
      { '<bslash>c', dap.continue, desc = 'dap continue', { bufnr = bufnr } },
      { '<bslash>h', dap_ui_widgets.hover, desc = 'dap hover', { bufnr = bufnr } },
      { '<bslash>l', dap.run_last, desc = 'dap run last', { bufnr = bufnr } },
      { '<bslash>o', dap.step_over, desc = 'dap step over', { bufnr = bufnr } },
      { '<bslash>i', dap.step_into, desc = 'dap step into', { bufnr = bufnr } },
      { '<bslash>b', dap.toggle_breakpoint, desc = 'dap toggle breakpoint', { bufnr = bufnr } },
      { '<bslash>r', dap.repl.toggle, desc = 'dap repl toggle', { bufnr = bufnr } },
   }
end

return M
