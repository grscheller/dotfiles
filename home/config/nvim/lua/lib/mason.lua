--[[ Category-scoped Mason maintenance.

     Mason and its ecosystem plugins can remove packages that are absent from
     an `ensure_installed` list (`:MasonToolsClean`), but none of them can
     remove *every package of a given kind*. These helpers do exactly that by
     reading each installed package's own `spec.categories` field, so they work
     regardless of which list, plugin, or alias a package was installed under.

]]

local M = {}

local copy = require('lib.functional').copy

---Category strings exactly as Mason records them in `pkg.spec.categories`.
---Source of truth: mason-core/package/init.lua -> Package.Cat
---@enum mason.Category
local Category = {
   LSP = 'LSP',
   DAP = 'DAP',
   Linter = 'Linter',
   Formatter = 'Formatter',
}

---@param remove_categories   mason.Category[]  Categories to flag for removal.
---@param excluded_categories mason.Category[]  Skip a package if it also belongs to one of these.
local function rm_pkgs(remove_categories, excluded_categories)
   local ok, registry = pcall(require, 'mason-registry')
   if not ok then
      vim.notify('mason-registry is not available', vim.log.levels.ERROR)
      return
   end

   local remove = {
      LSP = false,
      DAP = false,
      Linter = false,
      Formatter = false,
   }
   local excluded = copy(remove)

   for _, c in ipairs(remove_categories) do
      remove[c] = true
   end

   for _, c in ipairs(excluded_categories) do
      excluded[c] = true
   end

   local removed, next_row = {}, 1
   for _, pkg in ipairs(registry.get_installed_packages()) do
      local categories = pkg.spec.categories or {}
      local remove_pkg = false
      for _, c in ipairs(categories) do
         if remove[c] then
            remove_pkg = true
            for _, e in ipairs(categories) do
               if excluded[e] then
                  remove_pkg = false
                  break
               end
            end
            if remove_pkg then
               if pcall(function() pkg:uninstall() end) then
                  removed[next_row], next_row = pkg.name, next_row + 1
               end
            end
         end
      end
   end

   if next_row > 1 then
      table.sort(removed)
      vim.notify(
         ('Mason: removing %d package(s) [%s]: %s'):format(
            #removed,
            table.concat(remove_categories, ', '),
            table.concat(removed, ', ')
         ),
         vim.log.levels.INFO
      )
   else
      vim.notify(
         ('Mason: nothing installed in category [%s]'):format(
            table.concat(remove_categories, ', ')
         ),
         vim.log.levels.INFO
      )
   end
end

---Remove all LSP servers.
function M.remove_lsp()
   rm_pkgs({ Category.LSP }, {})
end

---Remove all DAP adapters.
function M.remove_dap()
   rm_pkgs({ Category.DAP }, {})
end

---Remove Linters and Formatters which are not also LSP servers.
function M.remove_linters_and_formatters()
   rm_pkgs({ Category.Linter, Category.Formatter }, { Category.LSP })
end

---Remove everything
function M.remove_everything()
   rm_pkgs({ Category.LSP, Category.DAP, Category.Linter, Category.Formatter }, {})
end

return M
