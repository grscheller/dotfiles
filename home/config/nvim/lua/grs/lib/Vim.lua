--[[ Library of functions related to vim/nvim API ]]

local M = {}

--[[ Vim API (until Selene or Neovim is fixed ]]

M.api = vim.api
M.cmd = vim.cmd
M.g = vim.g
M.highlight = vim.highlight
M.keymap = vim.keymap
M.schedule = vim.schedule

--[[ User messaging ]]

function M.msg_hit_return_to_continue(message)
   local reply = 'Hit RETURN to continue...\n'
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

return M
