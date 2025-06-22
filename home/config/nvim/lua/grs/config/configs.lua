--[[ Other (grs) configurations ]]

local M = {}

-- Configure diagnostics
vim.diagnostic.config {
   virtual_text = true, -- virtual text sometimes gets in the way
   underline = false,  -- set to true if virtual text is false
   update_in_insert = false,
   severity_sort = true,
   float = {
      source = 'if_many',
   },
   signs = true,
}

M.mason_bin = vim.g.grs_home_dir .. '/.local/share/nvim/mason/bin'

return M
