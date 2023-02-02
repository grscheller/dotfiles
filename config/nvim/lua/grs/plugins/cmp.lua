--[[ Completions & Snippets ]]

local function cursor_has_words_before_it()
   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
   return col ~= 0
      and vim.api
      .nvim_buf_get_lines(0, line - 1, line, true)[1]
      :sub(col, col)
      :match '%s'
      == nil
end

return {

   {
      'hrsh7th/nvim-cmp',
      dependencies = {
         'hrsh7th/cmp-buffer',
         'hrsh7th/cmp-cmdline',
         'hrsh7th/cmp-nvim-lsp',
         'hrsh7th/cmp-nvim-lsp-signature-help',
         'hrsh7th/cmp-nvim-lua',
         'hrsh7th/cmp-path',
         { 'L3MON4D3/LuaSnip',
            dependencies = {
               'rafamadriz/friendly-snippets',
            },
         },
         'lukas-reineke/cmp-rg',
         'lukas-reineke/cmp-under-comparator',
         'onsails/lspkind.nvim',
         'saadparwaiz1/cmp_luasnip',
      },
      config = function()
         local cmp = require 'cmp'
         local lspkind = require 'lspkind'
         local luasnip = require 'luasnip'
         local vscode_loaders = require 'luasnip.loaders.from_vscode'
         local cmp_config_compare_under = require('cmp-under-comparator').under

         vscode_loaders.lazy_load()

         local select_opts = {
            behavior = cmp.SelectBehavior.Select
         }
         local confirm_opts = {
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
         }

         local mappings = {
            ['<up>'] = cmp.mapping.select_prev_item(select_opts),
            ['<down>'] = cmp.mapping.select_next_item(select_opts),

            ['<c-p>'] = cmp.mapping.select_prev_item(select_opts),
            ['<c-n>'] = cmp.mapping.select_next_item(select_opts),

            ['<c-u>'] = cmp.mapping.scroll_docs(-4),
            ['<c-d>'] = cmp.mapping.scroll_docs(4),

            ['<c- >'] = cmp.mapping.close(),
            ['<c-a>'] = cmp.mapping.abort(),
            ['<cr>'] = cmp.mapping.confirm(confirm_opts),
            ['<c-y>'] = cmp.mapping.confirm(confirm_opts),

            ['<tab>'] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.select_next_item()
               elseif luasnip.expand_or_locally_jumpable() then
                  luasnip.expand_or_jump()
               elseif cursor_has_words_before_it() then
                  cmp.complete()
               else
                  fallback()
               end
            end),
            ['<s-tab>'] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.select_prev_item()
               elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
               else
                  fallback()
               end
            end),

            ['<c-s>'] = cmp.mapping.complete {
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
         }

         local cmd_mappings = {
            ['<c- >'] = cmp.mapping.close(),
            ['<c-a>'] = cmp.mapping.abort(),
            ['<tab>'] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.select_next_item()
               elseif cursor_has_words_before_it() then
                  cmp.complete()
               else
                  fallback()
               end
            end),
            ['<s-tab>'] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.select_prev_item()
               else
                  fallback()
               end
            end),
         }

         cmp.setup {
            sorting = {
               comparators = {
                  cmp.config.compare.offset,
                  cmp.config.compare.exact,
                  cmp.config.compare.score,
                  cmp.config.compare.recently_used,
                  cmp.config.compare.locality,
                  cmp_config_compare_under,
                  cmp.config.compare.kind,
                  cmp.config.compare.sort_text,
                  cmp.config.compare.length,
                  cmp.config.compare.order,
               },
            },
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
                  mode = 'symbol_text',
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
            mapping = mappings,
            sources = cmp.config.sources(
               {
                  { name = 'nvim_lsp_signature_help' },
                  { name = 'nvim_lsp' },
                  { name = 'nvim_lua' },
                  { name = 'luasnip' },
               },
               {
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
               }),

         }
         cmp.setup.cmdline(':', {
            mapping = cmd_mappings,
            sources = {
               { name = 'path' }
            },
            {
               { name = 'cmdline' }
            },
         })
         cmp.setup.cmdline('/', {
            mapping = cmd_mappings,
            sources = { { name = 'buffer' } },
         })
         cmp.setup.cmdline('?', {
            mapping = cmd_mappings,
            sources = { { name = 'buffer' } },
         })
      end,
      event = 'InsertEnter',
   },

}
