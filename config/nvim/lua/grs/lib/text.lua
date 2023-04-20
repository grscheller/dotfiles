--[[ Neovim Text Editing in Lua ]]

local M = {}

---Predicate to determine if there are non-whitespace characters before cursor.
---@return boolean
M.cursor_has_words_before_it = function ()
   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
   return col ~= 0
      and vim.api
      .nvim_buf_get_lines(0, line - 1, line, true)[1]
      :sub(col, col)
      :match '%s'
      == nil
end

return M
