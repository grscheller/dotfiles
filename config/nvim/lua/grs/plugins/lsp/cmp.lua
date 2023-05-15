--[[ Completions & Snippets ]]
--
-- nvim-cmp is a completion engine written in Lua.  It requires a snippet
-- engine (using LuaSnip) and completion sources (see below).

local words_before = require('grs.lib.text').cursor_has_words_before_it
local mergeTables = require('grs.lib.functional').mergeTables

return {

   {
      'hrsh7th/nvim-cmp',
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
         'saadparwaiz1/cmp_luasnip',
         -- completion sources
         'hrsh7th/cmp-buffer',
         'hrsh7th/cmp-cmdline',
         'hrsh7th/cmp-nvim-lua',
         'hrsh7th/cmp-path',
         'lukas-reineke/cmp-rg',
         -- provide completion capabilities to LSP servers, completion source
         'hrsh7th/cmp-nvim-lsp',
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

         local optSelect = {
            behavior = cmp.SelectBehavior.Select,
         }
         local optConfirm = {
            select = false,
            behavior = cmp.ConfirmBehavior.Replace,
         }

         local mapping = {
            ['<cr>'] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.confirm(optConfirm)
                  if cmp.visible() then
                     cmp.close()
                  end
               else
                  fallback()
               end
            end, { 'i', 'c' }),
            ['<c-space>'] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.close()
               else
                  fallback()
               end
            end, { 'i', 'c' }),
            ['<tab>'] = cmp.mapping {
               i = function(fallback)
                      if cmp.visible() then
                         cmp.select_next_item(optSelect)
                      elseif words_before() then
                         cmp.complete(optConfirm)
                      else
                         fallback()
                      end
                   end,
               c = function()
                      if cmp.visible() then
                         cmp.select_next_item(optSelect)
                      else
                         cmp.complete(optConfirm)
                      end
                   end,
            },
            ['<s-tab>'] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.select_prev_item(optSelect)
               else
                  fallback()
               end
            end, { 'i', 'c' }),
            ['<m-tab>'] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  return cmp.complete_common_string()
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
               ['<m-right>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                     cmp.complete(optConfirm)
                  elseif luasnip.jumpable(1) then
                     luasnip.jump(1)
                  else
                     fallback()
                  end
               end),
               ['<m-left>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                     cmp.complete(optConfirm)
                  elseif luasnip.jumpable(-1) then
                     luasnip.jump(-1)
                  else
                     fallback()
                  end
               end),
            }
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

         cmp.setup {
            sorting = sorting,
            formatting = formatting,
            snippet = snippet,
            window = window,
            mapping = mapping_insert_mode,
            sources = sources_insert_mode,
         }

         cmp.setup.cmdline(':', {
            mapping = mapping,
            sources = sources_cmdline_mode,
         })

      end,
   },

}
