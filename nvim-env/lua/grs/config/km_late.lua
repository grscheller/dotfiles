--[[ Plugin related keymaps ]]

local km = vim.keymap.set        -- TODO: remove this
local M = {}

function M.init(wk)
   -- prefixes
   wk.register {['<leader>'] = { name = 'space', mode = {'n', 'x'} }}
   wk.register {['<leader>R'] = { name = 'refactoring', mode = {'n', 'x'} }}
   wk.register {['<leader>g'] = { name = 'goto' }}
   wk.register {['<leader>h'] = { name = 'harpoon' }}
   wk.register {['<leader>p'] = { name = 'package managers' }}
   wk.register {['<bslash>'] = { name = 'diagnostics & dap' }}
   wk.register {['<c-b>'] = { name = 'blackhole', mode = {'n', 'x'} }}
   wk.register {['<c-b>s'] = { name = 'system clipboard', mode = {'n', 'x'} }}
   wk.register {['<c-g>'] = { name = 'gitsigns', mode = {'n', 'x'} }}
   wk.register {['<leader>t'] = { name = 'toggle' }}

   -- plugin/package managers keymaps
   wk.register { ['<leader>pl'] = { '<cmd>Lazy<cr>', name = 'Lazy gui' } }
   wk.register { ['<leader>pm'] = { '<cmd>Mason<cr>', name = 'Mason gui' } }

   -- toggle treesitter highlighting
   wk.register { ['<leader>tt'] = { '<cmd>TSBufToggle highlight<cr>', 'treesitter highlighting' } }
end

--[[ LSP related keymaps ]]
function M.lsp(client, bufnr, wk)

   if client then
      if type(client) == "number" then
         client = vim.lsp.get_client_by_id(client)
      end

      if client.supports_method('textDocument/inlayHint', { bufnr = bufnr }) then
         vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })

         wk.register({
            ['<leader>ti'] = {
               function()
                  vim.lsp.inlay_hint.enable(
                     not vim.lsp.inlay_hint.is_enabled {
                        bufnr = bufnr,
                     }, { bufnr = bufnr })
                  if vim.lsp.inlay_hint.is_enabled { bufnr = bufnr } then
                     vim.notify('LSP: inlay hints were enabled', vim.log.levels.info)
                  else
                     vim.notify('LSP: inlay hints were disabled', vim.log.levels.info)
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

      -- first setup prefix keys
      wk.register {['<leader>c'] = { 'code action' }}
      wk.register {['<leader>d'] = { 'document' }}
      wk.register {['<leader>f'] = { 'format' }}
      wk.register {['<leader>w'] = { 'workspace' }}

      local telescope_builtin = require  'telescope.builtin'

      km('n', '<leader>gd', telescope_builtin.lsp_definitions,
         { buffer = bufnr, desc = 'goto definition' })

      km('n', '<leader>gr', telescope_builtin.lsp_references,
         { buffer = bufnr, desc = 'goto references' })

      km('n', '<leader>gI', telescope_builtin.lsp_implementations,
         { buffer = bufnr, desc = 'goto implementation' })

      km('n', '<leader>ds', telescope_builtin.lsp_document_symbols,
         { buffer = bufnr, desc = 'document symbols' })

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
