--[[ Library of functions related to vim/nvim API ]]

local M = {}

--[[ Vim API (until Selene or Neovim get fixed ]]

M.g = vim.g
M.o = vim.o
M.bo = vim.bo
M.wo = vim.wo
M.opt = vim.opt
M.opt_global = vim.opt_global
M.opt_local = vim.opt_local
M.api = vim.api
M.cmd = vim.cmd
M.diagnostic = vim.diagnostic
M.highlight = vim.highlight
M.keymap = vim.keymap
M.lsp = vim.lsp
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
   return col ~= 0 and
      vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
      :sub(col, col)
      :match '%s' == nil
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
