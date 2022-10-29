--[[ Completions & Snippets ]]

local grs_utils = require('grs.util.utils')

local ok
local cmp_under_comparator
local cmp, luasnip, lspkind
local msg = grs_utils.msg_hit_return_to_continue

ok, cmp = pcall(require, 'cmp')
if ok and cmp then
   ok, cmp_under_comparator = pcall(require, 'cmp-under-comparator')
   if not ok then
      msg('Problem in completions.lua: cmp_under_comparator failed to load')
      return
   end
else
   msg('Problem in completions.lua: cmp failed to load')
   return
end

ok, luasnip = pcall(require, 'luasnip')
if ok then
   require('luasnip.loaders.from_vscode').lazy_load()
else
   msg('Problem in completions.lua: luasnip failed to load')
   return
end

ok, lspkind = pcall(require, 'lspkind')
if ok then
   lspkind.init()
else
   msg('Problem in completions.lua: lspkind failed to load')
   return
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
            luasnip = '[snip]',
            nvim_lsp_signature_help = '[lsp-sh]',
            nvim_lsp = '[lsp]',
            nvim_lua = '[lua]',
            buffer = '[buf]',
            rg = '[rg]',
            path = '[path]',
            cmdline = '[cmd]',
            nvim_lsp_document_symbol = '[lsp-ds]',
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
            elseif grs_utils.cursor_has_words_before_it() then
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
   sources = cmp.config.sources(
      {{ name = 'nvim_lsp_signature_help' },
       { name = 'nvim_lsp' },
       { name = 'nvim_lua' }},
      {{ name = 'path',
         option = {
            label_trailing_slash = true,
            trailing_slash = true
         } },
       { name = 'buffer',
         option = {
            get_bufnrs = function()
               return vim.api.nvim_list_bufs()
            end
         } },
       { name = 'rg',
         option = {
            additional_arguments = '--smart-case --hidden'
         },
         keyword_length = 3,
         max_item_count = 12 }})
}

cmp.setup.cmdline(':', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = cmp.config.sources({{ name = 'path' }}, {{ name = 'cmdline' }})
})

cmp.setup.cmdline('/', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = {{ name = 'nvim_lsp_document_symbol' }, { name = 'buffer' }}
})

cmp.setup.cmdline('?', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = {{ name = 'nvim_lsp_document_symbol' }, { name = 'buffer' }}
})
