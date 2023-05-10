--[[ Functional Programming for Lua ]]
--
-- Functions designed to be applied against "simple" tables:
--   <list> means a Lua conseutive integer indexed table with no holes
--   <maps> means a table of "key" -> value pairs
--
-- So that these JIT compile and run blazingly fast, there is no type or error
-- checking.  It is the programmer's reponsibility to pass the correct data
-- structures to these functions.
--
-- I would not use with mixed tables. Function-like objects, like tables with
-- __call metamethods, should be OK as function arguments ... I think?
--
-- The use of the word "functional" is meant to mean that the interface is
-- functional, not necessarily the implementation.

-- Recursively copy a table, or what a table with a metatable table presents
-- itself as.  Does not recreate a table with metatable.
local function _deepCopy(original)
   local copy = {}
   for k, v in pairs(original) do
      if type(v) == "table" then
         v = _deepCopy(v)
      end
      copy[k] = v
   end
   return copy
end

local M = {}

-- Deep copy any (simple) Lua table (no meta-tables) 
M.deepCopy = _deepCopy

-- Flatten an <list> of <lists> (will repeat values)
M.iFlatten = function(aoa)
   local flattened = {}
   for _, v in ipairs(aoa) do
      for _, w in ipairs(v) do
         table.insert(flattened, w)
      end
   end
   return flattened
end

-- Apply a function to each element of an <list>, can be Curried.
M.iMap = function(f, a)
   local function map(vs)
      local ma = {}
      for i, v in ipairs(vs) do
         ma[i] = f(v)
      end
      return ma
   end

   if a then
      return map(a)
   else
      return map
   end
end

-- Merge an <list> of <maps>
-- Right-most wins when given same key.
M.mergeTables = function(array_of_tables)
   local mergedTable = {}
   for _, tbl in ipairs(array_of_tables) do
      for k, v in pairs(tbl) do
         mergedTable[k] = v
      end
   end
   return mergedTable
end

-- get <table> keys, return <list>
M.getKeys = function(t)
   local filteredKeys = {}
   for k, _ in pairs(t) do
      table.insert(filteredKeys, k)
   end
   return filteredKeys
end

-- get <table> values, return <list>
M.getValues = function(t)
   local filteredValues = {}
   for _, v in pairs(t) do
      table.insert(filteredValues, v)
   end
   return filteredValues
end

-- get <table> keys filtered by predicate, return <list>
M.getFilteredKeys = function(t, p)
   local filteredKeys = {}
   for k, v in pairs(t) do
      if p(k, v) then
         table.insert(filteredKeys, k)
      end
   end
   return filteredKeys
end

-- get <table> values filtered by predicate, return <list>
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
