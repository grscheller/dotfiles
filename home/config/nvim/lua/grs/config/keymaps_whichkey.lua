--[[ NO LONGER USED! - kept for future migration ]]

local M = {}

M.dap_mappings_added = false

function M.set_dap_keymaps(bn)
   if not M.dap_mappings_added then
      M.dap_mappings_added = true

      local dap = require 'dap'
      local dap_ui_widgets = require 'dap.ui.widgets'
      local dapui = require 'dapui'

      require('which-key').add {
         { '<bslash><bslash>c', dap.continue,          desc = 'dap continue',          buffer = bn },
         { '<bslash><bslash>g', dapui.toggle,          desc = 'toggle dapui',          buffer = bn },
         { '<bslash><bslash>h', dap_ui_widgets.hover,  desc = 'dap hover',             buffer = bn },
         { '<bslash><bslash>i', dap.step_into,         desc = 'dap step into',         buffer = bn },
         { '<bslash><bslash>l', dap.run_last,          desc = 'dap run last',          buffer = bn },
         { '<bslash><bslash>o', dap.step_over,         desc = 'dap step over',         buffer = bn },
         { '<bslash><bslash>b', dap.toggle_breakpoint, desc = 'dap toggle breakpoint', buffer = bn },
         { '<bslash><bslash>r', dap.repl.toggle,       desc = 'dap repl toggle',       buffer = bn },
      }
   end

   return true
end

function M.set_hls_keymaps(bn)
   local wk = require 'which-key'
   wk.add {
      { 'jkh', group = 'haskell', buffer = bn },
      {
         'jkfh',
         "<cmd>'<,'>!stylish-haskell<cr>",
         desc = 'stylish haskell',
         mode = { 'n', 'v' },
         buffer = bn,
      },
   }
end

-- Rust-Tools related keymaps - used in after/ftplugin/rust.lua
function M.set_rust_keymaps(bn)
   require('which-key').add {
      { 'jkr', group = 'rustaceanvim', buffer = bn },
      {
         'jkra',
         function()
            vim.cmd.RustLsp 'codeAction'
         end,
         desc = 'code action group',
         buffer = bn,
      },
      {
         'jkrh',
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
      { 'jkM',  group = 'metals',       buffer = bn },
      { 'jkMH', metals.hover_worksheet, desc = 'hover worksheet', buffer = bn },
   }
end

return M
