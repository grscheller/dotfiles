--[[ Neorg note taking

     - TODO: description
]]

---@type LazyPluginSpec
return {
   [1] = 'nvim-neorg/neorg',
   event = 'VeryLazy',
   opts = {
      load = {
         ['core.defaults'] = {},
         ['core.dirman'] = {
            config = {
               workspaces = {
                  notes = '~/neorg',  -- adjust path as you like
               },
               default_workspace = 'notes',
            },
         },
         ['core.integrations.treesitter'] = {
            config = {
               configure_parsers = true,
               -- Cosmetic false-positive only: this checks package.cpath in a way
               -- that can lag lazy.nvim's rocks-path setup at eager-load time.
               -- Registration itself (confirmed) works correctly with event='VeryLazy'.
               -- See nvim-neorg/neorg#1814.
               warn_missing_parsers = false,
            },
         },
      },
   },
}
