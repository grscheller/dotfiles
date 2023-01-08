--[[ Completions & Snippets ]]

function cursor_has_words_before_it()
   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
   return col ~= 0
      and vim.api
      .nvim_buf_get_lines(0, line - 1, line, true)[1]
      :sub(col, col)
      :match '%s'
      == nil
end

cmp = require 'cmp'
cmp_under_comparator = require 'cmp-under-comparator'
   if ok then
      cmp_comparators = {
         cmp.config.compare.offset,
         cmp.config.compare.exact,
         cmp.config.compare.score,
         cmp.config.compare.recently_used,
         cmp.config.compare.locality,
         cmp_under_comparator.under,
         cmp.config.compare.kind,
         cmp.config.compare.sort_text,
         cmp.config.compare.length,
         cmp.config.compare.order,
      }
   else
      cmp_comparators = {
         cmp.config.compare.offset,
         cmp.config.compare.exact,
         cmp.config.compare.score,
         cmp.config.compare.recently_used,
         cmp.config.compare.locality,
         cmp.config.compare.kind,
         cmp.config.compare.sort_text,
         cmp.config.compare.length,
         cmp.config.compare.order,
      }
   end

luasnip = pcall(require, 'luasnip')
luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()

lspkind = require 'lspkind'
lspkind.init()

local select_opts = { behavior = cmp.SelectBehavior.Select }
local confirm_opts = {
   select = true,
   behavior = cmp.ConfirmBehavior.Replace,
}

cmp.setup {
   sorting = { comparators = cmp_comparators },

   snippet = {
      expand = function(args)
         luasnip.lsp_expand(args.body)
      end,
   },

   window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
   },

   formatting = {
      expandable_indicator = true,
      fields = { 'abbr', 'kind', 'menu' },
      format = lspkind.cmp_format {
         mode = 'symbol',
         maxwidth = 50,
         ellipsis = '…',
         menu = {
            buffer = '[buf]',
            cmdline = '[cmd]',
            luasnip = '[snip]',
            nvim_lsp = '[lsp]',
            nvim_lsp_signature_help = '[lsp-sh]',
            nvim_lua = '[lua]',
            path = '[path]',
            rg = '[rg]',
         },
      },
   },

   sources = cmp.config.sources({
      { name = 'nvim_lsp_signature_help' },
      { name = 'nvim_lua' },
      { name = 'nvim_lsp' },
   }, {
      {
         name = 'path',
         option = {
            label_trailing_slash = true,
            trailing_slash = false,
         },
      },
      {
         name = 'buffer',
         option = {
            get_bufnrs = function()
               return vim.api.nvim_list_bufs()
            end,
         },
      },
      {
         name = 'rg',
         option = {
            additional_arguments = '--smart-case --hidden',
         },
         keyword_length = 3,
         max_item_count = 12,
      },
   }, {
      { name = 'luasnip' },
   }),

   mapping = {
      ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
      ['<Down>'] = cmp.mapping.select_next_item(select_opts),

      ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
      ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),

      ['<C- >'] = cmp.mapping.close(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm(confirm_opts),
      ['<C-y>'] = cmp.mapping.confirm(confirm_opts),

      ['<Tab>'] = cmp.mapping(function(fallback)
         if cmp.visible() then
            cmp.select_next_item()
         elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
         elseif cursor_has_words_before_it() then
            cmp.complete()
         else
            fallback()
         end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
         if cmp.visible() then
            cmp.select_prev_item()
         elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
         else
            fallback()
         end
      end, { 'i', 's' }),

      ['<C-s>'] = cmp.mapping.complete {
         config = {
            sources = { { name = 'luasnip' } },
         },
      },
      ['<c-f>'] = cmp.mapping(function(fallback)
         if luasnip.jumpable(1) then
            luasnip.jump(1)
         else
            fallback()
         end
      end),
      ['<c-b>'] = cmp.mapping(function(fallback)
         if luasnip.jumpable(-1) then
            luasnip.jump(-1)
         else
            fallback()
         end
      end),
   },
}

cmp.setup.cmdline(':', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = { { name = 'cmdline' } },
})

cmp.setup.cmdline('/', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = { { name = 'buffer' } },
})

cmp.setup.cmdline('?', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = { { name = 'buffer' } },
})
