--[[ Which-key defined keymaps needed by multiple modules ]]

local M = {}

local check = function(client)
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

function M.set_lsp_keymaps(client, bn)
   client = check(client)
   if not client then
      return false
   end

   local wk = require 'which-key'
   local tb = require 'telescope.builtin'

   wk.add {
      { 'jkc', group = 'code action', buffer = bn },
      { 'jkd', group = 'document',    buffer = bn },
      { 'jkf', group = 'format',      buffer = bn },
      { 'jkg', group = 'goto',        buffer = bn },
      { 'jkh', group = 'haskell',     buffer = bn },
      { 'jks', group = 'symbols',     buffer = bn },
      { 'jkr', group = 'rust',        buffer = bn },
   }

   wk.add {
      { 'H',    vim.lsp.buf.hover,                   desc = 'hover document',    buffer = bn },
      { 'K',    vim.lsp.buf.signature_help,          desc = 'signature help',    buffer = bn },
      { 'jkff', vim.lsp.buf.format,                  desc = 'format with LSP',   buffer = bn },
      { 'jkr',  vim.lsp.buf.rename,                  desc = 'rename',            buffer = bn },
      { 'jkca', vim.lsp.buf.code_action,             desc = 'code action',       buffer = bn },
      { 'jkcl', vim.lsp.codelens.refresh,            desc = 'code lens refresh', buffer = bn },
      { 'jkcr', vim.lsp.codelens.run,                desc = 'code lens run',     buffer = bn },
      { 'jkgd', tb.lsp_definitions,                  desc = 'definitions',       buffer = bn },
      { 'jkgD', vim.lsp.buf.declaration,             desc = 'goto type decl',    buffer = bn },
      { 'jkgi', tb.lsp_implementations,              desc = 'implementations',   buffer = bn },
      { 'jkgr', tb.lsp_references,                   desc = 'references',        buffer = bn },
      { 'jksd', tb.lsp_document_symbols,             desc = 'document symbols',  buffer = bn },
      { 'jksw', tb.lsp_dynamic_workspace_symbols,    desc = 'workspace symbols', buffer = bn },
      { 'jkwa', vim.lsp.buf.add_workspace_folder,    desc = 'add ws folder',     buffer = bn },
      { 'jkwr', vim.lsp.buf.remove_workspace_folder, desc = 'rm ws folder',      buffer = bn },
   }

   -- Configure inlay hints if LSP supports it
   if client:supports_method('textDocument/inlayHint', bn) then
      vim.lsp.inlay_hint.enable(false, { buffer = bn })

      wk.add {
         {
            'jki',
            function()
               vim.lsp.inlay_hint.enable(
                  not vim.lsp.inlay_hint.is_enabled { buffer = bn },
                  { buffer = bn }
               )

               if vim.lsp.inlay_hint.is_enabled { buffer = bn } then
                  local msg = 'LSP: inlay hints were enabled'
                  vim.notify(msg, vim.log.levels.INFO)
               else
                  local msg = 'LSP: inlay hints were disabled'
                  vim.notify(msg, vim.log.levels.INFO)
               end
            end,
            desc = 'toggle inlay hints',
            buffer = bn,
         }
      }

      local msg = string.format('LSP: Client = "%s" supports inlay hints', client.name)
      vim.notify(msg, vim.log.levels.INFO)
   end

   return true
end

function M.set_hls_keymaps(bn)
   local wk = require 'which-key'
   wk.add {
      'jkfh',
      "<cmd>'<,'>!stylish-haskell<cr>",
      desc = 'stylish haskell',
      mode = { 'n', 'v' },
      buffer = bn
   }
end

-- Rust-Tools related keymaps
function M.set_rust_keymaps(bn)
   local rt = require('rust-tools')
   require('which-key').add {
      { 'jkR',  group = 'rust tools',                   buffer = bn },
      { 'jkRH', rt.hover_actions.hover_actions,         desc = 'hover actions',     buffer = bn },
      { 'jkRA', rt.code_action_group.code_action_group, desc = 'code action group', buffer = bn },
   }
end

-- Scala Metals related keymaps
function M.set_metals_keymaps(bn)
   local metals = require 'metals'
   require('which-key').add {
      { 'jkM',  group = 'metals',       buffer = bn },
      { 'jkMH', metals.hover_worksheet, desc = 'hover worksheet', buffer = bn },
   }
end

--[[ DAP (Debug Adapter Protocol) related keymaps ]]

function M.set_dap_keymaps(bn)
   local dap = require 'dap'
   local dap_ui_widgets = require 'dap.ui.widgets'

   require('which-key').add {
      { '<bslash>c', dap.continue,          desc = 'dap continue',          buffer = bn },
      { '<bslash>h', dap_ui_widgets.hover,  desc = 'dap hover',             buffer = bn },
      { '<bslash>l', dap.run_last,          desc = 'dap run last',          buffer = bn },
      { '<bslash>o', dap.step_over,         desc = 'dap step over',         buffer = bn },
      { '<bslash>i', dap.step_into,         desc = 'dap step into',         buffer = bn },
      { '<bslash>b', dap.toggle_breakpoint, desc = 'dap toggle breakpoint', buffer = bn },
      { '<bslash>r', dap.repl.toggle,       desc = 'dap repl toggle',       buffer = bn },
   }
end

return M
