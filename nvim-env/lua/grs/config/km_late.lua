--[[ Define keymappings/keybindings - loaded after lazy.nvim finishes ]]

--[[ Plugin related keymaps - TODO: move, they depend on plugins ]]

-- plugin/package managers keymaps
km('n', '<leader>pl', '<cmd>Lazy<cr>', { desc = 'lazy_gui' })
km('n', '<leader>pm', '<cmd>Mason<cr>', { desc = 'mason_gui' })

-- toggle treesitter
km('n', '<leader>tt', '<cmd>TSBufToggle highlight<cr>', {
   desc = 'toggle treesitter highlighting',
})

wk.register({ ['<space>'] = { 'leader' } }, { mode = { 'n', 'v' } })

wk.register({
   name = 'diagnosics & dap',
}, {
   prefix = '<bslash>',
   mode = 'n',
})

wk.register({
   name = 'package managers',
}, {
   prefix = '<leader>p',
   mode = 'n',
})

wk.register({
   name = 'search',
}, {
   prefix = '<leader>s',
   mode = 'n',
})

wk.register({
   name = 'toggle',
}, {
   prefix = '<leader>t',
   mode = 'n',
})

wk.register({
   name = 'git Hunk'
}, {
   prefix = '<leader>H',
   mode = { 'n', 'v' },
})

wk.register({
   name = 'harpoon',
}, {
   prefix = '<leader>h',
   mode = 'n',
})

-- Refactoring prefix-key
wk.register({
   name = 'refactoring',
}, {
   prefix = '<leader>R',
   mode = { 'n', 'v' },
})

local M = {}

--[[ LSP related keymaps ]]
function M.lsp(client, bufnr, wk)

   -- first setup prefix keys
   wk.register { ['<leader>c'] = { 'cool cat' } }
   wk.register { ['<leader>c'] = { 'code action' } }
   wk.register { ['<leader>d'] = { 'document' } }
   wk.register { ['<leader>f'] = { 'format' } }
   wk.register { ['<leader>g'] = { 'goto' } }
   wk.register { ['<leader>w'] = { 'workspace' } }

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

   if client then
      -- need to check if "client" is a "client id" or a "client table"
      if type(client) == "number" then
         client = vim.lsp.get_client_by_id(client)
      end

      if client.supports_method('textDocument/inlayHint', { bufnr = bufnr }) then
         vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
         km('n', '<leader>ti', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
            if vim.lsp.inlay_hint.is_enabled { bufnr = bufnr } then
               vim.notify('LSP: inlay hints were enabled', vim.log.levels.info)
            else
               vim.notify('LSP: inlay hints were disabled', vim.log.levels.info)
            end
         end, { buffer = bufnr, desc = 'toggle inlay hints' })
         local msg = string.format('LSP: Client = "%s" supports inlay hints', client.name)
         vim.notify(msg, vim.log.levels.INFO)
      else
         local msg = string.format('LSP: Client = "%s" does not support inlay hints', client.name)
         vim.notify(msg, vim.log.levels.INFO)
      end
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

   wk.register({
      name = 'dap',
   }, {
      prefix = '<bslash>',
      mode = 'n',
      buffer = bufnr,
   })
end

return M
