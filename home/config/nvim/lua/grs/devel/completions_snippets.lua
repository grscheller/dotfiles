--[[ Completions using nvim-cmp and luasnip ]]

local ok, cmp, snip, lspkind, cmp_under_comparator

ok, cmp = pcall(require, 'cmp')
if ok and cmp then
   cmp_under_comparator = require('cmp-under-comparator')
else
   return
end

ok, snip = pcall(require, 'luasnip')
if ok then
   snip.snippets = {}
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

-- Configure nvim-cmp, borrowing heavlily from
-- https://github.com/wbthomason/dotfiles/blob/linux/neovim/.config/nvim/lua/config/cmp.lua
local function hasWordsBefore()
   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup {
   sorting = {
      comparators = {
         cmp.config.compare.offset,
         cmp.config.compare.exact,
         cmp.config.compare.score,
         cmp_under_comparator.under,
         cmp.config.compare.kind,
         cmp.config.compare.sort_text,
         cmp.config.compare.length,
         cmp.config.compare.order
      }
   },
   snippet = {
      expand = function(args)
         snip.lsp_expand(args.body)
      end
   },
   window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered()
   },
   formatting = {
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
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping( cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C- >'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable,
      ['<C-e>'] = cmp.mapping {
         i = cmp.mapping.abort(),
         c = cmp.mapping.close()
      },
      ['<CR>'] = cmp.mapping.confirm {
         select = true,
         behavior = cmp.ConfirmBehavior.Replace
      },
      ['<Tab>'] = cmp.mapping(
         function(fallback)
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
         { 'i', 's' }
      ),
      ['<S-Tab>'] = cmp.mapping(
         function(fallback)
            if cmp.visible() then
               cmp.select_prev_item()
            elseif snip.jumpable(-1) then
               snip.jump(-1)
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
      { name = 'luasnip' },
      { name = 'nvim_lua' },
      { name = 'path' },
      { name = 'buffer' },
      { name = 'rg',
        keyword_length = 3,
        max_item_count = 8,
        option = {
           additional_arguments = '--smart-case --hidden'
        }
      }
   }
}

cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources(
         {{ name = 'path' }},
         {{ name = 'cmdline' }}
      )
   }
)

cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
         { name = 'buffer' }
      }
   }
)
