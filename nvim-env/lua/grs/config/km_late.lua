--[[ Plugin related keymaps ]]

local M = {}

function M.init(wk)

   -- prefixes
   wk.register {
      ['<leader>G'] = { name = 'gitsigns' },
      ['<leader>h'] = { name = 'harpoon' },
      ['<leader>p'] = { name = 'package managers' },
      ['<leader>s'] = { name = 'search' },
      ['<leader>t'] = { name = 'toggle' },
      ['<bslash>'] = { name = 'diagnostics' },
   }

   wk.register({
      ['<leader>'] = { name = 'space' },
      ['<leader>R'] = { name = 'refactoring' },
      ['<c-b>'] = { name = 'blackhole' },
      ['<c-b>s'] = { name = 'system clipboard' },
      ['<c-g>'] = { name = 'gitsigns' },
   }, { mode = {'n', 'x'} })

   -- plugin/package managers keymaps
   wk.register {
      name = 'package managers',
      ['<leader>pl'] = { '<cmd>Lazy<cr>', 'Lazy gui' },
      ['<leader>pm'] = { '<cmd>Mason<cr>', 'Mason gui' },
   }

   -- toggle treesitter highlighting
   wk.register {
      ['<leader>tt'] = { '<cmd>TSBufToggle highlight<cr>', 'treesitter highlighting' }
   }
end

--[[ LSP related keymaps ]]
function M.lsp(client, bufnr, wk)

   local tb = require 'telescope.builtin'

   if client then
      if type(client) == "number" then
         client = vim.lsp.get_client_by_id(client)
      end

      wk.register({
         ['<leader>c']  = { name = 'code action' },
         ['<leader>ca'] = { vim.lsp.buf.code_action, 'code action' },
         ['<leader>cl'] = { vim.lsp.codelens.refresh, 'code lens refresh' },
         ['<leader>cr'] = { vim.lsp.codelens.run, 'code lens run' },
         ['<leader>d']  = { name = 'document' },
         ['<leader>ds'] = { tb.lsp_document_symbols, 'document symbols' },
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
         ['<leader>f'] = { name = 'format' },
         ['<leader>fl'] = { vim.lsp.buf.format, 'format with LSP' },
      }, { bufnr = bufnr, mode = { 'n', 'x' } })

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
   else
      local msg = 'LSP: WARNING: Possible LSP misconfiguration'
      vim.notify(msg, vim.log.levels.WARN)
   end
end

-- Haskell related keymaps
function M.haskell(bufnr, wk)
   wk.register({
      ['<leader>fh'] = { '<cmd>%!stylish-haskell<cr>', 'stylish haskell' },
   }, { buffer = bufnr })

   wk.register({
      ['<leader>fh'] = { "<cmd>'<,'>!stylish-haskell<cr>", 'stylish haskell' },
   }, { buffer = bufnr, mode = 'x' })
end

-- Rust-Tools related keymaps
function M.rust(bufnr, rt, wk)
   wk.register({
      ['<leader>R']  = { name = 'rust tools' },
      ['<leader>Rh'] = { rt.hover_actions.hover_actions, 'hover actions' },
      ['<leader>Ra'] = { rt.code_action_group.code_action_group, 'code action group' },
   }, { bufnr = bufnr })
end

-- Scala Metals related keymaps
function M.metals(bufnr, metals, wk)
   wk.register({
      ['<leader>M']  = { name = 'scala metals' },
      ['<leader>Mh'] = { metals.hover_worksheet, 'hover worksheet' },
   }, { bufnr = bufnr })
end

--[[ DAP (Debug Adapter Protocol) related keymaps ]]

function M.dap(bufnr, dap, dap_ui_widgets, wk)
   wk.register({
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
