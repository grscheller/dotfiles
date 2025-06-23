--[[ LSP and completion support ]]

local blink_opts = {
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
   -- Adjusts spacing to ensure icons are aligned - 'mono' or 'normal'
   appearance = { nerd_font_variant = 'mono' },
   completion = {
      documentation = { auto_show = false },
      menu = {
         draw = {
            components = {
               kind_icon = {
                  text = function(ctx)
                     local icon = ctx.kind_icon
                     if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                        local dev_icon, _ = require('nvim-web-devicons').get_icon(ctx.label)
                        if dev_icon then
                           icon = dev_icon
                        end
                     else
                        icon = require('lspkind').symbolic(ctx.kind, {
                           mode = 'symbol',
                        })
                     end
                     return icon .. ctx.icon_gap
                  end,
                  highlight = function(ctx)
                     local hl = ctx.kind_hl
                     if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                        local dev_icon, dev_hl = require('nvim-web-devicons').get_icon(ctx.label)
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
                  return context.line:sub(1, context.cursor[2]):match '[%w_-]+$' or ''
               end,
            },
         },
      },
   },
   fuzzy = { implementation = 'prefer_rust_with_warning' },
}

return {
   {
      -- completion engine
      'saghen/blink.cmp',
      event = { 'InsertEnter', 'CmdlineEnter' },
      dependencies = {
         'rafamadriz/friendly-snippets',
         'niuiic/blink-cmp-rg.nvim',
         'onsails/lspkind.nvim',
      },
      version = '1.*', -- use a release tag to download pre-built binaries
      opts = blink_opts,
      opts_extend = { 'sources.default' },
   },

   {
      -- Give user feedback on LSP activity
      'j-hui/fidget.nvim',
      event = 'LspAttach',
      opts = {
         progress = {
            ignore_empty_message = true,
         },
      },
   },
}
