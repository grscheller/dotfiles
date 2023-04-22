--[[ Completions & Snippets ]]

local text = require('grs.lib.text')

return {

   {
      'hrsh7th/nvim-cmp',
      dependencies = {
         'hrsh7th/cmp-buffer',
         'hrsh7th/cmp-cmdline',
         'hrsh7th/cmp-path',
         'lukas-reineke/cmp-rg',
         'lukas-reineke/cmp-under-comparator',
         'onsails/lspkind.nvim',
         {
            'saadparwaiz1/cmp_luasnip',
            {
               'L3MON4D3/LuaSnip',
               dependencies = {
                  'rafamadriz/friendly-snippets',
               },
            },
         },
      },
      event = { 'InsertEnter', 'CmdlineEnter' },
      config = function()
         local cmp = require 'cmp'
         local cmp_under_comparator = require 'cmp-under-comparator'
         local lspkind = require 'lspkind'
         local luasnip = require 'luasnip'

         require('luasnip.loaders.from_vscode').lazy_load()

         local sorting = {
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
               cmp.config.compare.order,
            },
         }

         local formatting = {
            expandable_indicator = true,
            fields = { 'abbr', 'kind', 'menu' },
            format = lspkind.cmp_format {
               mode = 'symbol_text',
               preset = 'default',
               maxwidth = 50,
               ellipsis_char = '…',
               menu = {
                  buffer = '[buf]',
                  cmdline = '[cmd]',
                  crates = '[crates]',
                  nvim_lua = '[lua]',
                  path = '[path]',
                  rg = '[rg]',
                  luasnip = '[snip]',
               },
            },
         }

         local snippet = {
            expand = function(args)
               luasnip.lsp_expand(args.body)
            end,
         }

         local window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
         }

         local select_opts = {
            behavior = cmp.SelectBehavior.Select,
         }
         local confirm_opts = {
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
         }

         local insert_mapping = {
            ['<c-d>'] = cmp.mapping.scroll_docs(-4),
            ['<c-f>'] = cmp.mapping.scroll_docs(4),
            ['<cr>'] = cmp.mapping.confirm(confirm_opts),
            ['<c-space>'] = cmp.mapping.close(),
            ['<c-a>'] = cmp.mapping.abort(),
            ['<tab>'] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.select_next_item(select_opts)
               elseif text.cursor_has_words_before_it() then
                  cmp.complete(confirm_opts)
               else
                  fallback()
               end
            end),
            ['<s-tab>'] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.select_prev_item(select_opts)
               else
                  fallback()
               end
            end),
            ['<c-p>'] = cmp.mapping.select_prev_item(select_opts),
            ['<c-n>'] = cmp.mapping.select_next_item(select_opts),
            ['<c-s>'] = cmp.mapping.complete {
               config = {
                  sources = {
                     { name = 'luasnip' },
                  },
               },
            },
            ['<c-right>'] = cmp.mapping(function(fallback)
               if luasnip.jumpable(1) then
                  luasnip.jump(1)
               else
                  fallback()
               end
            end),
            ['<c-left>'] = cmp.mapping(function(fallback)
               if luasnip.jumpable(-1) then
                  luasnip.jump(-1)
               else
                  fallback()
               end
            end),
         }

         -- unknown or unused sources are ignored
         local sources = {
            { name = 'nvim_lua' },
            { name = 'crates' },
            {
               name = 'path',
               option = {
                  label_trailing_slash = false,
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
            {
               name = 'luasnip',
            },
         }

         local cmdline_sources = {
            {
               name = 'path',
               option = {
                  label_trailing_slash = false,
                  trailing_slash = false,
               },
            },
            {
               name = 'cmdline',
               option = {
                  ignore_cmds = { 'Man', '!', 'e', 'w' },
               },
            },
         }

         cmp.setup {
            sorting = sorting,
            formatting = formatting,
            snippet = snippet,
            window = window,
            mapping = insert_mapping,
            sources = sources,
         }

         cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmdline_sources,
         })

         cmp.setup.cmdline('/', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {{ name = 'buffer' }},
         })

         cmp.setup.cmdline('?', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {{ name = 'buffer' }},
         })
      end,
   },

}
