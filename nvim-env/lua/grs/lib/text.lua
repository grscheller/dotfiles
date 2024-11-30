--[[ Basic Neovim Text Editing ]]

local M = {}

--[[ Predicates ]]

---Return true when there are non-whitespace characters before cursor.
---@return boolean
M.cursor_has_words_before_it = function ()
   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
end

--[[ Padding ]]

---Pad string or number on left
---@param value string|number
---@param width number
---@param char string|nil
---@return string
M.pad_left = function (value, width, char)
   if type(value) == 'string' then
      return string.format('%' .. tostring(width) .. 's', value)
   else
      return string.rep(char and tostring(char) or ' ', width - #tostring(value)) .. tostring(value)
   end
end

---Pad string or number on right and return result
---@param value string|number
---@param width number
---@param char string|nil
---@return string
M.pad_right = function (value, width, char)
   if type(value) == 'string' then
      return value .. string.rep(char and tostring(char) or ' ', width - #tostring(value))
   else
      local value_str = tostring(value)
      return value_str .. string.rep(char and tostring(char) or ' ', width - #value_str)
   end
end

return M
