--[[ LSP Configuration - Python language server ]]

return {
   cmd = { 'pylsp' },
   filetypes = { 'python' },
   root_markers = { 'pyproject.toml', '.git' },
   settings = {
      pylsp = {
         plugins = {
            -- type checker
            pylsp_mypy = {
               enabled = true,
            },
            -- linting and formatting
            ruff = { enabled = false },
            -- refactoring
            rope = { enable = true },
            pylsp_inlay_hints = { enable = true },
         },
      },
   },
}
