--[[ External tooling for formatting, linting, and LSP servers ]]

return {
   -- Ensure all LSP servers are installed
   require 'plugins.tool_install.mason_lspconfig',
   require 'plugins.tool_install.mason_tool_installer',
}
