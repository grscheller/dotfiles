--[[ Library of funct:wqions related to vim/nvim API ]]

local M = {}

--[[ Use Vim for vim API - until Selene or Neovim gets fixed ]]
local Vim = vim

M.g = Vim.g
M.o = Vim.o
M.bo = Vim.bo
M.wo = Vim.wo
M.opt = Vim.opt
M.opt_global = Vim.opt_global
M.opt_local = Vim.opt_local
M.api = Vim.api
M.cmd = Vim.cmd
M.diagnostic = Vim.diagnostic
M.highlight = Vim.highlight
M.keymap = Vim.keymap
M.lsp = Vim.lsp
M.schedule = Vim.schedule

-- overrides
M.notify = require('notify')

--[[ User messaging ]]

function M.msg_return_to_continue(message)
   local reply = 'Hit RETURN to continue...\n'
   -- not overriding (for bootstrapping nvim config)
   vim.notify(message, Vim.log.levels.WARN)
   if Vim.g.grs_skip_msg_reply ~= 1 then
      Vim.ui.input({ prompt = reply }, function(_) end)
   end
end

--[[ Cursor related positioning/inquery functions ]]

function M.cursor_has_words_before_it()
   local line, col = unpack(Vim.api.nvim_win_get_cursor(0))
   return col ~= 0 and
      Vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
      :sub(col, col)
      :match '%s' == nil
end

--[[ Neovim version information ]]

function M.nvim_version_str()
   local version = Vim.version()
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
