--[[ Library of funct:wqions related to vim/nvim API ]]

local M = {}

M.notify = require('notify')

--[[ User messaging ]]

function M.msg_return_to_continue(message)
   local reply = 'Hit RETURN to continue...\n'
   -- not overriding (for bootstrapping nvim config)
   vim.notify(message, vim.log.levels.WARN)
   if vim.g.grs_skip_msg_reply ~= 1 then
      vim.ui.input({ prompt = reply }, function(_) end)
   end
end

--[[ Cursor related positioning/inquery functions ]]

function M.cursor_has_words_before_it()
   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
   return col ~= 0
      and vim.api
      .nvim_buf_get_lines(0, line - 1, line, true)[1]
      :sub(col, col)
      :match '%s'
      == nil
end

--[[ Neovim version information ]]

function M.nvim_version_str()
   local version = vim.version()
   if not version then
      return 'unknown'
   end

   local prerelease = ''
   if version.prerelease then
      prerelease = '-prerelease'
   end

   return string.format('%d.%d.%d%s',
      version.major, version.minor, version.patch, prerelease)
end

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
