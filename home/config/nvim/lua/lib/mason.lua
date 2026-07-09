--[[ Category-scoped Mason maintenance.

     Mason and its ecosystem plugins can remove packages that are absent from
     an `ensure_installed` list (`:MasonToolsClean`), but none of them can
     remove *every package of a given kind*. These helpers do exactly that by
     reading each installed package's own `spec.categories` field, so they work
     regardless of which list, plugin, or alias a package was installed under.

]]

local M = {}

-- Category strings exactly as Mason records them in `pkg.spec.categories`.
-- Source of truth: mason-core/package/init.lua -> Package.Cat
-- (Compiler | Runtime | DAP | LSP | Linter | Formatter)
M.LSP = 'LSP'
M.DAP = 'DAP'
M.LINTER = 'Linter'
M.FORMATTER = 'Formatter'

--- Uninstall every installed package belonging to any of `categories`.
--- Mirrors the invocation pattern of `:MasonUninstallAll`: `pkg:uninstall()`
--- is asynchronous and fire-and-forget, so the notification reports which
--- removals were *initiated*, not awaited.
--- @param categories string[]  one or more of the M.* constants above
function M.clean_categories(categories)
   local ok, registry = pcall(require, 'mason-registry')
   if not ok then
      vim.notify('mason-registry is not available', vim.log.levels.ERROR)
      return
   end

   local wanted = {}
   for _, c in ipairs(categories) do
      wanted[c] = true
   end

   local removed = {}
   for _, pkg in ipairs(registry.get_installed_packages()) do
      for _, c in ipairs(pkg.spec.categories or {}) do
         if wanted[c] then
            if pcall(function() pkg:uninstall() end) then
               table.insert(removed, pkg.name)
            end
            break
         end
      end
   end

   if #removed > 0 then
      table.sort(removed)
      vim.notify(
         ('Mason: removing %d package(s) [%s]: %s'):format(
            #removed,
            table.concat(categories, ', '),
            table.concat(removed, ', ')
         ),
         vim.log.levels.INFO
      )
   else
      vim.notify(
         ('Mason: nothing installed in category [%s]'):format(
            table.concat(categories, ', ')
         ),
         vim.log.levels.INFO
      )
   end
end

function M.clean_lsp()
   M.clean_categories { M.LSP }
end

function M.clean_dap()
   M.clean_categories { M.DAP }
end

function M.clean_linters_and_formatters()
   M.clean_categories { M.LINTER, M.FORMATTER }
end

return M
