--[[ Completions using nvim-cmp and luasnip ]]

local ok_cmp, cmp = pcall(require, 'cmp')
local ok_luasnip, luasnip = pcall(require, 'luasnip')
if not ok_cmp or not ok_luasnip then
   if not ok_cmp then print('Problem loading nvim-cmp: ' .. cmp) end
   if not ok_luasnip then print('Problem loading luasnip: ' .. luasnip) end
   return
end

-- Have Luasnip lazy load snippets
require('luasnip.loaders.from_vscode').lazy_load()

local function myHasWordsBefore()
   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup {
   snippet = {
      expand = function(args)
         luasnip.lsp_expand(args.body)
      end
   },

   window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered()
   },

   mapping = cmp.mapping.preset.insert {
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-<Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
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
         elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
         elseif myHasWordsBefore() then
            cmp.complete()
         else
            fallback()
         end
      end,
      ['<S-Tab>'] = function(fallback)
         if cmp.visible() then
            cmp.select_prev_item()
         elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
         else
            fallback()
         end
      end
   },

   sources = cmp.config.sources(
      {
         { name = 'nvim_lsp' },
         { name = 'nvim_lsp_signature_help' },
         { name = 'luasnip' }
      },
      {
         { name = 'buffer' },
         { name = 'path' }
      },
      {
         { name = 'rg',
           keyword_length = 5,
           max_item_count = 5,
           option = { additional_arguments = '--smart-case --hidden' }
         }
      }
   )
}

cmp.setup.cmdline('/',
   {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { { name = 'buffer' } }
   }
)

cmp.setup.cmdline(':',
   {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources(
         { { name = 'path' } },
         { { name = 'cmdline' } }
      )
   }
)
