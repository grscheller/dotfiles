--[[ Lint certain file types on write ]]

-- formatter.nvim invokes command-line tools to perform formatting
-- operations. Formatters are all opt-in. These can be user configurable or
-- default configurations can be used. See lua/formatter/filetypes/ in the
-- plugin's directory for all the available default configurations. See the
-- README.md for how to set up a user defined configuration.

local autogrp = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

return {

   {
      'mhartington/formatter.nvim',
      keys = {
         { mode = 'n', '<leader>F', '<Cmd>:Format<CR>' },
      },
      config = function()
         local formatter = require 'formatter'
         formatter.setup {
            logging = true,
            log_level = vim.log.levels.WARN,
            filetype = {
               lua = {
                  require('formatter.filetypes.lua').stylua,
               },
               toml = {
                  require('formatter.filetypes.toml').taplo,
               },
            },
         }

         local grsFormatGrp = autogrp('GrsFormat', { clear = true })
         autocmd('User', {
            pattern = 'FormatterPost',
            callback = function(ev)
               local msg = 'formatting completed: %s'
               vim.notify(string.format(msg, vim.api.nvim_buf_get_name(ev.buf)))
            end,
            group = grsFormatGrp,
            desc = 'Format code via formatter.nvim',
         })
      end,
   },
}
