--[[ LSP client configuration -- MUST be required before `core.lazy`

     Ordering constraint: plugins may read `vim.lsp.config['*']` when
     their `plugin/` files are sourced. blink.cmp, for example, reads
     `vim.lsp.config['*'].capabilities`, folds it into its own via
     `get_lsp_capabilities()`, and writes the result back. That read
     is unguarded, so `'*'` must already be a table by then.

     blink.cmp is currently lazy loaded on InsertEnter/CmdlineEnter,
     so it is sourced long after `init.lua` finishes. Establishing
     `'*'` before lazy.nvim removes the dependency on that timing.

     Post-lazy LSP concerns -- keymaps, user commands, autocmds --
     live in `config.lsp`.
]]

--[[ Capabilities added to all clients.

      Merged on top of the defaults from `vim.lsp.protocol.make_client_capabilities()`, so only the
      deltas need to be listed here.

      Note: The call form `vim.lsp.config('*', cfg)` merges, while
            the assignment form `vim.lsp.config['*'] = cfg` replaces.

            Keeping the call form.
]]
vim.lsp.config('*', {
   capabilities = {
      workspace = {
         -- Neovim leaves this off by default for performance. See
         -- the inotify-tools note in `init.lua`.
         didChangeWatchedFiles = {
            dynamicRegistration = true,
         },
      },
      textDocument = {
         semanticTokens = {
            multilineTokenSupport = true,
         },
      },
   },
})

--[[ Enable Neovim's native LSP mechanism.

     This only records the names and installs a FileType autocmd.
     Each `lsp/<name>.lua` is resolved off the runtimepath when a
     client actually attaches, which is well after lazy.nvim has
     extended the runtimepath, hence safe to call before `core.lazy`.
]]
vim.lsp.enable(require('config.tooling').lsp_servers_nvim)

--[[ LSP related autocmds ]]

-- Auto-refresh code lens when a capable server attaches.
vim.api.nvim_create_autocmd('LspAttach', {
   group = vim.api.nvim_create_augroup(
      'lsp-codelens',
      { clear = true }
   ),
   callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client:supports_method 'textDocument/codeLens' then
         vim.lsp.codelens.enable(true, { bufnr = args.buf })
      end
   end,
})
