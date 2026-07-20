--[[ Visual editing: plugins

     - Completion engine
     - Matching pairs
     - Indentation indication
     - Navigation
     - Colorize names.
]]

---@type LazySpec
return {
   -- Completion engine.
   ---@type LazyPluginSpec
   {
      [1] = 'saghen/blink.cmp',
      dependencies = {
         'saghen/blink.lib',  -- will be needed for v2.0.0
         'niuiic/blink-cmp-rg.nvim',
         'onsails/lspkind.nvim',
         'nvim-tree/nvim-web-devicons',
         'rafamadriz/friendly-snippets',
      },
      version = '1.*',
      event = { 'BufReadPre', 'BufNewFile', 'BufWritePre' },
      opts = {
         keymap = { preset = 'enter' },
         appearance = { nerd_font_variant = 'mono' },
         completion = {
            documentation = { auto_show = false },
            menu = {
               draw = {
                  components = {
                     kind_icon = {
                        text = function(ctx)
                           local icon = ctx.kind_icon
                           if
                              vim.tbl_contains(
                                 { 'Path' },
                                 ctx.source_name
                              )
                           then
                              local dev_icon, _ =
                                 require('nvim-web-devicons').get_icon(
                                    ctx.label
                                 )
                              if dev_icon then
                                 icon = dev_icon
                              end
                           else
                              icon = require('lspkind').symbol_map[ctx.kind]
                                 or ''
                           end
                           return icon .. ctx.icon_gap
                        end,
                        highlight = function(ctx)
                           local hl = ctx.kind_hl
                           if
                              vim.tbl_contains(
                                 { 'Path' },
                                 ctx.source_name
                              )
                           then
                              local dev_icon, dev_hl =
                                 require('nvim-web-devicons').get_icon(
                                    ctx.label
                                 )
                              if dev_icon then
                                 hl = dev_hl
                              end
                           end
                           return hl
                        end,
                     },
                  },
               },
            },
         },
         sources = {
            default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'ripgrep' },
            providers = {
               lazydev = {
                  name = 'LazyDev',
                  module = 'lazydev.integrations.blink',
                  score_offset = 100, -- rank above the LSP source
               },
               buffer = {
                  opts = {
                     get_bufnrs = function()
                        return vim.tbl_filter(function(bufnr)
                           return vim.bo[bufnr].buftype == ''
                        end, vim.api.nvim_list_bufs())
                     end,
                  },
               },
               ripgrep = {
                  module = 'blink-cmp-rg',
                  name = 'Ripgrep',
                  opts = {
                     prefix_min_len = 3,
                     get_command = function(_, prefix)
                        return {
                           'rg',
                           '--no-config',
                           '--json',
                           '--word-regexp',
                           '--',
                           prefix .. '[\\w_-]+',
                           vim.fs.root(0, '.git') or vim.fn.getcwd(),
                        }
                     end,
                     get_prefix = function(context)
                        return context.line
                           :sub(1, context.cursor[2])
                           :match '[%w_-]+$' or ''
                     end,
                  },
               },
            },
         },
      },
   },

   -- Matching pairs manipulation.
   ---@type LazyPluginSpec
   {
      'saghen/blink.pairs',
      dependencies = { 'saghen/blink.lib' },
      version = '*',
      event = { 'BufReadPre', 'BufNewFile', 'BufWritePre' },
      build = function()
         require('blink.pairs').download():pwait(60000)
      end,
      opts = {
         mappings = {
            enabled = true,
            cmdline = true,
         },
      },
   },

   -- Show line indentations when editing.
   ---@type LazyPluginSpec
   {
      [1] = 'lukas-reineke/indent-blankline.nvim',
      event = 'InsertEnter',
      main = 'ibl',
      opts = {
         indent = { char = '│' },
      },
   },

   -- Quickly jump around window.
   ---@type LazyPluginSpec
   {
      url = 'https://codeberg.org/andyg/leap.nvim',
      event = { 'BufReadPre', 'BufNewFile', 'BufWritePre' },
      config = function()
         local km = vim.keymap.set
         km({ 'n', 'x', 'o' }, 's', '<Plug>(leap)', { desc = 'leap' })
         km({ 'x', 'o' }, 'x', '<Plug>(leap-next-to)', { desc = 'leap till' })
         km('n', 'S', '<Plug>(leap-from-window)', { desc = 'leap from window' })
         km({ 'n', 'x', 'o' }, 'gx', '<Plug>(leap-anywhere)', { desc = 'leap anywhere' })
         km({ 'n', 'x', 'o' }, '<cr>', function()
               require('leap').leap {
                  ['repeat'] = true,
                  opts = require('leap.user').with_traversal_keys('<cr>', '<bs>'),
               }
            end
         )
         km({ 'n', 'x', 'o' }, '<bs>', function()
               require('leap').leap {
                  ['repeat'] = true,
                  opts = require('leap.user').with_traversal_keys('<bs>', '<cr>'),
                  backward = true,
               }
            end
         )
      end,
   },

   -- Colorize color names, hexcodes, and other color formats.
   ---@type LazyPluginSpec
   {
      [1] = 'norcalli/nvim-colorizer.lua',
      keys = {
         {
            [1] = '<leader>C',
            [2] = '<cmd>ColorizerToggle<cr>',
            desc = 'toggle colorizer',
         },
      },
      opts = {
         [1] = '*',
         RRGGBBAA = true,
         rgb_fn = true,
         hsb_fn = true,
         css = { names = false },
         html = { names = false },
         mode = 'background',
      },
   },
}
