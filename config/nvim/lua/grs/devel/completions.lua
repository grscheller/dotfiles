--[[ Completions & Snippets ]]

local utils = require('grs.util.utils')

local ok
local cmp_under_comparator
local cmp, luasnip, lspkind
local msg = utils.msg_hit_return_to_continue

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

local select_opts = { behavior = cmp.SelectBehavior.Select }
local confirm_opts = {
   select = true,
   behavior = cmp.ConfirmBehavior.Replace
}

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
            buffer = '[buf]',
            cmdline = '[cmd]',
            luasnip = '[snip]',
            nvim_lsp = '[lsp]',
            nvim_lsp_signature_help = '[lsp-sh]',
            nvim_lua = '[lua]',
            path = '[path]',
            rg = '[rg]'
         }
      }
   },
   mapping = {
      ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
      ['<Down>'] = cmp.mapping.select_next_item(select_opts),

      ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
      ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),

      ['<C- >'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<C-h>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm(confirm_opts),
      ['<C-y>'] = cmp.mapping.confirm(confirm_opts),

      --[[ ['<c-d>'] = cmp.mapping(
         function(fallback)
            if luasnip.jumpable(1) then
               luasnip.jump(1)
            else
               fallback()
            end
         end),

      ['<c-u>'] = cmp.mapping(
         function(fallback)
            if luasnip.jumpable(-1) then
               luasnip.jump(-1)
            else
               fallback()
            end
         end),
]]
      ['<Tab>'] = cmp.mapping(
         function(fallback)
            if cmp.visible() then
               cmp.select_next_item()
            elseif utils.cursor_has_words_before_it() then
               cmp.complete()
            else
               fallback()
            end
         end),

      ['<S-Tab>'] = cmp.mapping(
         function(fallback)
            if cmp.visible() then
               cmp.select_prev_item()
            else
               fallback()
            end
         end),

      ['<C-s>'] = cmp.mapping.complete {
         config = {
            sources = {{ name = 'luasnip' }}
         }
      }
   },
   sources = cmp.config.sources(
      {
         { name = 'nvim_lsp_signature_help' },
         { name = 'nvim_lua' },
         { name = 'nvim_lsp' }
      },
      {
         {
           name = 'path',
           option = {
              label_trailing_slash = true,
              trailing_slash = true
           }
         },
         {
           name = 'buffer',
           option = {
              get_bufnrs = function()
                 return vim.api.nvim_list_bufs()
              end
           }
         },
         {
           name = 'rg',
           option = {
              additional_arguments = '--smart-case --hidden'
           },
           keyword_length = 3,
           max_item_count = 12
         }
      })
}

cmp.setup.cmdline(':', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = {{ name = 'cmdline' }}
})

cmp.setup.cmdline('/', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = {{ name = 'buffer' }}
})

cmp.setup.cmdline('?', {
   mapping = cmp.mapping.preset.cmdline(),
   sources = {{ name = 'buffer' }}
})
