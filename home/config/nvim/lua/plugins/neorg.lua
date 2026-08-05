--[[ Neorg note taking

     - TODO: description
     - TODO: make lazy
]]

---@type LazyPluginSpec
return {
   [1] = 'nvim-neorg/neorg',
   -- No `build = ':Neorg sync-parsers'` — tree-sitter-norg/tree-sitter-norg-meta
   -- are already installed as rocks via the rockspec path, so this build step
   -- is both unnecessary and the thing implicated in a treesitter-rewrite bug.
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
      },
   },
}
