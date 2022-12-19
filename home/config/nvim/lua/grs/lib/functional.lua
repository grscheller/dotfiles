--[[ Functional Programming for Lua ]]

local M = {}

-- Flatten an array of arrays - no error checks (should JIT compile well)
M.iFlatten = function(ArrayOfArrays)
   local ConcatenatedList = {}
   for _, v in ipairs(ArrayOfArrays) do
      for _, w in ipairs(v) do
         table.insert(ConcatenatedList, w)
      end
   end
   return ConcatenatedList
end

-- get keys filtered by predicate
M.getFilteredKeys = function(t, p)
   local filteredKeys = {}
   for k, v in pairs(t) do
      if p(k, v) then
         table.insert(filteredKeys, k)
      end
   end
   return filteredKeys
end

return M
