--[[ LSP Configuration - Python language server ]]

local venv = vim.env.VIRTUAL_ENV
local jedi_environment = venv and (venv .. '/bin/python') or nil

-- Mirror $PYTHONPATH into jedi's static sys.path to allow `gd`
-- to find the correct source code. This mechanism depends on
-- NOT having the code you are working on already installed
-- into the venv.
--
-- Alternately, install the code into the venv either by
--
--     $ pip install -e .
-- or
--     $ pip install -e /path/to/source
--
-- The -e (--editable) option is necessary otherwise pip copies
-- the current state of the code into the venv's site-packages.
--
local extra_paths = {}
if vim.env.PYTHONPATH then
   for p in vim.gsplit(vim.env.PYTHONPATH, ':', { trimempty = true }) do
      table.insert(extra_paths, p)
   end
end

return {
   cmd = { 'pylsp' },
   filetypes = { 'python' },
   root_markers = { 'pyproject.toml', '.git' },
   settings = {
      pylsp = {
         plugins = {
            jedi = {
               environment = jedi_environment,
               extra_paths = extra_paths,
            },
            pylint = { enabled = false },
            pyflakes = { enabled = false },
            pycodestyle = { enabled = false },
            mccabe = { enabled = false },
            ruff = { enabled = false },
         },
      },
   },
}
