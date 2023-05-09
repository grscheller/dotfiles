-- Reformateed ane tweaked from
-- https://www.reddit.com/r/neovim/comments/up5ahi/using_the_builtin_lsp_client_without_nvimlspconfig/
-- any copyrights retained by original redit contributor u/vonheikemen.
--

local doautocmd = vim.api.nvim_exec_autocmds

local filetypes = {
   javascript = true,
   javascriptreact = true,
   ['javascript.jsx'] = true,
   typescript = true,
   typescriptreact = true,
   ['typescript.tsx'] = true,
}

local server = {
   cmd = { 'typescript-language-server', '--stdio' },
   name = 'tsserver',
   root_dir = vim.fn.getcwd(),
   capabilities = vim.lsp.protocol.make_client_capabilities(),
   on_attach = function(client, bufnr)
      -- default completion suggestions
      -- triggered by using `<C-x><C-o>`
      vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'

      -- Use lsp server instead of tags (whenever possible)
      vim.bo.tagfunc = 'v:lua.vim.lsp.tagfunc'

      -- declare your keybindings elsewhere
      doautocmd('User', { pattern = 'LSPKeybindings' })
   end,
   on_init = function(client, results)
      if results.offsetEncoding then
         client.offset_encoding = results.offsetEncoding
      end

      if client.config.settings then
         client.notify('workspace/didChangeConfiguration', {
            settings = client.config.settings,
         })
      end
   end,
}

return {
   filetypes = filetypes,
   params = server,
}
