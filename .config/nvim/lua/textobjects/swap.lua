-- textobjects/swap.lua
--
-- Minimal swap support for nodes captured by your textobjects queries.
-- Only swaps the raw text of two "adjacent" named nodes (separated only
-- by anonymous nodes like commas).
--
-- Public API:
--   require('textobjects').swap_next({ "parameter.inner", "swappable.inner" })
--   require('textobjects').swap_prev({ "parameter.inner", "swappable.inner" })

local M = {}

-- Lazy require to avoid circular dependency issues at load time
local function get_main()
  return require("textobjects")
end

local function is_allowed_capture(name, allowed)
  if type(allowed) == "string" then
    return name == allowed
  end
  for _, a in ipairs(allowed) do
    if name == a then return true end
  end
  return false
end

--- Find the smallest captured node that actually contains the cursor and matches
--- one of the allowed captures. Returns nil (no swap) if not hovered over any.
local function find_captured_node_under_cursor(allowed_captures, bufnr)
  bufnr = bufnr or 0
  local main = get_main()

  if type(allowed_captures) == "string" then
    allowed_captures = { allowed_captures }
  end

  for _, cap in ipairs(allowed_captures) do
    local node = main.find_containing_capture(cap, bufnr)
    if node then
      return node
    end
  end
  return nil
end

--- Find the next/previous named sibling (skipping anonymous nodes like commas)
--- that is also captured by one of the allowed capture names.
--- We do one query pass on the parent to build a set of valid swappable nodes,
--- then walk using next_named_sibling / prev_named_sibling.
local function find_adjacent_swappable(current_node, direction, allowed_captures, bufnr)
  if not current_node then return nil end
  bufnr = bufnr or 0

  local main = get_main()
  local parent = current_node:parent()
  if not parent then return nil end

  -- One-time collection: which nodes under this parent match the allowed captures?
  local swappable = {}
  local query = main.get_query(bufnr)
  if query then
    for id, node, _ in query:iter_captures(parent, bufnr) do
      local cap_name = query.captures[id]
      if is_allowed_capture(cap_name, allowed_captures) then
        swappable[node:id()] = true
      end
    end
  end

  -- Walk using named siblings (automatically skips commas and other anonymous nodes)
  local sib = (direction == "next") 
      and current_node:next_named_sibling() 
      or  current_node:prev_named_sibling()

  while sib do
    if swappable[sib:id()] then
      return sib
    end
    sib = (direction == "next") 
        and sib:next_named_sibling() 
        or  sib:prev_named_sibling()
  end

  return nil
end

local function swap_node_text(node_a, node_b, bufnr)
  if not node_a or not node_b then return false end
  bufnr = bufnr or 0

  local text_a = vim.treesitter.get_node_text(node_a, bufnr)
  local text_b = vim.treesitter.get_node_text(node_b, bufnr)

  local a_sr, a_sc, a_er, a_ec = node_a:range()
  local b_sr, b_sc, b_er, b_ec = node_b:range()

  -- Always replace the later range first.
  -- Doing two set_text calls with stale offsets is the source of the mangling.
  if a_sr > b_sr or (a_sr == b_sr and a_sc > b_sc) then
    -- A comes after B
    vim.api.nvim_buf_set_text(bufnr, a_sr, a_sc, a_er, a_ec, vim.split(text_b, "\n", { plain = true }))
    vim.api.nvim_buf_set_text(bufnr, b_sr, b_sc, b_er, b_ec, vim.split(text_a, "\n", { plain = true }))
  else
    -- B comes after A (or they start at the same position)
    vim.api.nvim_buf_set_text(bufnr, b_sr, b_sc, b_er, b_ec, vim.split(text_a, "\n", { plain = true }))
    vim.api.nvim_buf_set_text(bufnr, a_sr, a_sc, a_er, a_ec, vim.split(text_b, "\n", { plain = true }))
  end

  return true
end

--- Places the cursor at the same relative offset from the start of the moved content.
--- `delta` = (length of text that moved into this position) - (length of text that left)
local function restore_cursor(orig_range, other_range, original_cursor, delta)
  if not original_cursor then return end

  local orig_row, orig_col = original_cursor[1] - 1, original_cursor[2]

  -- The original content is now living where `other_range` used to be.
  local t_sr, t_sc, t_er, t_ec = unpack(other_range)

  -- Relative offset inside the original item
  local o_sr, o_sc = unpack(orig_range)
  local row_offset = orig_row - o_sr
  local col_offset = (row_offset == 0) and (orig_col - o_sc) or orig_col

  -- Apply the shift caused by the other replacement (only if it was to the left)
  local shift = 0
  if orig_range[1] < t_sr or (orig_range[1] == t_sr and orig_range[2] < t_sc) then
    shift = delta
  end

  local target_col = t_sc + col_offset + shift
  local target_row = t_sr + row_offset

  -- Clamp
  if target_row > t_er then
    target_row = t_er
    target_col = t_ec
  elseif target_row == t_er and target_col > t_ec then
    target_col = t_ec
  elseif target_col < t_sc then
    target_col = t_sc
  end

  pcall(vim.api.nvim_win_set_cursor, 0, { target_row + 1, target_col })
end

local function do_swap(direction, allowed_captures)
  local bufnr = 0

  local node = find_captured_node_under_cursor(allowed_captures, bufnr)
  if not node then return false end  -- silent

  local adjacent = find_adjacent_swappable(node, direction, allowed_captures, bufnr)
  if not adjacent then return false end  -- silent

  local cursor_before = vim.api.nvim_win_get_cursor(0)

  -- Capture everything we need *before* mutating the buffer
  local node_range = { node:range() }
  local adjacent_range = { adjacent:range() }
  local text_node = vim.treesitter.get_node_text(node, bufnr)
  local text_adjacent = vim.treesitter.get_node_text(adjacent, bufnr)

  local ok = swap_node_text(node, adjacent, bufnr)
  if not ok then return false end

  -- Cursor should follow the content that was originally under the cursor.
  -- That content is now in the range that `adjacent` used to occupy.
  local delta = #text_adjacent - #text_node
  restore_cursor(node_range, adjacent_range, cursor_before, delta)

  return true
end

--- Swap the current item with the next swappable sibling.
--- @param captures string|table  e.g. "parameter.inner" or {"parameter.inner", "swappable.inner"}
function M.swap_next(captures)
  return do_swap("next", captures)
end

--- Swap the current item with the previous swappable sibling.
--- @param captures string|table
function M.swap_prev(captures)
  return do_swap("prev", captures)
end

return M
