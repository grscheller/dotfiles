--[[ Which-key defined keymaps needed by multiple modules ]]

local M = {}

function M.set_lsp_keymaps(_, bn)
   local wk = require 'which-key'
   local tb = require 'telescope.builtin'

   wk.add {
      { 'jk', group = 'lsp', buffer = bn },
      { 'jkc', group = 'code action', buffer = bn },
      { 'jkd', group = 'document', buffer = bn },
      { 'jkf', group = 'format', buffer = bn },
      { 'jkg', group = 'goto', buffer = bn },
      { 'jkh', group = 'haskell', buffer = bn },
      { 'jks', group = 'symbols', buffer = bn },
      { 'jkr', group = 'rust', buffer = bn },
   }

   wk.add {
      { 'H', vim.lsp.buf.hover, desc = 'hover document', buffer = bn },
      { 'K', vim.lsp.buf.signature_help, desc = 'signature help', buffer = bn },
      { 'jkff', vim.lsp.buf.format, desc = 'format with LSP', buffer = bn },
      { 'jkrn', vim.lsp.buf.rename, desc = 'rename', buffer = bn },
      { 'jkca', vim.lsp.buf.code_action, desc = 'code action', buffer = bn },
      { 'jkcl', vim.lsp.codelens.refresh, desc = 'code lens refresh', buffer = bn },
      { 'jkcr', vim.lsp.codelens.run, desc = 'code lens run', buffer = bn },
      { 'jkgd', tb.lsp_definitions, desc = 'definitions', buffer = bn },
      { 'jkgD', vim.lsp.buf.declaration, desc = 'goto type decl', buffer = bn },
      { 'jkgi', tb.lsp_implementations, desc = 'implementations', buffer = bn },
      { 'jkgr', tb.lsp_references, desc = 'references', buffer = bn },
      { 'jksd', tb.lsp_document_symbols, desc = 'document symbols', buffer = bn },
      { 'jksw', tb.lsp_dynamic_workspace_symbols, desc = 'workspace symbols', buffer = bn },
      { 'jkwa', vim.lsp.buf.add_workspace_folder, desc = 'add ws folder', buffer = bn },
      { 'jkwr', vim.lsp.buf.remove_workspace_folder, desc = 'rm ws folder', buffer = bn },
   }

   wk.add {
      {
         'jki',
         function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { buffer = bn }, { buffer = bn })
         end,
         desc = 'toggle inlay hints',
         buffer = bn,
      },
   }

   return true
end

function M.set_hls_keymaps(bn)
   local wk = require 'which-key'
   wk.add {
      'jkfh',
      "<cmd>'<,'>!stylish-haskell<cr>",
      desc = 'stylish haskell',
      mode = { 'n', 'v' },
      buffer = bn,
   }
end

-- Rust-Tools related keymaps - used in after/ftplugin/rust.lua
function M.set_rust_keymaps(bn)
   require('which-key').add {
      { 'jkR', group = 'rustaceanvim', buffer = bn },
      {
         'jkRA',
         function()
            vim.cmd.RustLsp 'codeAction'
         end,
         desc = 'code action group',
         buffer = bn,
      },
      {
         'jkRH',
         function()
            vim.cmd.RustLsp {
               'hover',
               'actions',
            }
         end,
         buffer = bn,
      },
   }
end

-- Scala Metals related keymaps
function M.set_metals_keymaps(bn)
   local metals = require 'metals'
   require('which-key').add {
      { 'jkM', group = 'metals', buffer = bn },
      { 'jkMH', metals.hover_worksheet, desc = 'hover worksheet', buffer = bn },
   }
end

--[[ DAP (Debug Adapter Protocol) related keymaps ]]

function M.set_dap_keymaps(bn)
   local dap = require 'dap'
   local dap_ui_widgets = require 'dap.ui.widgets'
   local dapui = require 'dapui'

   require('which-key').add {
      { '<bslash><bslash>c', dap.continue, desc = 'dap continue', buffer = bn },
      { '<bslash><bslash>g', dapui.toggle, desc = 'toggle dapui', buffer = bn },
      { '<bslash><bslash>h', dap_ui_widgets.hover, desc = 'dap hover', buffer = bn },
      { '<bslash><bslash>i', dap.step_into, desc = 'dap step into', buffer = bn },
      { '<bslash><bslash>l', dap.run_last, desc = 'dap run last', buffer = bn },
      { '<bslash><bslash>o', dap.step_over, desc = 'dap step over', buffer = bn },
      { '<bslash><bslash>b', dap.toggle_breakpoint, desc = 'dap toggle breakpoint', buffer = bn },
      { '<bslash><bslash>r', dap.repl.toggle, desc = 'dap repl toggle', buffer = bn },
   }
end

return M
