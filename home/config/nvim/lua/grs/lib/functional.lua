--[[ Functional Programming for Lua

     Functions designed to be applied against "simple" tables:
       <array> means a Lua consecutive integer indexed table with no holes
       <maps> means a table of "key" -> value pairs

     So that these JIT compile and run very fast, there is no type or error
     checking.  It is the programmer's responsibility to pass the correct data
     structures to these functions.

     I would not use with mixed tables. Function-like objects, like tables with
     __call metamethods, should be OK as function arguments ... I think?

     The use of the word "functional" is meant to mean that the interface is
     functional, not necessarily the implementation.

     Recursively copy a table, or what a table with a metatable table presents
     itself as.  Does not recreate a table with metatable. ]]

local M = {}

---Recursively copy a table, make no attempt replicating metatables
---@param original table
---@return table
M.deepCopy = function(original)
   local copy = {}
   for k, v in pairs(original) do
      if type(v) == 'table' then
         v = M.deepCopy(v)
      end
      copy[k] = v
   end
   return copy
end

-- Flatten an <array> of <arrays> (will repeat values)
M.flattenArray = function(aoa)
   local flattened = {}
   for _, v in ipairs(aoa) do
      for _, w in ipairs(v) do
         table.insert(flattened, w)
      end
   end
   return flattened
end

-- Apply a function to each element of an <array>, can be Curried.
M.mapArray = function(f, a)
   local function map(vs)
      local ma = {}
      local j = 0
      for _, v in ipairs(vs) do
         local value = f(v)
         if type(value) ~= nil then
            j = j + 1
            ma[j] = f(v)
         end
      end
      return ma, j
   end

   if a then
      return map(a)
   else
      return map
   end
end

---Merge a <array> of <maps> - later tables override earlier ones
---@param array_of_maps table
---@return table
M.mergeTables = function(array_of_maps)
   local mergedTable = {}
   for _, tbl in ipairs(array_of_maps) do
      for k, v in pairs(tbl) do
         mergedTable[k] = v
      end
   end
   return mergedTable
end

-- get <map> keys, return <array>
M.getKeys = function(t)
   local filteredKeys = {}
   for k, _ in pairs(t) do
      table.insert(filteredKeys, k)
   end
   return filteredKeys
end

-- get <map> values, return <array>
M.getValues = function(t)
   local filteredValues = {}
   for _, v in pairs(t) do
      table.insert(filteredValues, v)
   end
   return filteredValues
end

-- get <table> keys filtered by predicate, return <array>
M.getFilteredKeys = function(t, p)
   local filteredKeys = {}
   for k, v in pairs(t) do
      if p(k, v) then
         table.insert(filteredKeys, k)
      end
   end
   return filteredKeys
end

-- get <table> values filtered by predicate, return <array>
M.getFilteredValues = function(t, p)
   local filteredValues = {}
   for k, v in pairs(t) do
      if p(k, v) then
         table.insert(filteredValues, v)
      end
   end
   return filteredValues
end

return M
