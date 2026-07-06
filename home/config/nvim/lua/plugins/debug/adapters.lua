--[[ Config Debugger Adapter Protocol (DAP) ]]

return {
   -- Python DAP adapter
   {
      [1] = 'mfussenegger/nvim-dap-python',
      dependencies = {
         'mfussenegger/nvim-dap',
         'jay-babu/mason-nvim-dap.nvim',
      },
      ft = 'python',
      config = function()
         -- Python debugger
         local debugpy_path = vim.fn.stdpath('data')
            .. '/mason/packages/debugpy/venv/bin/python'
         require('dap-python').setup(debugpy_path)
      end,
   },

   -- C, C++, Rust, Zig adapters
   {
      -- virtual plugin spec
      dir = vim.fn.stdpath('config') .. '/lua/plugins/debug', -- any real, existing directory
      name = 'dap-codelldb-config', -- arbitrary unique name
      dependencies = {
         'mfussenegger/nvim-dap',
         'jay-babu/mason-nvim-dap.nvim',
      },
      ft = { 'c', 'cpp', 'rust', 'zig' },
      config = function()
         local dap = require('dap')

         dap.adapters.codelldb = {
            type = 'server',
            port = '${port}',
            executable = {
               command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
               args = { '--port', '${port}' },
            },
         }

         local lldb_config = {
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

         dap.configurations.c    = lldb_config
         dap.configurations.cpp  = lldb_config
         dap.configurations.rust = lldb_config
         dap.configurations.zig  = lldb_config

      end,
   },
}
