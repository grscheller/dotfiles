-- Reformateed ane tweaked from
-- https://www.reddit.com/r/neovim/comments/up5ahi/using_the_builtin_lsp_client_without_nvimlspconfig/
-- any copyrights retained by original owner u/vonheikemen.
--

local M = {}
local state = { autocmd = {} }

local augroup = vim.api.nvim_create_augroup('client_cmds', { clear = true })
local autocmd = vim.api.nvim_create_autocmd
local fmt = string.format

M.start = function(name)
   local config = M.config(name)
   local id = vim.lsp.start_client(config.params)
   if not id then
      return
   end

   if vim.v.vim_did_enter == 1 then
      M.buf_attach(config, id)
   end

   state.autocmd[id] = autocmd('BufEnter', {
      pattern = '*',
      group = augroup,
      desc = fmt('Attach LSP: %s', name),
      callback = function()
         M.buf_attach(config, id)
      end,
   })
end

M.config = function(name, opts)
   local server_opts = require(fmt('lsp.configs.%s', name))
   server_opts.params.on_exit = M.on_exit

   return server_opts
end

M.buf_attach = function(config, id)
   local supported = config.filetypes[vim.bo.filetype]
   if not supported then
      return
   end

   local bufnr = vim.api.nvim_get_current_buf()
   vim.lsp.buf_attach_client(bufnr, id)
end

M.on_exit = function(code, signal, client_id)
   vim.schedule(function()
      vim.api.nvim_del_autocmd(state.autocmd[client_id])
   end)
end

return M
