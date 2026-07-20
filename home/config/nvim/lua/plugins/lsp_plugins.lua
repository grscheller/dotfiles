--[[ Plugin managed LSP clients

     - Roblox development: lopi-py/luau-lsp.nvim 
]]

---@type LazySpec
return {
   -- Roblox development
   ---@type LazyPluginSpec
   {
      [1] = 'lopi-py/luau-lsp.nvim',
      ft = { 'luau' },
      opts = {
         platform = {
            type = 'roblox',
         },
         types = {
            roblox_security_level = 'PluginSecurity',
         },
         sourcemap = {
            enabled = true,
            autogenerate = true,
            rojo_project_file = 'default.project.json',
            sourcemap_file = 'sourcemap.json',
         },
      },
   },
}
