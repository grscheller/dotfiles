--[[ Basic Neovim Text Editing ]]

local M = {}

--[[ Predicates ]]

---Return true when there are non-whitespace characters before cursor.
---@return boolean
M.cursor_has_words_before_it = function()
   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
end

--[[ Padding - 1 byte characters only (no UTF-8) ]]

---Pad string or number on left
---@param value string|number
---@param width number
---@param char string|nil
---@return string
M.pad_left = function(value, width, char)
   local str = tostring(value)
   local diff = width - #str
   if diff > 0 then
      return string.rep(char and tostring(char) or ' ', diff) .. str
   elseif diff < 0 then
      return string.rep(char and tostring(char) or ' ', -diff) .. str:sub(1,diff)
   else
      return str
   end
end

---Pad string or number on right and return result
---@param value string|number
---@param width number
---@param char string|nil
---@return string
M.pad_right = function(value, width, char)
   local str = tostring(value)
   local diff = width - #str
   if diff > 0 then
      return str .. string.rep(char and tostring(char) or ' ', diff)
   elseif diff < 0 then
      return str:sub(1, width)
   else
      return str
   end
end

return M
