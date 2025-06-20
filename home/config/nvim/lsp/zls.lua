--[[ LSP Configuration - LSP for Python linting/formatting ]]

return {
   cmd = { 'zls' },
   filetypes = { 'zig', 'zir' },
   root_markers = { 'zls.json', 'build.zig', '.git' },
   -- workspace_required = false,
}
