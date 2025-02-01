local function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

local function filter(input, predicate)
  local filteredArray = {}

  for i, str in ipairs(input) do
    if predicate(str) then
      table.insert(filteredArray, str)
    end
  end

  return filteredArray
end

local function concat(t1, t2)
  local result = {}
  for i = 1, #t1 do
    table.insert(result, t1[i])
  end
  for i = 1, #t2 do
    table.insert(result, t2[i])
  end
  return result
end

local function str_contains(input, str_search)
  return filter(input, function(x) return string.find(x, str_search, 1, true) end)
end

local function str_not_contains(input, str_search)
  return filter(input, function(x) return not string.find(x, str_search, 1, true) end)
end

local function table_concat(t1, t2)
  for i = 1, #t2 do
    t1[#t1 + 1] = t2[i]
  end
  return t1
end

function Set(list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

local function flat_map(tbl, func)
  local result = {}
  for _, v in ipairs(tbl) do
    -- Apply the function and add the result to the result table
    local mapped = func(v)
    -- Flatten the result by concatenating into the result table
    for _, item in ipairs(mapped) do
      table.insert(result, item)
    end
  end
  return result
end

local function keys(t)
  local keys = {}
  for key, _ in pairs(t) do
    table.insert(keys, key)
  end
  return keys
end

local function merge_tables(base, other)
  for key, value in pairs(other) do
    base[key] = value
  end
  return base
end
local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- print("plugins", dump(str_not_contains(vim.api.nvim_get_runtime_file("", true), ".vim")))
local exports = {
  dump = dump,
  filter = filter,
  str_contains = str_contains,
  str_not_contains = str_not_contains,
  table_concat = table_concat,
  flat_map = flat_map,
  keys = keys,
  merge_tables = merge_tables,
  trim = trim,
  concat = concat,
}

return exports
