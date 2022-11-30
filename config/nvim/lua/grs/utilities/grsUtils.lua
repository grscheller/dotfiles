--[[ Utility Functions ]]

-- TODO: Break below catagories into separte modules

local M = {}

--[[ User messaging ]]

function M.msg_hit_return_to_continue(message)
   local reply = 'Hit RETURN to continue...\n'
   vim.notify(message, vim.log.levels.WARN)
   if vim.g.grs_skip_msg_reply ~= 1 then
      vim.ui.input({ prompt = reply }, function(_) end)
   end
end

--[[ Cursor inquery functions ]]

function M.cursor_has_words_before_it()
   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
   return col ~= 0
       and vim.api
       .nvim_buf_get_lines(0, line - 1, line, true)[1]
       :sub(col, col)
       :match '%s'
       == nil
end

--[[ Line numbering functions ]]

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

--[[ Functional Programming ]]

-- Flatten an array of arrays - no error checks (should JIT compile well)
M.iFlatten = function(ArrayOfArrays)
   local ConcatenatedList = {}
   for _, v in ipairs(ArrayOfArrays) do
      for _, w in ipairs(v) do
         table.insert(ConcatenatedList, w)
      end
   end
   return ConcatenatedList
end

-- get keys filtered by predicate
M.getFilteredKeys = function(t, p)
   local filteredKeys = {}
   for k, v in pairs(t) do
      if p(k, v) then table.insert(filteredKeys, k) end
   end
   return filteredKeys
end

return M
