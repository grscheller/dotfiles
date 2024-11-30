--[[ Completions & Snippets ]]
--
-- nvim-cmp is a completion engine written in Lua. It requires a snippet engine
-- (using LuaSnip) and completion sources.

local words_before = require('grs.lib.text').cursor_has_words_before_it
local mergeTables = require('grs.lib.functional').mergeTables

local config_nvim_cmp = function ()
   local cmp = require 'cmp'
   local lspkind = require 'lspkind'
   local cmp_under_comparator = require 'cmp-under-comparator'
   local luasnip = require 'luasnip'
   local autopairs = require 'nvim-autopairs'
   local autopairs_cmp = require 'nvim-autopairs.completion.cmp'

   require('luasnip.loaders.from_vscode').lazy_load()

   --[[ Modify completion behaviors & appearance ]]

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
            lazydev = '[ldev]',
            luasnip = '[snip]',
            nvim_lsp = '[lsp]',
            nvim_lsp_document_symbol = '[dsym]',
            nvim_lua = '[lua]',
            path = '[path]',
            rg = '[rg]',
         },
      },
   }

   local window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
   }

   --[[ Set up snippet engine (required!) ]]

   local snippet = {
      expand = function (args)
         luasnip.lsp_expand(args.body)
      end,
   }

   --[[ Set up keymappings ]]

   local optSelect = {
      behavior = cmp.SelectBehavior.Insert,
   }
   local optConfirm = {
      select = false,
      behavior = cmp.ConfirmBehavior.Replace,
   }

   local mapping = {
      ['<c-space>'] = cmp.mapping(
         function (fallback)
            if cmp.visible() then
               cmp.close()
            else
               fallback()
            end
         end,
         { 'i', 'c' }
      ),
      ['<tab>'] = cmp.mapping {
         i = function (fallback)
                if cmp.visible() then
                   cmp.select_next_item(optSelect)
                elseif words_before() then
                   cmp.complete(optConfirm)
                else
                   fallback()
                end
             end,
         c = function ()
                if cmp.visible() then
                   cmp.select_next_item(optSelect)
                else
                   cmp.complete(optConfirm)
                end
             end,
      },
      ['<s-tab>'] = cmp.mapping(
         function (fallback)
            if cmp.visible() then
               cmp.select_prev_item(optSelect)
            else
               fallback()
            end
         end,
         { 'i', 'c' }
      ),
      ['<m-tab>'] = cmp.mapping(
         function (fallback)
            if cmp.visible() then
               return cmp.complete_common_string()
            else
               fallback()
            end
         end,
         { 'i', 'c' }
      ),
   }

   local mapping_insert_mode = mergeTables {
      mapping, {
         ['<c-d>'] = cmp.mapping(
            function (fallback)
               if cmp.visible() then
                  cmp.scroll_docs(-4)
               else
                  fallback()
               end
            end
         ),
         ['<c-f>'] = cmp.mapping(
            function (fallback)
               if cmp.visible() then
                  cmp.scroll_docs(4)
               else
                  fallback()
               end
            end
         ),
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
         ['<m-right>'] = cmp.mapping(
            function (fallback)
               if cmp.visible() then
                  cmp.complete(optConfirm)
               elseif luasnip.jumpable(1) then
                  luasnip.jump(1)
               else
                  fallback()
               end
            end
         ),
         ['<m-left>'] = cmp.mapping(
            function (fallback)
               if cmp.visible() then
                  cmp.complete(optConfirm)
               elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
               else
                  fallback()
               end
            end
         ),
      }
   }

   --[[ Set up sources ]]

   local sources_insert_mode = {
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_document_symbol' },
      { name = 'nvim_lua' },
      { name = 'crates' },
      {
         name = 'buffer',
         option = {
            get_bufnrs = function ()
               return vim.api.nvim_list_bufs()  -- looks in all buffers
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
      {
         name = 'lazydev',
         group_index = 0,
      },
   }

   local sources_cmdline_mode = {
      { name = 'cmdline' }
   }

   local sources_search_mode = {
      { name = 'nvim_lsp_document_symbol' },
      { name = 'buffer' },
   }

   --[[ Now put everything together and set up nvim-cmp ]]

   cmp.setup {
      sorting = sorting,
      formatting = formatting,
      snippet = snippet,
      window = window,
      mapping = mapping_insert_mode,
      sources = sources_insert_mode,
   }

   cmp.setup.cmdline(
      ':', {
         sorting = sorting,
         formatting = formatting,
         mapping = mapping,
         sources = sources_cmdline_mode,
      }
   )

   cmp.setup.cmdline(
      '/', {
         sorting = sorting,
         formatting = formatting,
         mapping = mapping,
         sources = sources_search_mode,
      }
   )

   cmp.setup.cmdline(
      '?', {
         sorting = sorting,
         formatting = formatting,
         mapping = mapping,
         sources = sources_search_mode,
      }
   )

   autopairs.setup {}
   cmp.event:on('confirm_done', autopairs_cmp.on_confirm_done())

end

return {

   -- Snippet engine
   {
      "L3MON4D3/LuaSnip",
      dependencies = { 'rafamadriz/friendly-snippets' },
      version = 'v2.*',
      build = 'make install_jsregexp'
   },

   -- insert mode completions
   {
      'hrsh7th/nvim-cmp',
      event = { 'InsertEnter', 'CmdlineEnter' },
      dependencies = {
         -- snippet engine (required)
         'L3MON4D3/LuaSnip',
         -- modify formatting of ui
         'onsails/lspkind.nvim',
         -- modify sorting behavior
         'lukas-reineke/cmp-under-comparator',
         -- integrate with matching symbol plugin
         'windwp/nvim-autopairs',
         -- completion sources
         'hrsh7th/cmp-buffer',
         'hrsh7th/cmp-cmdline',
         'hrsh7th/cmp-nvim-lsp',
         'hrsh7th/cmp-nvim-lsp-document-symbol',
         'hrsh7th/cmp-nvim-lua',
         'hrsh7th/cmp-path',
         'lukas-reineke/cmp-rg',
         'saadparwaiz1/cmp_luasnip',
      },
      config = config_nvim_cmp,
   },

}

