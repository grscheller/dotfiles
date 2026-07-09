--[[ Category-scoped Mason maintenance.

     Mason and its ecosystem plugins can remove packages that are absent from
     an `ensure_installed` list (`:MasonToolsClean`), but none of them can
     remove *every package of a given kind*. These helpers do exactly that by
     reading each installed package's own `spec.categories` field, so they work
     regardless of which list, plugin, or alias a package was installed under.

]]

local M = {}

local copy = require('lib.functional').copy

-- Category strings exactly as Mason records them in `pkg.spec.categories`.
-- Source of truth: mason-core/package/init.lua -> Package.Cat
-- (Compiler | Runtime | DAP | LSP | Linter | Formatter)
M.LSP = 'LSP'
M.DAP = 'DAP'
M.LINTER = 'Linter'
M.FORMATTER = 'Formatter'
M.COMPLIER = 'Compiler'
M.RUNTIME = 'Runtime'

---Uninstall every installed package belonging to of the above `categories`.
---Mirrors the invocation pattern of `:MasonUninstallAll`: `pkg:uninstall()`
---is asynchronous and fire-and-forget, so the notification reports which
---removals were *initiated*, not awaited.


---Uninstall any mason packages belonging to one or more Mason categories.
---@param remove_categories string[]  Categories to flag package removal.
---@param exclude_categories string[]  But not if package also belongs to one of these categories.
function M.clean_categories(remove_categories, exclude_categories)
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
      Compiler = false,
      Runtime = false,
   }
   local exclude = copy(remove)

   for _, c in ipairs(remove_categories) do
      remove[c] = true
   end

   for _, c in ipairs(exclude_categories) do
      exclude[c] = true
   end

   local removed = {}
   for _, pkg in ipairs(registry.get_installed_packages()) do
      local categories = pkg.spec.categories or {}
      for _, e in ipairs(categories) do
         if not exclude[e] then
            for _, c in ipairs(categories) do
               if remove[c] then
                  if pcall(function() pkg:uninstall() end) then
                     table.insert(removed, pkg.name)
                  end
                  break
               end
            end
         end
      end
   end

   if #removed > 0 then
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
   M.clean_categories({ M.LSP }, {})
end

---Remove all DAP adapters.
function M.remove_dap()
   M.clean_categories({ M.DAP }, {})
end

---Remove Linters and Formatters which are not also LSP servers.
function M.remove_linters_and_formatters()
   M.clean_categories({ M.LINTER, M.FORMATTER }, { M.LSP })
end

---Remove everything
function M.remove_everthing()
   M.clean_categories({ M.LSP, M.DAP, M.LINTER, M.FORMATTER }, {})
end
return M
