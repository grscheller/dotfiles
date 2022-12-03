--[[ Library of functions for simple text editing ]]

local M = {}

--[[ Line numbering related functions ]]

function M.toggle_line_numbering()
   if not vim.wo.number and not vim.wo.relativenumber then
      vim.wo.number = true
      vim.wo.relativenumber = true
   elseif vim.wo.number and vim.wo.relativenumber then
      vim.wo.relativenumber = false
   else
      vim.wo.number = false
      vim.wo.relativenumber = false
   end
end

return M
