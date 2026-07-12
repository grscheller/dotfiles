--[[ Visual editing: plugins

     - Completion engine
     - Matching pairs
     - Indentation indication
     - Navigation
     - Colorize names.           ]]

return {
   -- Completion engine.
   {
      [1] = 'saghen/blink.cmp',
      event = { 'BufReadPre', 'BufNewFile', 'BufWritePre' },
      build = function()
         require('blink.cmp').build():pwait()
      end,
      dependencies = {
         'saghen/blink.lib',
         'niuiic/blink-cmp-rg.nvim',
         'onsails/lspkind.nvim',
         'nvim-tree/nvim-web-devicons',
         'rafamadriz/friendly-snippets',
      },
      version = '*',
      opts = {
         -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
         -- 'super-tab' for mappings similar to vscode (tab to accept)
         -- 'enter' for enter to accept
         -- 'none' for no mappings
         --
         -- All presets have the following mappings:
         -- C-space: Open menu or open docs if already open
         -- C-n/C-p or Up/Down: Select next/previous item
         -- C-e: Hide menu
         -- C-k: Toggle signature help (if signature.enabled = true)
         --
         -- See :h blink-cmp-config-keymap for defining your own keymap
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
            default = { 'lsp', 'path', 'snippets', 'buffer', 'ripgrep' },
            providers = {
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
         fuzzy = { implementation = 'prefer_rust_with_warning' },
      },
   },

   -- Matching pairs manipulation.
   {
      'saghen/blink.pairs',
      dependencies = {
         'saghen/blink.lib',
         'rafamadriz/friendly-snippets',
      },
      version = '*',
      event = { 'BufReadPre', 'BufNewFile', 'BufWritePre' },
      build = function()
         require('blink.pairs').build():pwait()
      end,
      opts = {
         mappings = {
            enabled = true,
            cmdline = true, -- might not play nice with noice
         },
      },
   },

   -- Show line indentations when editing.
   {
      [1] = 'lukas-reineke/indent-blankline.nvim',
      event = 'InsertEnter',
      main = 'ibl',
      opts = {
         indent = { char = '│' },
      },
   },

   -- Quickly jump around window.
   {
      url = 'https://codeberg.org/andyg/leap.nvim',
      event = { 'BufReadPre', 'BufNewFile', 'BufWritePre' },
   },

   -- Colorize color names, hexcodes, and other color formats.
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
