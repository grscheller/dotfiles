--[[ Functional Programming for Lua

     Functions designed to be applied against "simple" tables:
       <array> means a Lua consecutive integer indexed table with no holes
       <map> means a table of "key" -> value pairs

     So that these JIT compile and run very fast, there is no type or error
     checking.  It is the programmer's responsibility to pass the correct data
     structures to these functions.

     I would not use these with mixed tables. Function-like objects, like tables
     with __call metamethods, should be OK as function arguments ... I think?

     The use of the word "functional" is meant to mean that the interface is
     functional, not necessarily the implementation.

     Recursively copy a table, or what a table with a metatable table presents
     itself as.  Does not recreate a table with metatable. ]]

local M = {}

---Recursively copy a table, make no attempt replicating metatables
---@param original table
---@return table
M.deep_copy = function(original)
   local copy = {}
   for k, v in pairs(original) do
      if type(v) == 'table' then
         v = M.deep_copy(v)
      end
      copy[k] = v
   end
   return copy
end

-- Flatten an <array> of <arrays> (will repeat values)
M.flatten_array = function(aoa)
   local flattened = {}
   for _, v in ipairs(aoa) do
      for _, w in ipairs(v) do
         table.insert(flattened, w)
      end
   end
   return flattened
end

-- Apply a function to each element of an <array>, can be Curried.
M.map_array = function(f, a)
   local function map(vs)
      local ma = {}
      local j = 0
      for _, v in ipairs(vs) do
         local value = f(v)
         if value ~= nil then
            j = j + 1
            ma[j] = value
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

---Merge an <array> of <maps> - later tables override earlier ones
---@param array_of_maps table
---@return table
M.merge_array_of_tables = function(array_of_maps)
   local merged_table = {}
   for _, tbl in ipairs(array_of_maps) do
      for k, v in pairs(tbl) do
         merged_table[k] = v
      end
   end
   return merged_table
end

-- get <map> keys, return <array>
M.get_keys = function(t)
   local filtered_keys = {}
   for k, _ in pairs(t) do
      table.insert(filtered_keys, k)
   end
   return filtered_keys
end

-- get <map> values, return <array>
M.get_values = function(t)
   local filtered_values = {}
   for _, v in pairs(t) do
      table.insert(filtered_values, v)
   end
   return filtered_values
end

-- get <table> keys filtered by predicate, return <array>
M.get_filtered_keys = function(t, p)
   local filtered_keys = {}
   for k, v in pairs(t) do
      if p(k, v) then
         table.insert(filtered_keys, k)
      end
   end
   return filtered_keys
end

-- get <table> values filtered by predicate, return <array>
M.get_filtered_values = function(t, p)
   local filtered_values = {}
   for k, v in pairs(t) do
      if p(k, v) then
         table.insert(filtered_values, v)
      end
   end
   return filtered_values
end

return M
