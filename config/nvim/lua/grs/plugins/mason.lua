--[[ Mason Setup ]]

local confMason = require 'grs.config.mason'
local m = confMason.MasonEnum
local LspTbl = confMason.LspTbl
local DapTbl = confMason.DapTbl
local BuiltinTbls = confMason.BuiltinTbls

local utilMason = require 'grs.plugins.util.mason'


local install = function(_, v)
   return v ~= m.ignore
end

local masonPackages = require('grs.util').iFlatten {
   utilMason.lspconfig2mason(LspTbl, install),
   utilMason.dap2mason(DapTbl, install),
   utilMason.nullLs2mason(BuiltinTbls.code_actions, install),
   utilMason.nullLs2mason(BuiltinTbls.completions, install),
   utilMason.nullLs2mason(BuiltinTbls.diagnostics, install),
   utilMason.nullLs2mason(BuiltinTbls.formatting, install),
   utilMason.nullLs2mason(BuiltinTbls.hover, install),
}

return {

   --  Mason package manager infrastructure used to install/upgrade
   --  3rd party tools like LSP & DAP servers and Null-ls builtins.
   {
       'williamboman/mason.nvim',
       cmd = "Mason",
       keys = { { "<leader>M", "<cmd>Mason<cr>", desc = "Mason" } },
       opts = { ensure_installed = masonPackages },
   },

}
