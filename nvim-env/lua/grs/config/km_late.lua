--[[ Plugin related keymaps ]]

local km = vim.keymap.set        -- TODO: remove this
local M = {}

function M.init(wk)

   local wr = wk.register

   -- prefixes
   wr {['<leader>'] = { name = 'space', mode = {'n', 'x'} }}
   wr {['<leader>R'] = { name = 'refactoring', mode = {'n', 'x'} }}
   wr {['<leader>g'] = { name = 'goto/get' }}
   wr {['<leader>h'] = { name = 'harpoon' }}
   wr {['<leader>p'] = { name = 'package managers' }}
   wr {['<leader>s'] = { name = 'search' }}
   wr {['<bslash>'] = { name = 'diagnostics & dap' }}
   wr {['<c-b>'] = { name = 'blackhole', mode = {'n', 'x'} }}
   wr {['<c-b>s'] = { name = 'system clipboard', mode = {'n', 'x'} }}
   wr {['<c-g>'] = { name = 'gitsigns', mode = {'n', 'x'} }}
   wr {['<leader>t'] = { name = 'toggle' }}

   -- plugin/package managers keymaps
   wr { ['<leader>pl'] = { '<cmd>Lazy<cr>', name = 'Lazy gui' } }
   wr { ['<leader>pm'] = { '<cmd>Mason<cr>', name = 'Mason gui' } }

   -- toggle treesitter highlighting
   wr { ['<leader>tt'] = { '<cmd>TSBufToggle highlight<cr>', 'treesitter highlighting' } }
end

--[[ LSP related keymaps ]]
function M.lsp(client, bufnr, wk)

   local tb = require 'telescope.builtin'
   local wr = wk.register

   if client then
      if type(client) == "number" then
         client = vim.lsp.get_client_by_id(client)
      end

      -- first setup prefix keys
      wr {['<leader>c'] = { 'code action' }}
      wr {['<leader>d'] = { 'document' }}
      wr {['<leader>f'] = { 'format' }}
      wr {['<leader>w'] = { 'workspace' }}

      -- all LSP's "should" support these
      wr({
         ['<leader>gd'] = { tb.lsp_definitions, 'definitions' },
         ['<leader>gr'] = { tb.lsp_references, 'references' },
         ['<leader>gi'] = { tb.lsp_implementations, 'implementations' },
         ['<leader>ds'] = { tb.lsp_document_symbols, 'document symbols' },
      }, { bufnr = bufnr })

      -- if supported configure inlay hints
      if client.supports_method('textDocument/inlayHint', { bufnr = bufnr }) then
         vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })

         wr({
            ['<leader>ti'] = {
               function()
                  vim.lsp.inlay_hint.enable(
                     not vim.lsp.inlay_hint.is_enabled {
                        bufnr = bufnr,
                     }, { bufnr = bufnr })
                  if vim.lsp.inlay_hint.is_enabled { bufnr = bufnr } then
                     local msg = 'LSP: inlay hints were enabled'
                     vim.notify(msg, vim.log.levels.info)
                  else
                     local msg = 'LSP: inlay hints were disabled'
                     vim.notify(msg, vim.log.levels.info)
                  end
               end,
               'toggle inlay hints',
            }
         }, { bufnr = bufnr })

         local msg = string.format('LSP: Client = "%s" supports inlay hints', client.name)
         vim.notify(msg, vim.log.levels.INFO)
      else
         local msg = string.format('LSP: Client = "%s" does not support inlay hints', client.name)
         vim.notify(msg, vim.log.levels.INFO)
      end

      local telescope_builtin = require  'telescope.builtin'

      km('n', '<leader>ws', telescope_builtin.lsp_dynamic_workspace_symbols,
         { buffer = bufnr, desc = 'workspace symbols' })

      km('n', '<leader>gD', vim.lsp.buf.declaration,
         { buffer = bufnr, desc = 'goto type declaration' })

      km('n', '<leader>r', vim.lsp.buf.rename,
         { buffer = bufnr, desc = 'rename' })

      km('n', 'K', vim.lsp.buf.hover,
         { buffer = bufnr, desc = 'hover document' })

      km('n', '<leader>K', vim.lsp.buf.signature_help,
         { buffer = bufnr, desc = 'signature help' })

      km('n', '<leader>ca', vim.lsp.buf.code_action,
         { buffer = bufnr, desc = 'code action' })

      km('n', '<leader>cr', vim.lsp.codelens.refresh,
         { buffer = bufnr, desc = 'code lens refresh' })

      km('n', '<leader>cl', vim.lsp.codelens.run,
         { buffer = bufnr, desc = 'code lens run' })

      km('n', '<leader>wa', vim.lsp.buf.add_workspace_folder,
         { buffer = bufnr, desc = 'add workspace folder' })

      km('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder,
         { buffer = bufnr, desc = 'remove workspace folder' })

      km({ 'n', 'v' }, '<leader>fl', vim.lsp.buf.format,
         { buffer = bufnr, desc = 'format with lsp' })
   else
      local msg = 'LSP: WARNING: Possible LSP misconfiguration'
      vim.notify(msg, vim.log.levels.WARN)
   end
end

-- Haskell related keymaps
function M.haskell(bufnr, wk)
   wk.register(
   {
      ['<leader>fh'] = { '<cmd>%!stylish-haskell<cr>', 'stylish haskell' },
   }, { buffer = bufnr })

   wk.register({
      ['<leader>fh'] = { "<cmd>'<,'>!stylish-haskell<cr>", 'stylish haskell' },
   }, { buffer = bufnr, mode = 'v' })
end

-- Rust-Tools related keymaps
function M.rust(bufnr, rt, wk)
   km('n', '<bslash>LH', rt.hover_actions.hover_actions, {
      buffer = bufnr,
      desc = 'rust hover actions',
   })
   km('n', '<bslash>LA', rt.code_action_group.code_action_group, {
      buffer = bufnr,
      desc = 'rust code action group',
   })

   wk.register({
      name = 'rust specific',
   }, {
      prefix = '<bslash>L',
      mode = 'n',
      buffer = bufnr,
   })
end

-- Scala Metals related keymaps
function M.metals(bufnr, metals, wk)
   km('n', '<bslash>LH', metals.hover_worksheet, {
      buffer = bufnr,
      desc = 'metals hover worksheet',
   })

   wk.register({
      name = 'scala specific',
   }, {
      prefix = '<bslash>L',
      mode = 'n',
      buffer = bufnr,
   })
end

--[[ DAP (Debug Adapter Protocol) related keymaps ]]

function M.dap(bufnr, dap, dap_ui_widgets, wk)
   km('n', '<bslash>c', dap.continue, {
      buffer = bufnr,
      desc = 'dap continue',
   })
   km('n', '<bslash>h', dap_ui_widgets.hover, {
      buffer = bufnr,
      desc = 'dap hover',
   })
   km('n', '<bslash>l', dap.run_last, {
      buffer = bufnr,
      desc = 'dap run last',
   })
   km('n', '<bslash>o', dap.step_over, {
      buffer = bufnr,
      desc = 'dap step over',
   })
   km('n', '<bslash>i', dap.step_into, {
      buffer = bufnr,
      desc = 'dap step into',
   })
   km('n', '<bslash>b', dap.toggle_breakpoint, {
      buffer = bufnr,
      desc = 'dap toggle breakpoint',
   })
   km('n', '<bslash>r', dap.repl.toggle, {
      buffer = bufnr,
      desc = 'dap repl toggle',
   })

   local opts_b = { bufnr = bufnr }

   wk.register({['<bslash>'] = { name = 'diagnostics & dap' }}, opts_b)
end

return M
