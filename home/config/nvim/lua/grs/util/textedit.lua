--[[ Library of functions for simple text editing ]]

local M = {}

local Vim = require 'grs.lib.Vim'

--[[ Line numbering related functions ]]

function M.toggle_line_numbering()
   if not Vim.wo.number and not Vim.wo.relativenumber then
      Vim.wo.number = true
      Vim.wo.relativenumber = true
   elseif Vim.wo.number and Vim.wo.relativenumber then
      Vim.wo.relativenumber = false
   else
      Vim.wo.number = false
      Vim.wo.relativenumber = false
   end
end

return M
