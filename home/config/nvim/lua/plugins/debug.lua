--[[ Debugger Adapter Protocol (DAP) setup

     - DAP debugger plugin
     - Language adapters
]]

---@type LazySpec
return {
   -- DAP debugging module
   ---@type LazyPluginSpec
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
         {
            [1] = ',ds',
            [2] = function()
               require('dap').continue()
            end,
            desc = 'DAP start/continue session',
         },
         {
            [1] = ',de',
            [2] = function()
               require('dap').terminate()
            end,
            desc = 'DAP end session',
         },
         {
            [1] = ',du',
            [2] = function()
               require('dap-view').toggle()
            end,
            desc = 'DAP toggle ui',
         },

         -- Breakpoints
         {
            [1] = ',bs',
            [2] = function()
               require('dap').set_breakpoint(vim.fn.input 'Condition: ')
            end,
            desc = 'DAP breakpoint set',
         },
         {
            [1] = ',bt',
            [2] = function()
               require('dap').toggle_breakpoint()
            end,
            desc = 'DAP breakpoint toggle',
         },

         -- Stepping
         {
            [1] = ',si',
            [2] = function()
               require('dap').step_into()
            end,
            desc = 'DAP step into',
         },
         {
            [1] = ',sa',
            [2] = function()
               require('dap').step_over()
            end,
            desc = 'DAP step around (over)',
         },
         {
            [1] = ',so',
            [2] = function()
               require('dap').step_out()
            end,
            desc = 'DAP step out',
         },
         {
            [1] = ',sc',
            [2] = function()
               require('dap').run_to_cursor()
            end,
            desc = 'DAP step to cursor',
         },
      },
   },

   -- Python adapter
   ---@type LazyPluginSpec
   {
      [1] = 'mfussenegger/nvim-dap-python',
      dependencies = {
         'mfussenegger/nvim-dap',
      },
      ft = 'python',
      config = function()
         -- Mason installs debugpy into its own venv,
         -- venv/bin/python on Unix and venv/Scripts/python.exe on Windows.
         local venv = vim.fs.joinpath(
            vim.fn.stdpath 'data',
            'mason',
            'packages',
            'debugpy',
            'venv'
         )
         local debugpy_path = vim.fn.has 'win32' == 1
               and vim.fs.joinpath(venv, 'Scripts', 'python.exe')
            or vim.fs.joinpath(venv, 'bin', 'python')
         require('dap-python').setup(debugpy_path)
      end,
   },

   -- C, C++, Rust, Zig adapter
   ---@type LazyPluginSpec
   {
      -- virtual plugin spec
      dir = vim.fn.stdpath 'config', -- any real directory, this one is guaranteed to exist
      name = 'dap-codelldb-config', -- arbitrary unique name
      dependencies = {
         'mfussenegger/nvim-dap',
      },
      ft = { 'c', 'cpp', 'rust', 'zig' },
      config = function()
         require('dap').adapters.codelldb = {
            type = 'server',
            port = '${port}',
            executable = {
               command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
               args = { '--port', '${port}' },
            },
         }

         local lldb_config = {
            {
               name = 'Launch',
               type = 'codelldb',
               request = 'launch',
               program = function()
                  return vim.fn.input(
                     'Path to executable: ',
                     vim.fn.getcwd() .. '/',
                     'file'
                  )
               end,
               cwd = '${workspaceFolder}',
               stopOnEntry = false,
            },
         }

         require('dap').configurations.c = lldb_config
         require('dap').configurations.cpp = lldb_config
         require('dap').configurations.rust = lldb_config
         require('dap').configurations.zig = lldb_config
      end,
   },
}
