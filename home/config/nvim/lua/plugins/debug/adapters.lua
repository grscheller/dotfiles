--[[ Config Debugger Adapter Protocol (DAP) ]]

return {
   -- Auto install DAP Adapters
   {
      'jay-babu/mason-nvim-dap.nvim',
      dependencies = {
         'williamboman/mason.nvim',
         'mfussenegger/nvim-dap',
      },
      opts = {
         ensure_installed = { 'debugpy' },
         handlers = {},
      },
   },

   -- Python DAP adapter
   {
      'mfussenegger/nvim-dap-python',
      ft = 'python',
      dependencies = {
         'mfussenegger/nvim-dap',
         'jay-babu/mason-nvim-dap.nvim',
      },
      config = function()
         -- Mason installs debugpy here:
         local debugpy_path = vim.fn.stdpath('data')
            .. '/mason/packages/debugpy/venv/bin/python'
         require('dap-python').setup(debugpy_path)
      end,
   },
}
