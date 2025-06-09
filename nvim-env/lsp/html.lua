--[[ LSP Configuration HTML - vscode-html-language-server ]]

return {
   cmd = { 'vscode-html-language-server', '--stdio' },
   filetypes = { 'html', 'templ' },
   root_markers = { 'package.json', '.git' },
   settings = {},
}
