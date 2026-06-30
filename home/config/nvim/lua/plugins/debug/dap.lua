--[[ Config Debugger Adapter Protocol (DAP) ]]

return {
   {
      'mfussenegger/nvim-dap',
      dependencies = {
         'igorlfs/nvim-dap-view',
         'theHamsta/nvim-dap-virtual-text',
      },
      config = function()
         local dap = require('dap')
         local dap_view = require('dap-view')
         local km  = vim.keymap.set

         dap_view.setup { auto_toggle = true }

         -- Session control
         km('n', ',ds', function() dap.continue() end, { desc = 'DAP start/continue session' })
         km('n', ',de', function() dap.terminate() end, { desc = 'DAP end session' })
         km('n', ',bs', function() dap.set_breakpoint(vim.fn.input('Condition: ')) end, { desc = 'DAP breakpoint set' })
         km('n', ',bt', function() dap.toggle_breakpoint() end, { desc = 'DAP breakpoint toggle' })
         km('n', ',ui', function() dap_view.toggle() end, { desc = 'DAP toggle ui' })

         -- Stepping
         km('n', ',si', function() dap.step_into() end, { desc = 'DAP step into' })
         km('n', ',sa', function() dap.step_over() end, { desc = 'DAP step around (over)' })
         km('n', ',so', function() dap.step_out() end, { desc = 'DAP step out' })
         km('n', ',sc', function() dap.run_to_cursor() end, { desc = 'DAP step to cursor' })

      end,
   },
}
