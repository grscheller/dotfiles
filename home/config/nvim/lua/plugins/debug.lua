--[[ Config Debugger Adapter Protocol (DAP) setup ]]

return {
   -- DAP debugging module
   {
      [1] = 'mfussenegger/nvim-dap',
      dependencies = {
         {
            [1] = 'igorlfs/nvim-dap-view',
            dependencies = { 'theHamsta/nvim-dap-virtual-text' },
            opts = { auto_toggle = true },
         },
      },
      keys = {
         -- Session control
         { ',ds', function() require('dap').continue() end,                                  desc = 'DAP start/continue session' },
         { ',de', function() require('dap').terminate() end,                                 desc = 'DAP end session' },
         { ',bs', function() require('dap').set_breakpoint(vim.fn.input('Condition: ')) end, desc = 'DAP breakpoint set' },
         { ',bt', function() require('dap').toggle_breakpoint() end,                         desc = 'DAP breakpoint toggle' },
         { ',ui', function() require('dap').view_toggle() end,                               desc = 'DAP toggle ui' },

         -- Stepping
         { ',si', function() require('dap').step_into() end,                                 desc = 'DAP step into' },
         { ',sa', function() require('dap').step_over() end,                                 desc = 'DAP step around (over)' },
         { ',so', function() require('dap').step_out() end,                                  desc = 'DAP step out' },
         { ',sc', function() require('dap').run_to_cursor() end,                             desc = 'DAP step to cursor' },
      },
   },

   -- Python adapter
   {
      [1] = 'mfussenegger/nvim-dap-python',
      dependencies = {
         'mfussenegger/nvim-dap',
      },
      ft = 'python',
      config = function()
         -- Python debugger
         local debugpy_path = vim.fn.stdpath('data')
             .. '/mason/packages/debugpy/venv/bin/python'
         require('dap-python').setup(debugpy_path)
      end,
   },

   -- C, C++, Rust, Zig adapter
   {
      -- virtual plugin spec
      dir = vim.fn.stdpath('config'), -- any real directory, this one is guaranteed to exist
      name = 'dap-codelldb-config',   -- arbitrary unique name
      dependencies = {
         'mfussenegger/nvim-dap',
      },
      ft = { 'c', 'cpp', 'rust', 'zig' },
      config = function()
         require('dap').adapters.codelldb   = {
            type = 'server',
            port = '${port}',
            executable = {
               command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
               args = { '--port', '${port}' },
            },
         }

         local lldb_config                  = {
            {
               name = 'Launch',
               type = 'codelldb',
               request = 'launch',
               program = function()
                  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
               end,
               cwd = '${workspaceFolder}',
               stopOnEntry = false,
            },
         }

         require('dap').configurations.c    = lldb_config
         require('dap').configurations.cpp  = lldb_config
         require('dap').configurations.rust = lldb_config
         require('dap').configurations.zig  = lldb_config
      end,
   },
}
