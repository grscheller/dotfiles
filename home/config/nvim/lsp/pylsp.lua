--[[ LSP Configuration - Python language server ]]

return {
   cmd = { 'pylsp' },
   filetypes = { 'python' },
   root_markers = { 'pyproject.toml', '.git' },
   settings = {
      pylsp = {
         plugins = {
            pylint = {enabled = false },
            pyflakes = { enabled = false },
            pycodestyle = { enabled = false },
            mccabe = { enabled = false },
            ruff = { enabled = false },
         },
      },
   },
}
