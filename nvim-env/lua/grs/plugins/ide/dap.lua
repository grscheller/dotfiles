--[[ Config Debugger Adapter Protocall (DAP) ]]

local km = require 'grs.config.keymaps'

local config_nvim_dap = function()
   local dap = require 'dap'
   local dapui = require 'dapui'

   -- Dap UI setup - For more information, see |:help nvim-dap-ui|
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

   -- km.set_dap_keymaps(bn)  -- FIX! how do I get the buffer number???
   -- See: https://github.com/mfussenegger/dotfiles/blob/e7abb9a13f8fb3075704ed703dd973ecf3502cc3/vim/.config/nvim/lua/me/dap.lua#L64-L75
end

return {
   {
      'mfussenegger/nvim-dap',
      dependencies = {
         -- Beautiful debugger UI
         'rcarriga/nvim-dap-ui',
         'nvim-neotest/nvim-nio',

         -- Add debuggers here
         'leoluz/nvim-dap-go',
      },
      config = config_nvim_dap,
   },
}
