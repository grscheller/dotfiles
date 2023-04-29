--[[ Functional Programming for Lua ]]
--
-- <array> means a Lua table of values
-- <table> means a Lua associative array, i.e. a table of "key -> value" pairs
--
-- So that these JIT compile and run blazingly fast, there is no error checking.
-- It is the programmer's reponsibility to both pass the correct data structures
-- to these functions.
--
-- The use of the word "functional" is meant to mean that the interface is
-- functional, not necessarily the implementation.

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

-- Flatten an <array> of <arrays> - no error checks
M.iFlatten = function(ArrayOfArrays)
   local ConcatenatedList = {}
   for _, v in ipairs(ArrayOfArrays) do
      for _, w in ipairs(v) do
         table.insert(ConcatenatedList, w)
      end
   end
   return ConcatenatedList
end

-- Merge an <array> of <table>
-- Right-most wins when given same key.
M.mergeTables = function(array_of_tables)
   local mergedTables = {}
   for _, tbl in ipairs(array_of_tables) do
      for k, v in pairs(tbl) do
         mergedTables[k] = v
      end
   end
   return mergedTables
end

-- get <table> keys filtered by predicate
M.getFilteredKeys = function(t, p)
   local filteredKeys = {}
   for k, v in pairs(t) do
      if p(k, v) then
         table.insert(filteredKeys, k)
      end
   end
   return filteredKeys
end

-- get <table> values filtered by predicate
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
