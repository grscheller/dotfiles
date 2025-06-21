--[[ Config Debugger Adapter Protocall (DAP) ]]

local km = require 'grs.config.keymaps_whichkey'

local config_nvim_dap = function()
   local dap = require 'dap'
   local dapui = require 'dapui'

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

   -- Install golang specific config, see 'jay-babu/mason-nvim-dap.nvim'
   require('dap-go').setup {
      delve = {
         -- Go debugger, on Windows delve must be run attached or it crashes.
         detached = not vim.fn.has 'win32',
      },
   }
end

return {
   {
      -- Debug Adapter Protocall (DAP) plugin
      'mfussenegger/nvim-dap',
      dependencies = {
         'rcarriga/nvim-dap-ui',
         'nvim-neotest/nvim-nio',
         -- Debuggers
         'leoluz/nvim-dap-go',
      },
      config = config_nvim_dap,
   },
}
