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

   wk.register({
      ['<leader>c']  = { name = 'code action' },
      ['<leader>ca'] = { vim.lsp.buf.code_action, 'code action' },
      ['<leader>cl'] = { vim.lsp.codelens.refresh, 'code lens refresh' },
      ['<leader>cr'] = { vim.lsp.codelens.run, 'code lens run' },
      ['<leader>d']  = { name = 'document' },
      ['<leader>ds'] = { tb.lsp_document_symbols, 'document symbols' },
      ['<leader>f']  = { name = 'format' },
      ['<leader>fl'] = { vim.lsp.buf.format, 'format with LSP' },
      ['<leader>g']  = { name = 'goto' },
      ['<leader>gd'] = { tb.lsp_definitions, 'definitions' },
      ['<leader>gi'] = { tb.lsp_implementations, 'implementations' },
      ['<leader>gr'] = { tb.lsp_references, 'references' },
      ['<leader>w']  = { name = 'workspace' },
      ['<leader>ws'] = { tb.lsp_dynamic_workspace_symbols, 'workspace symbols' },
      ['<leader>wa'] = { vim.lsp.buf.add_workspace_folder, 'add workspace folder' },
      ['<leader>wr'] = { vim.lsp.buf.remove_workspace_folder, 'remove workspace folder' },
      ['<leader>gD'] = { vim.lsp.buf.declaration, 'goto type declaration' },
      ['<leader>K']  = { vim.lsp.buf.signature_help, 'signature help' },
      ['<leader>r']  = { vim.lsp.buf.rename, 'rename' },
      ['K']          = { vim.lsp.buf.hover, 'hover document' },
   }, { bufnr = bufnr })

   wk.register({
      ['<leader>f']  = { name = 'format' },
      ['<leader>fl'] = { vim.lsp.buf.format, 'format with LSP' },
   }, { bufnr = bufnr, mode = 'v' })

   -- Configure inlay hints if LSP supports it
   if client.supports_method('textDocument/inlayHint', { bufnr = bufnr }) then
      vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })

      wk.register({
         ['<leader>ti'] = {
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
            end, 'toggle inlay hints' }
      }, { bufnr = bufnr })

      local msg = string.format('LSP: Client = "%s" supports inlay hints', client.name)
      vim.notify(msg, vim.log.levels.INFO)
   else
      local msg = string.format('LSP: Client = "%s" does not support inlay hints', client.name)
      vim.notify(msg, vim.log.levels.INFO)
   end

   return true
end

function M.set_hls_keymaps(bufnr)
   local wk = require 'which-key'
   wk.register({
      ['<leader>fh'] = { '<cmd>%!stylish-haskell<cr>', 'stylish haskell' },
   }, { buffer = bufnr })
   wk.register({
      ['<leader>fh'] = { "<cmd>'<,'>!stylish-haskell<cr>", 'stylish haskell' },
   }, { buffer = bufnr, mode = 'v' })
end

-- Rust-Tools related keymaps
function M.set_rust_keymaps(bufnr)
   local rt = require('rust-tools')
   require('which-key').register({
      ['<leader>R']  = { name = 'rust tools' },
      ['<leader>Rh'] = { rt.hover_actions.hover_actions, 'hover actions' },
      ['<leader>Ra'] = { rt.code_action_group.code_action_group, 'code action group' },
   }, { bufnr = bufnr })
end

-- Scala Metals related keymaps
function M.set_metals_keymaps(bufnr)
   local metals = require 'metals'
   require('which-key').register({
      ['<leader>M']  = { name = 'scala metals' },
      ['<leader>Mh'] = { metals.hover_worksheet, 'hover worksheet' },
   }, { bufnr = bufnr })
end

--[[ DAP (Debug Adapter Protocol) related keymaps ]]

function M.set_dap_keymaps(bufnr)
   local dap = require 'dap'
   local dap_ui_widgets = require 'dap.ui.widgets'

   require('which-key').register({
      ['<bslash>'] = { name = 'diagnostics & dap' },
      ['<bslash>c'] = { dap.continue, 'dap continue' },
      ['<bslash>h'] = { dap_ui_widgets.hover, 'dap hover' },
      ['<bslash>l'] = { dap.run_last, 'dap run last' },
      ['<bslash>o'] = { dap.step_over, 'dap step over' },
      ['<bslash>i'] = { dap.step_into, 'dap step into' },
      ['<bslash>b'] = { dap.toggle_breakpoint, 'dap toggle breakpoint' },
      ['<bslash>r'] = { dap.repl.toggle, 'dap repl toggle' },
   }, { buffer = bufnr })
end

return M
