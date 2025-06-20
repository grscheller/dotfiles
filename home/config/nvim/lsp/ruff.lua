--[[ LSP Configuration - LSP for Python linting/formatting ]]

return {
   cmd = { 'ruff', 'server' },
   filetypes = { 'python' },
   root_markers = { 'pyproject.toml', '.git' },
   settings = {},
}
