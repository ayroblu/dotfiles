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

local function str_contains(input, str_search)
  return filter(input, function(x) return string.find(x, str_search, 1, true) end)
end

local function str_not_contains(input, str_search)
  return filter(input, function(x) return not string.find(x, str_search, 1, true) end)
end

function Set(list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

-- print("plugins", dump(str_not_contains(vim.api.nvim_get_runtime_file("", true), ".vim")))
local exports = {
  dump = dump,
  filter = filter,
  str_contains = str_contains,
  str_not_contains = str_not_contains,
}

return exports
