--[[ LSP Configuration Markdown - marksman ]]

return {
   cmd = { 'marksman', 'server' },
   filetypes = { 'markdown', 'md' },
   root_markers = { '.marksman.toml', '.git' },
}
