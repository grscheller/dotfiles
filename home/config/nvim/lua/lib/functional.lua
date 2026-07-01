--[[ Functional Programming for Lua

     Functions designed to be applied against "simple" tables:
       - array means a Lua consecutive integer indexed table with no holes
       - map means a table of key -> value pairs
       - all tables are assumed to be "well founded" with
         - no references to itself
         - no circular references

     So that these JIT compile and run very fast, there is no type or error
     checking.  It is the programmer's responsibility to pass the correct data
     structures to these functions.

     I would not use these with mixed tables. Function-like objects, tables
     with __call metamethods, these functions should be OK as function arguments.

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

---Concatenate two arrays, return new array. O(n + m).
---@generic V
---@param a1 V[]
---@param a2 V[]
---@return V[]
M.concat_arrays = function(a1, a2)
   local n = #a1
   local result = {}
   for i = 1, n do
      result[i] = a1[i]
   end
   for i = 1, #a2 do
      result[n + i] = a2[i]
   end
   return result
end

---Flatten an <array> of <arrays> (will repeat values)
---@generic A
---@param aoa A[][]
---@return A[]
M.flatten_array = function(aoa)
   local flattened = {}
   for _, v in ipairs(aoa) do
      for _, w in ipairs(v) do
         table.insert(flattened, w)
      end
   end
   return flattened
end

---Apply a function to each element of an array,
---can be Curried, skip nil returned values.
---@generic A
---@generic B
---@param f fun(a: A): B?
---@param as A[]
---@return B[]|fun(as: A[]): B[]
M.map_array = function(f, as)
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
      return ma
   end

   if as ~= nil then
      return map(as)
   else
      return map
   end
end

---Merge an array of maps - later tables override earlier ones
---@generic K
---@generic V
---@param t table<K, V>[]
---@return table<K, V>
M.merge_array_of_tables = function(t)
   local merged_table = {}
   for _, tbl in ipairs(t) do
      for k, v in pairs(tbl) do
         merged_table[k] = v
      end
   end
   return merged_table
end

---get the keys to a table
---@generic K
---@generic V
---@param t table<K, V>
---@return K[]
M.get_table_keys = function(t)
   local filtered_keys = {}
   local ii = 1
   for key, _ in pairs(t) do
      filtered_keys[ii] = key
      ii = ii + 1
   end
   return filtered_keys
end

---get the values in a table
---@generic K
---@generic V
---@param t table<K, V>
---@return V[]
M.get_table_values = function(t)
   local filtered_values = {}
   local ii = 1
   for _, value in pairs(t) do
      filtered_values[ii] = value
      ii = ii + 1
   end
   return filtered_values
end

---get table keys filtered by predicate
---@generic K
---@generic V
---@param t table<K, V>
---@param p fun(k: K, v: V): boolean
---@return K[]
M.get_filtered_keys = function(t, p)
   local filtered_keys = {}
   local ii = 1
   for key, value in pairs(t) do
      if p(key, value) then
         filtered_keys[ii] = key
         ii = ii + 1
      end
   end
   return filtered_keys
end

---get table values filtered by predicate
---@generic K
---@generic V
---@param t table<K, V>
---@param p fun(k: K, v: V): boolean
---@return V[]
M.get_filtered_values = function(t, p)
   local filtered_values = {}
   local ii = 1
   for key, value in pairs(t) do
      if p(key, value) then
         filtered_values[ii] = value
         ii = ii + 1
      end
   end
   return filtered_values
end

---Returns a new sorted array, O(n⋅log(n)) on average, O(n²) worst case.
---@generic V
---@param vs V[] contract: array contains homogeneous sortable values
---@return V[]
M.sort_array = function(vs)
   local copy = {}
   for ii = 1, #vs do
      copy[ii] = vs[ii]
   end
   table.sort(copy)
   return copy
end

---Consolidate consecutive duplicates values from an array,
---return new array, O(n).
---@generic V
---@param vs V[] contract: array contains homogeneous sortable values
---@return V[]
M.uniq = function(vs)
   local n = #vs
   local sorted = {}
   if n == 0 then
      return sorted
   end
   sorted[1] = vs[1]
   local curr = 1
   for ii = 2, n do
      if vs[ii] ~= sorted[curr] then
         curr = curr + 1
         sorted[curr] = vs[ii]
      end
   end
   return sorted
end

---Return a new sorted array with uniq values,
---O(n⋅log(n)) on average, O(n²) worst case.
---@generic V
---@param vs V[] contract: array contains homogeneous sortable values
---@return V[]
M.sort_array_uniq = function(vs)
   return M.uniq(M.sort_array(vs))
end

return M
