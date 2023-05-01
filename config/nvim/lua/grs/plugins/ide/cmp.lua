--[[ Completions & Snippets ]]
--
-- nvim-cmp is a completion engine written in Lua.  It requires a snippet
-- engine (using LuaSnip) and completion sources (see below).

local cursor_has_words_before_it = require('grs.lib.text').cursor_has_words_before_it
local mergeTables = require('grs.lib.functional').mergeTables

return {

   {
      'hrsh7th/nvim-cmp',
      version = nil,
      dependencies = {
         -- Snippet engine
         {
            'L3MON4D3/LuaSnip',
            dependencies = {
               'rafamadriz/friendly-snippets', -- wide coverage various languages
               'kmarius/jsregexp', -- ECMAScript regular expressions snippet sources
            },
            build = 'make install_jsregexp',
         },
         -- completion sources
         'hrsh7th/cmp-buffer',
         'hrsh7th/cmp-cmdline',
         'hrsh7th/cmp-nvim-lsp',
         'hrsh7th/cmp-path',
         'lukas-reineke/cmp-rg',
         'saecki/crates.nvim',
         'saadparwaiz1/cmp_luasnip',
         -- modify formatting of ui
         'onsails/lspkind.nvim',
         -- modify sorting behavior
         'lukas-reineke/cmp-under-comparator',
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
                  nvim_lsp = '[lsp]',
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
            select = false,
            behavior = cmp.ConfirmBehavior.Replace,
         }

         local mapping = {
            ['<cr>'] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.confirm(confirm_opts)
                  cmp.close()
               else
                  fallback()
               end
            end, { 'i', 'c' }),
            ['<c-q>'] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.close()
               else
                  fallback()
               end
            end, { 'i', 'c' }),
            ['<c-a>'] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.abort()
               else
                  fallback()
               end
            end, { 'i', 'c' }),
            ['<s-tab>'] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.select_prev_item(select_opts)
               else
                  fallback()
               end
            end, { 'i', 'c' }),
            ['<c-n>'] = cmp.mapping {
               i = function(fallback)
                      if cmp.visible() then
                         cmp.select_next_item(select_opts)
                      elseif cursor_has_words_before_it() then
                         cmp.complete(confirm_opts)
                      else
                         fallback()
                      end
                   end,
               c = function(fallback)
                      if cmp.visible() then
                         cmp.select_next_item(select_opts)
                      else
                         fallback()
                      end
                   end,
            },
            ['<c-p>'] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.select_prev_item(select_opts)
               else
                  fallback()
               end
            end, { 'i', 'c' }),
         }

         local mapping_insert_mode = mergeTables {
            mapping, {
               ['<c-d>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                     cmp.scroll_docs(-4)
                  else
                     fallback()
                  end
               end),
               ['<c-f>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                     cmp.scroll_docs(4)
                  else
                     fallback()
                  end
               end),
               ['<c-s>'] = cmp.mapping.complete {
                  config = {
                     sources = {
                        {
                           name = 'luasnip',
                           option = { show_autosnippets = true },
                        },
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
               ['<tab>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                     return cmp.complete_common_string()
                  elseif cursor_has_words_before_it() then
                     cmp.complete(confirm_opts)
                  else
                     fallback()
                  end
               end),
            }
         }

         local mapping_cmdline_mode = mergeTables {
            mapping, {
               ['<tab>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                     local completed = cmp.complete_common_string()
                     if completed then
                        return completed
                     else
                        cmp.close()
                     end
                  else
                     fallback()
                  end
               end, { 'c' }),
            },
         }

         local sources_insert_mode = {
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'crates' },
            {
               name = 'buffer',
               option = {
                  get_bufnrs = function()  -- look in all buffers
                     return vim.api.nvim_list_bufs()
                  end,
               },
            },
            {
               name = 'rg',
               option = { additional_arguments = '--smart-case --hidden' },
               keyword_length = 3,
               max_item_count = 12,
            },
            {
               name = 'path',
               option = {
                  label_trailing_slash = false,
                  trailing_slash = false,
               },
            },
         }

         local sources_cmdline_mode = {{ name = 'cmdline' }}

         local sources_current_buffer_only = {
            {
               name = 'buffer',
               option = {
                  get_bufnrs = function()
                     return vim.api.nvim_get_current_buf()
                  end,
               },
            },
         }

         cmp.setup {
            sorting = sorting,
            formatting = formatting,
            snippet = snippet,
            window = window,
            mapping = mapping_insert_mode,
            sources = sources_insert_mode,
         }

         cmp.setup.cmdline(':', {
            mapping = mapping_cmdline_mode,
            sources = sources_cmdline_mode,
         })

         cmp.setup.cmdline({ '/', '?' }, {
            mapping = mapping_cmdline_mode,
            sources = sources_current_buffer_only,
         })
      end,
   },

}
