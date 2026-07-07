--[[ Config Debugger Adapter Protocol (DAP) ]]

return {
   {
      [1] = 'mfussenegger/nvim-dap',
      dependencies = { 'igorlfs/nvim-dap-view' },
      keys = {
         -- Session control
         { ',ds', function() require('dap').continue() end, desc = 'DAP start/continue session' },
         { ',de', function() require('dap').terminate() end, desc = 'DAP end session' },
         { ',bs', function() require('dap').set_breakpoint(vim.fn.input('Condition: ')) end, desc = 'DAP breakpoint set' },
         { ',bt', function() require('dap').toggle_breakpoint() end, desc = 'DAP breakpoint toggle' },
         { ',ui', function() require('dap')_view.toggle() end, desc = 'DAP toggle ui' },

         -- Stepping
         { ',si', function() require('dap').step_into() end, desc = 'DAP step into' },
         { ',sa', function() require('dap').step_over() end, desc = 'DAP step around (over)' },
         { ',so', function() require('dap').step_out() end, desc = 'DAP step out' },
         { ',sc', function() require('dap').run_to_cursor() end, desc = 'DAP step to cursor' },
      },
   },

   {
      [1] = 'igorlfs/nvim-dap-view',
      dependencies = { 'theHamsta/nvim-dap-virtual-text' },
      lazy = true,
      opts = { auto_toggle = true },
   },
}
