--[[ Plugin to integrate commandline formatters ]]

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
   keymap = { preset = 'default' },
   -- Adjusts spacing to ensure icons are aligned - 'mono' or 'normal'
   appearance = { nerd_font_variant = 'mono' },
   -- (Default) Only show the documentation popup when manually triggered.
   completion = {
      documentation = { auto_show = false },
   },
   -- Default list of enabled providers, use opts_extend to extend it later.
   sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
   },
   -- See the fuzzy documentation for more information
   fuzzy = { implementation = 'prefer_rust_with_warning' },
}

return {
   {
      'saghen/blink.cmp',
      event = 'InsertEnter',
      dependencies = { 'rafamadriz/friendly-snippets' },
      version = '1.*', -- use a release tag to download pre-built binaries
      opts = blink_opts,
      opts_extend = { 'sources.default' },
   },
}
