--[[ Completions and Snippets ]]

local ok, cmp, luasnip, lspkind, cmp_under_comparator

ok, cmp = pcall(require, 'cmp')
if ok and cmp then
   cmp_under_comparator = require('cmp-under-comparator')
else
   return
end

ok, luasnip = pcall(require, 'luasnip')
if ok then
   require('luasnip.loaders.from_vscode').lazy_load()
else
   return
end

ok, lspkind = pcall(require, 'lspkind')
if ok then
   lspkind.init()
else
   return
end

local function hasWordsBefore()
   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
   return col ~= 0 and vim.api.nvim_buf_get_lines(
      0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup {
   sorting = {
      comparators = {
         cmp.config.compare.offset,
         cmp.config.compare.exact,
         cmp.config.compare.score,
         cmp.config.compare.recently_used,
         cmp.config.compare.locality,
         cmp_under_comparator.under,
         cmp.config.compare.kind,
         cmp.config.compare.sort_text,
         cmp.config.compare.length,
         cmp.config.compare.order
      }
   },
   snippet = {
      expand = function(args)
         luasnip.lsp_expand(args.body)
      end
   },
   window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered()
   },
   formatting = {
      expandable_indicator = true,
      fields = { 'abbr', 'kind', 'menu' },
      format = lspkind.cmp_format {
         mode = 'symbol',
         maxwidth = 50,
         ellipsis = '…',
         menu = {
            nvim_lsp = '[lsp]',
            nvim_lsp_signature_help = '[lsp-sh]',
            nvim_lua = '[lua]',
            path = '[path]',
            buffer = '[buf]',
            rg = '[rg]',
            luasnip = '[snip]'
         }
      }
   },
   mapping = cmp.mapping.preset.insert {
      ['<C-y>'] = cmp.config.disable,
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping( cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C- >'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-s>'] = cmp.mapping.complete {
         config = {
            sources = {{ name = 'luasnip' }}
         }
      },
      ['<C-e>'] = cmp.mapping {
         i = cmp.mapping.abort(),
         c = cmp.mapping.close()
      },
      ['<CR>'] = cmp.mapping.confirm {
         select = false,
         behavior = cmp.ConfirmBehavior.Replace
      },
      ['<Tab>'] = cmp.mapping(
         function(fallback)
            if cmp.visible() then
               cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
               luasnip.expand_or_jump()
            elseif hasWordsBefore() then
               cmp.complete()
            else
               fallback()
            end
         end,
         { 'i', 's' }
      ),
      ['<S-Tab>'] = cmp.mapping(
         function(fallback)
            if cmp.visible() then
               cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
               luasnip.jump(-1)
            else
               fallback()
            end
         end,
         { 'i', 's' }
      )
   },
   sources = {
     { name = 'nvim_lsp_signature_help' },
     { name = 'nvim_lsp' },
     { name = 'nvim_lua' },
     { name = 'buffer',
       option = {
         get_bufnrs = function()
            return vim.api.nvim_list_bufs()
         end
       }
     },
     { name = 'rg',
       keyword_length = 3,
       max_item_count = 12,
       option = {
         additional_arguments = '--smart-case --hidden'
       }
     },
     { name = 'path',
       option = {
         label_trailing_slash = true,
         trailing_slash = true
       }
     }
   },
   experimental = {
      ghost_text = true
   }
}

cmp.setup.cmdline(':', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = cmp.config.sources(
     {{ name = 'path' }},
     {{ name = 'cmdline' }}
   )
})

cmp.setup.cmdline('/', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = cmp.config.sources(
     {{ name = 'nvim_lsp_document_symbol' }},
     {{ name = 'buffer' }}
   )
})

cmp.setup.cmdline('?', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = {{ name = 'buffer' }}
})
