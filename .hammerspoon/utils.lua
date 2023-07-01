function Set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

-- local function filter(input, predicate)
--     local filteredArray = {}

--     for i, str in ipairs(input) do
--         if predicate(str) then
--             table.insert(filteredArray, str)
--         end
--     end

--     return filteredArray
-- end
local function find(input, predicate)
    for i, str in ipairs(input) do
        if predicate(str) then
            return str
        end
    end
end
function ListStrContains(input, str_search)
    -- print(hs.inspect(input), str_search)
    -- print('result ListStriContains', find(input, function(x)
    --     print(str_search, x)
    --     print(string.find(str_search, x, 1, true))
    --     return string.find(str_search, x, 1, true)
    -- end))
    return find(input, function(x) return string.find(str_search, x, 1, true) end)
end

function RemoveWhere(tbl, predicate)
    for i = #tbl, 1, -1 do
        if predicate(tbl[i]) then
            table.remove(tbl, i)
        end
    end
end
