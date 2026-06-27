--[[ Config Debugger Adapter Protocol (DAP) ]]

local config_nvim_dap = function()
   local dap = require 'dap'
   local dap_ui_widgets = require 'dap.ui.widgets'
   local dapui = require 'dapui'
   local wk = require 'wk'

   -- Dap UI setup
   dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
         icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = '◀',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
         },
      },
   }

   dap.listeners.after.event_initialized['dapui_config'] = dapui.open
   dap.listeners.before.event_terminated['dapui_config'] = dapui.close
   dap.listeners.before.event_exited['dapui_config'] = dapui.close

   wk.add {
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

return {
      -- Debug Adapter Protocall (DAP) plugin
      'mfussenegger/nvim-dap',
      dependencies = {
         'rcarriga/nvim-dap-ui',
         'nvim-neotest/nvim-nio',
         -- Debuggers
         'leoluz/nvim-dap-go',
      },
      config = config_nvim_dap,
}
