-- Pure vim.treesitter powered textobjects.
--
-- Queries live in the standard location:
--   queries/<lang>/textobjects.scm

local M = {}

local function get_lang(bufnr)
  bufnr = bufnr or 0
  local ft = vim.bo[bufnr].filetype
  -- Respect any language registrations the user already does
  return vim.treesitter.language.get_lang(ft) or ft
end

--- Return the 'textobjects' query for the buffer's language, if available.
---@param bufnr integer?
---@return vim.treesitter.Query|nil
function M.get_query(bufnr)
  local lang = get_lang(bufnr)
  if not lang or lang == "" then return nil end
  return vim.treesitter.query.get(lang, "textobjects")
end

--- Find all captures matching a name (with or without leading @).
---@param capture_name string  e.g. "parameter.inner" or "@parameter.inner"
---@param bufnr integer?
---@return table[] nodes
function M.find_captures(capture_name, bufnr)
  bufnr = bufnr or 0
  capture_name = capture_name:gsub("^@", "")

  local query = M.get_query(bufnr)
  if not query then return {} end

  local parser = vim.treesitter.get_parser(bufnr)
  if not parser then return {} end

  local tree = parser:parse()[1]
  if not tree then return {} end

  local root = tree:root()
  local results = {}

  for id, node, _ in query:iter_captures(root, bufnr) do
    if query.captures[id] == capture_name then
      table.insert(results, node)
    end
  end

  return results
end

--- Choose the "best" node for a capture near the cursor.
--- Strategy: smallest node that contains the cursor position.
---@param capture_name string
---@param bufnr integer?
---@return TSNode|nil
function M.find_best_capture(capture_name, bufnr)
  bufnr = bufnr or 0
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cur_row, cur_col = cursor[1] - 1, cursor[2]   -- 0-based

  local candidates = M.find_captures(capture_name, bufnr)
  if #candidates == 0 then return nil end

  local best
  local best_size = math.huge

  for _, node in ipairs(candidates) do
    local sr, sc, er, ec = node:range()

    local contains = (sr < cur_row or (sr == cur_row and sc <= cur_col))
                 and (er > cur_row or (er == cur_row and ec >= cur_col))

    if contains then
      local size = (er - sr) * 10000 + (ec - sc)
      if size < best_size then
        best_size = size
        best = node
      end
    end
  end

  if not best and #candidates > 0 then
    local cur_row, cur_col = cursor[1] - 1, cursor[2]

    -- Prefer the nearest capture that starts *at or after* the cursor position.
    -- This gives the nice "when I'm not on one, go to the next one" behavior.
    local after_cursor = {}
    for _, node in ipairs(candidates) do
      local sr, sc = node:range()
      if sr > cur_row or (sr == cur_row and sc >= cur_col) then
        table.insert(after_cursor, node)
      end
    end

    if #after_cursor > 0 then
      table.sort(after_cursor, function(a, b)
        local ar, ac = a:range()
        local br, bc = b:range()
        if ar == br then return ac < bc end
        return ar < br
      end)
      best = after_cursor[1]
    else
      -- Nothing after the cursor → fall back to the first capture in the buffer
      table.sort(candidates, function(a, b)
        local ar, ac = a:range()
        local br, bc = b:range()
        if ar == br then return ac < bc end
        return ar < br
      end)
      best = candidates[1]
    end
  end

  return best
end

-- Virtual / computed captures.
-- These are derived in Lua rather than coming directly from the .scm files.
M._VIRTUAL_COMPUTERS = {
  -- parameter.outer is computed from parameter.inner + neighboring commas
  ["parameter.outer"] = function(best_inner_node)
    if best_inner_node then
      return M.compute_parameter_outer(best_inner_node)
    end
  end,
}

-- Keep a local reference for internal use
local VIRTUAL_COMPUTERS = M._VIRTUAL_COMPUTERS

--- Try to satisfy a capture using a virtual/computed implementation.
local function try_virtual_capture(capture_name, bufnr)
  local computer = VIRTUAL_COMPUTERS[capture_name]
  if not computer then return nil end

  -- Find the best corresponding .inner node first
  local inner_name = capture_name:gsub("%.outer$", ".inner")
  local inner_node = M.find_best_capture(inner_name, bufnr)

  if inner_node then
    return computer(inner_node)
  end

  return nil
end

--- Get 0-based range {start_row, start_col, end_row, end_col} for a capture.
---
--- This now supports "virtual" captures that are computed in Lua rather than
--- coming directly from the query files. This is the modern replacement for
--- many uses of #make-range!.
---@param capture_name string
---@param bufnr integer?
---@return table|nil  four numbers, or nil
function M.get_range(capture_name, bufnr)
  bufnr = bufnr or 0

  -- 1. Try normal query-based captures first (existing @foo.outer definitions)
  local node = M.find_best_capture(capture_name, bufnr)
  if node then
    return { node:range() }
  end

  -- 2. Fall back to virtual/computed captures (the modern Lua approach)
  local virtual_range = try_virtual_capture(capture_name, bufnr)
  if virtual_range then
    return virtual_range
  end

  return nil
end

--- Perform a textobject selection in visual or operator-pending mode.
--- This is the main function you will call from keymaps.
---
--- We use the < and > marks + `gv` method because it is significantly more
--- reliable than moving the cursor + `normal! v`, especially in operator-pending
--- mode and with longer nodes.
---@param capture_name string
function M.select(capture_name)
  local range = M.get_range(capture_name)
  if not range then
    vim.notify("No textobject found for " .. capture_name, vim.log.levels.WARN)
    return
  end

  local sr, sc, er, ec = unpack(range)

  -- Treesitter ranges are 0-based with exclusive end column.
  -- Visual selection marks are 1-based lines, and the end column is inclusive.
  local start_line = sr + 1
  local start_col  = sc
  local end_line   = er + 1
  local end_col    = (ec > 0) and (ec - 1) or 0

  vim.api.nvim_buf_set_mark(0, "<", start_line, start_col, {})
  vim.api.nvim_buf_set_mark(0, ">", end_line, end_col, {})

  vim.cmd("normal! gv")
end

-------------------------------------------------------------------------------
-- Modern Lua-based "virtual" captures
--
-- Preferred direction instead of heavy #make-range! usage in .scm files.
-- We compute things like parameter.outer (with trailing comma) in Lua
-- from the corresponding .inner node. This keeps the query files much
-- simpler.
-------------------------------------------------------------------------------

-- Common separators we want to "absorb" into .outer versions of list items.
local LIST_SEPARATORS = { [","] = true, [";"] = true }

local function is_separator(node)
  return node and LIST_SEPARATORS[node:type()]
end

--- Given an "item" node (e.g. a parameter, array element, object property, etc.),
--- try to extend its range to include a neighboring comma/semicolon.
---
--- This replaces a large number of `#make-range!` patterns that existed only
--- to include the joiner punctuation.
function M.compute_list_item_outer(item_node)
  if not item_node then return nil end

  local sr, sc, er, ec = item_node:range()

  -- Prefer extending to the right (trailing comma) — very useful for deletion.
  local sib = item_node:next_sibling()
  -- Skip comments
  while sib and (sib:type() == "comment" or sib:type() == "block_comment") do
    sib = sib:next_sibling()
  end

  if is_separator(sib) then
    local _, _, ser, sec = sib:range()
    return { sr, sc, ser, sec }
  end

  -- Fall back to preceding separator (common for the last item in a list)
  sib = item_node:prev_sibling()
  while sib and (sib:type() == "comment" or sib:type() == "block_comment") do
    sib = sib:prev_sibling()
  end

  if is_separator(sib) then
    local psr, psc = sib:range()
    return { psr, psc, er, ec }
  end

  -- No separator found — just return the inner range
  return { sr, sc, er, ec }
end

-- Specialized version for parameters.
-- We can make this smarter later (e.g. respect different parent contexts
-- like formal_parameters vs arguments vs object patterns).
M.compute_parameter_outer = M.compute_list_item_outer

-- Re-export debug & inspection tools (they live in textobjects/debug.lua)
local debug_mod = require('textobjects.debug')
M.debug                  = debug_mod.debug
M.list_captures          = debug_mod.list_captures
M.show_textobject_captures = debug_mod.show_textobject_captures

return M
