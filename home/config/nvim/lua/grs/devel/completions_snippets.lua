--[[ Completions using nvim-cmp and luasnip ]]

local ok, cmp, snip, lspkind

ok, cmp = pcall(require, 'cmp')
if not ok or not cmp then
   print('Problem loading nvim-cmp: %s', cmp)
   return
end

ok, snip = pcall(require, 'luasnip')
if not ok then
   print('Problem loading luasnip: %s', snip)
   return
end

ok, lspkind = pcall(require, 'lspkind')
if not ok then
   print('Problem loading lspkind: %s', lspkind)
   return
end

lspkind.init()

-- Configure luasnip 
snip.snippets = {}
require('luasnip.loaders.from_vscode').lazy_load()  -- lazy load vscode format snippets

-- Configure nvim-cmp
local function hasWordsBefore()
   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup {
   snippet = {
      expand = function(args)
         snip.lsp_expand(args.body)
      end
   },
   window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered()
   },
   mapping = cmp.mapping.preset.insert {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-c>'] = cmp.mapping.complete(),
      ['<C- >'] = cmp.mapping.abort(),
      ['<CR>'] = function(fallback)
         if cmp.visible() then
            cmp.confirm { select = true }
         else
            fallback()
         end
      end,
      ['<Tab>'] = function(fallback)
         if cmp.visible() then
            cmp.select_next_item()
         elseif snip.expand_or_jumpable() then
            snip.expand_or_jump()
         elseif hasWordsBefore() then
            cmp.complete()
         else
            fallback()
         end
      end,
      ['<S-Tab>'] = function(fallback)
         if cmp.visible() then
            cmp.select_prev_item()
         elseif snip.jumpable(-1) then
            snip.jump(-1)
         else
            fallback()
         end
      end
   },
   sources = cmp.config.sources {
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'nvim_lua' },
      { name = 'path' },
      { name = 'buffer' },
      { name = 'rg',
        keyword_length = 3,
        max_item_count = 8,
        option = {
           additional_arguments = '--smart-case --hidden'
        }
      },
      { name = 'luasnip' }
   },
   formatting = {
      format = lspkind.cmp_format {
         mode = 'symbol',
         maxwidth = 50,
         ellipsis = '…',
         menu = {
            nvim_lsp = "[lsp]",
            nvim_lsp_signature_help = "[lsp-sh]",
            nvim_lua = "[lua]",
            path = "[path]",
            buffer = "[buf]",
            rg = "[rg]",
            luasnip = "[snip]"
         }
      }
   }
}

cmp.setup.cmdline(':', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = cmp.config.sources {
      { name = 'path' },
      { name = 'cmdline' }
   }
})

cmp.setup.cmdline('/', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = {
      { name = 'buffer' }
   }
})
