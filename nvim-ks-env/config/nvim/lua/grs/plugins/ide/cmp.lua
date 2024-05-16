--[[ Completions & Snippets ]]
--
-- nvim-cmp is a completion engine written in Lua. It requires a snippet engine
-- (using LuaSnip) and completion sources.

local words_before = require('grs.lib.text').cursor_has_words_before_it
local mergeTables = require('grs.lib.functional').mergeTables

local old_one = {

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
         'hrsh7th/cmp-nvim-lsp-document-symbol',
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

         --[[ Modify completion behaiviors $ appearance ]]

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
                  nvim_lsp_document_symbol = '[dsym]',
                  nvim_lua = '[lua]',
                  path = '[path]',
                  rg = '[rg]',
                  luasnip = '[snip]',
               },
            },
         }

         local window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
         }

         --[[ Set up snippet engine (required!) ]]

         local snippet = {
            expand = function(args)
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
            ['<space>'] = cmp.mapping(function(fallback)
               if cmp.visible() then
                  cmp.confirm(optConfirm)
                  fallback()
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

         --[[ Set up sources ]]

         local sources_insert_mode = {
            { name = 'nvim_lsp' },
            { name = 'nvim_lsp_document_symbol' },
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

         cmp.setup.cmdline(':', {
            sorting = sorting,
            formatting = formatting,
            mapping = mapping,
            sources = sources_cmdline_mode,
         })

         cmp.setup.cmdline('/', {
            sorting = sorting,
            formatting = formatting,
            mapping = mapping,
            sources = sources_search_mode,
         })

         cmp.setup.cmdline('?', {
            sorting = sorting,
            formatting = formatting,
            mapping = mapping,
            sources = sources_search_mode,
         })

      end,
   },

}

return {

   { -- Autocompletion
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
         -- Snippet Engine & its associated nvim-cmp source
         {
            'L3MON4D3/LuaSnip',
            build = (function()
               -- Build Step is needed for regex support in snippets.
               -- This step is not supported in many windows environments.
               -- Remove the below condition to re-enable on windows.
               if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                  return
               end
               return 'make install_jsregexp'
            end)(),
            dependencies = {
               -- `friendly-snippets` contains a variety of premade snippets.
               --    See the README about individual language/framework/plugin snippets:
               --    https://github.com/rafamadriz/friendly-snippets
               -- {
               --   'rafamadriz/friendly-snippets',
               --   config = function()
               --     require('luasnip.loaders.from_vscode').lazy_load()
               --   end,
               -- },
            },
         },
         'saadparwaiz1/cmp_luasnip',

         -- Adds other completion capabilities.
         --  nvim-cmp does not ship with all sources by default. They are split
         --  into multiple repos for maintenance purposes.
         'hrsh7th/cmp-nvim-lsp',
         'hrsh7th/cmp-path',
      },
      config = function()
         -- See `:help cmp`
         local cmp = require 'cmp'
         local luasnip = require 'luasnip'
         luasnip.config.setup {}

         cmp.setup {
            snippet = {
               expand = function(args)
                  luasnip.lsp_expand(args.body)
               end,
            },
            completion = { completeopt = 'menu,menuone,noinsert' },

            -- For an understanding of why these mappings were
            -- chosen, you will need to read `:help ins-completion`
            --
            -- No, but seriously. Please read `:help ins-completion`, it is really good!
            mapping = cmp.mapping.preset.insert {
               -- Select the [n]ext item
               ['<C-n>'] = cmp.mapping.select_next_item(),
               -- Select the [p]revious item
               ['<C-p>'] = cmp.mapping.select_prev_item(),

               -- Scroll the documentation window [b]ack / [f]orward
               ['<C-b>'] = cmp.mapping.scroll_docs(-4),
               ['<C-f>'] = cmp.mapping.scroll_docs(4),

               -- Accept ([y]es) the completion.
               --  This will auto-import if your LSP supports it.
               --  This will expand snippets if the LSP sent a snippet.
               ['<C-y>'] = cmp.mapping.confirm { select = true },

               -- If you prefer more traditional completion keymaps,
               -- you can uncomment the following lines
               --['<CR>'] = cmp.mapping.confirm { select = true },
               --['<Tab>'] = cmp.mapping.select_next_item(),
               --['<S-Tab>'] = cmp.mapping.select_prev_item(),

               -- Manually trigger a completion from nvim-cmp.
               --  Generally you don't need this, because nvim-cmp will display
               --  completions whenever it has completion options available.
               ['<C-Space>'] = cmp.mapping.complete {},

               -- Think of <c-l> as moving to the right of your snippet expansion.
               --  So if you have a snippet that's like:
               --  function $name($args)
               --    $body
               --  end
               --
               -- <c-l> will move you to the right of each of the expansion locations.
               -- <c-h> is similar, except moving you backwards.
               ['<C-l>'] = cmp.mapping(function()
                  if luasnip.expand_or_locally_jumpable() then
                     luasnip.expand_or_jump()
                  end
               end, { 'i', 's' }),
               ['<C-h>'] = cmp.mapping(function()
                  if luasnip.locally_jumpable(-1) then
                     luasnip.jump(-1)
                  end
               end, { 'i', 's' }),

               -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
               --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
            },
            sources = {
               { name = 'nvim_lsp' },
               { name = 'luasnip' },
               { name = 'path' },
            },
         }
      end,
   },
}
