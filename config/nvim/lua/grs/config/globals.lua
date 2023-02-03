--[[ Globals - loaded via plugins/config.lua ]]

-- loaded very early - most plugins only read these on startup

vim.g.python3_host_prog = string.format('%s/.local/share/pyenv/shims/python', os.getenv 'HOME')
