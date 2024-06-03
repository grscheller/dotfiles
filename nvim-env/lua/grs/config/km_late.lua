--[[ Which-key defined keymaps (after lazy.nvim has launched) ]]

local M = {}

function M.setup(wk)
   -- prefixes for keymaps defined early
   wk.register {
      ['<bslash>']  = { name = 'diagnostics' },
      ['<leader>']  = { name = 'space' },
      ['<c-b>'] = { name = 'blackhole' },
      ['<c-s>'] = { name = 'system clipboard' },
   }

   wk.register({
      ['<leader>']  = { name = 'space' },
      ['<c-b>']     = { name = 'blackhole' },
      ['<c-s>']     = { name = 'system clipboard' },
   }, { mode = 'v' })

   -- prefixes for plugins
   wk.register {
      ['<leader>h'] = { name = 'harpoon' },
      ['<leader>p'] = { name = 'plugin/package managers' },
      ['<leader>R'] = { name = 'refactoring' },
      ['<leader>s'] = { name = 'search' },
      ['<leader>t'] = { name = 'toggle' },
   }

   wk.register({
      ['<leader>R'] = { name = 'refactoring' },
   }, { mode = 'v' })

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
