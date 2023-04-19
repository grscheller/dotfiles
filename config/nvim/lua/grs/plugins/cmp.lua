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
         'hrsh7th/cmp-nvim-lua',
         'hrsh7th/cmp-path',
         {
            'L3MON4D3/LuaSnip',
            dependencies = {
               'rafamadriz/friendly-snippets',
            },
         },
         'lukas-reineke/cmp-rg',
         'lukas-reineke/cmp-under-comparator',
         'onsails/lspkind.nvim',
         'saadparwaiz1/cmp_luasnip',
         'saecki/crates.nvim',
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

         local basic_mappings = {
            ['<c-d>'] = cmp.mapping.scroll_docs(-4),
            ['<c-f>'] = cmp.mapping.scroll_docs(4),
            ['<cr>'] = cmp.mapping.confirm(confirm_opts),
            ['<c-space>'] = cmp.mapping.close(),
            ['<c-a>'] = cmp.mapping.abort(),
            ['<tab>'] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.select_next_item(select_opts)
               elseif cursor_has_words_before_it() then
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
            ['<up>'] = cmp.mapping.select_prev_item(select_opts),
            ['<down>'] = cmp.mapping.select_next_item(select_opts),
         }

         local snippet_mappings = {
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

         local insert_mappings = vim.tbl_extend("error", basic_mappings, snippet_mappings)

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
                  nvim_lsp = '[lsp]',
                  nvim_lsp_signature_help = '[sh]',
                  nvim_lua = '[lua]',
                  path = '[path]',
                  rg = '[rg]',
               },
            },
         }

         cmp.setup {
            sorting = sorting,
            snippet = snippet,
            window = window,
            sources = cmp.config.sources(
               {
                  { name = 'nvim_lsp_signature_help' },
                  { name = 'nvim_lsp' },
                  { name = 'nvim_lua' },
                  { name = 'crates' },
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
               }
            ),
            formatting = formatting,
            mapping = insert_mappings,

         }

         cmp.setup.cmdline(':', {
            sorting = sorting,
            snippet = snippet,
            window = window,
            sources = cmp.config.sources(
               {
                  { name = 'path' }
               },
               {
                  { name = 'cmdline' }
               }),
            -- TODO: base next one on sources
            formatting = formatting,
            mapping = basic_mappings,
         })

         cmp.setup.cmdline('/', {
            sorting = sorting,
            snippet = snippet,
            window = window,
            sources = {
               {
                  name = 'buffer',
               },
            },
            -- TODO: base next one on sources
            formatting = formatting,
            mapping = basic_mappings,
         })

         cmp.setup.cmdline('?', {
            sorting = sorting,
            snippet = snippet,
            window = window,
            sources = {
               {
                  name = 'buffer',
               },
            },
            -- TODO: base next one on sources
            formatting = formatting,
            mapping = basic_mappings,
         })
      end,
   },

}
