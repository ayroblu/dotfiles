-- Development / diagnostic test for the virtual capture logic.
-- Not loaded by default in normal use.

local M = {}

--- Quick diagnostic test for parameter.inner vs parameter.outer (Lua computed).
---
--- Run with:
---   :lua require('textobjects').run_test()
function M.test_parameter()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(bufnr, "filetype", "typescript")

  -- Using long, distinct names so selection start/end is obvious
  local code = [[
function example(aaaaaaaaa, bbbbbbbbb = 42, { ccccccccc, ddddddddd: eeeeeeeee }) {
  const x = aaaaaaaaa + bbbbbbbbb;
  console.log(x, ccccccccc);
}
]]

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(code, "\n", { plain = true }))

  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, bufnr)

  print("=== Parameter Outer Computation Test (TypeScript) ===")
  print("Using long names so ranges are easy to read.\n")

  -- Helper to inspect siblings around a node
  local function inspect_siblings(node, label)
    if not node then
      print("  " .. label .. ": no node")
      return
    end

    local prev = node:prev_sibling()
    local next = node:next_sibling()

    local function fmt(n)
      if not n then return "nil" end
      local sr, sc, er, ec = n:range()
      local txt = vim.treesitter.get_node_text(n, bufnr):gsub("\n", "\\n")
      return string.format("%s [%d:%d-%d:%d] %q", n:type(), sr, sc, er, ec, txt)
    end

    print(string.format("  %s prev_sibling: %s", label, fmt(prev)))
    print(string.format("  %s next_sibling: %s", label, fmt(next)))
  end

  -- The function signature is on line 1 (1-based).
  -- Column numbers are tuned to land inside each long parameter name.

  -- === Scenario 1: First parameter (should have trailing comma) ===
  vim.api.nvim_win_set_cursor(win, { 1, 20 })   -- inside aaaaaaaaa
  print(string.format("[1] Cursor at (1,20) -> inside FIRST parameter (aaaaaaaaa)"))
  local inner = require("textobjects").find_best_capture("parameter.inner", bufnr)
  if inner then
    local ir = { inner:range() }
    local itext = vim.treesitter.get_node_text(inner, bufnr)

    local orange = require("textobjects").get_range("parameter.outer", bufnr) or ir

    print(string.format("    inner range: [%d:%d - %d:%d]  text=%q", ir[1], ir[2], ir[3], ir[4], itext))
    print(string.format("    outer range: [%d:%d - %d:%d]", orange[1], orange[2], orange[3], orange[4]))

    inspect_siblings(inner, "first param")
  end

  -- === Scenario 2: Middle parameter (best case for comma detection) ===
  vim.api.nvim_win_set_cursor(win, { 1, 38 })   -- inside bbbbbbbbb
  print(string.format("\n[2] Cursor at (1,38) -> inside MIDDLE parameter (bbbbbbbbb)"))
  inner = require("textobjects").find_best_capture("parameter.inner", bufnr)
  if inner then
    local ir = { inner:range() }
    local itext = vim.treesitter.get_node_text(inner, bufnr)

    local orange = require("textobjects").get_range("parameter.outer", bufnr) or ir

    print(string.format("    inner range: [%d:%d - %d:%d]  text=%q", ir[1], ir[2], ir[3], ir[4], itext))
    print(string.format("    outer range: [%d:%d - %d:%d]", orange[1], orange[2], orange[3], orange[4]))

    inspect_siblings(inner, "middle param")
  end

  -- === Scenario 3: Destructured parameter inside object pattern ===
  vim.api.nvim_win_set_cursor(win, { 1, 55 })   -- inside ccccccccc
  print(string.format("\n[3] Cursor at (1,55) -> inside DESTRUCTURED param (cccccccccc)"))
  inner = require("textobjects").find_best_capture("parameter.inner", bufnr)
  if inner then
    local ir = { inner:range() }
    local itext = vim.treesitter.get_node_text(inner, bufnr)
    local orange = require("textobjects").get_range("parameter.outer", bufnr) or ir

    print(string.format("    inner range: [%d:%d - %d:%d]  text=%q", ir[1], ir[2], ir[3], ir[4], itext))
    print(string.format("    outer range: [%d:%d - %d:%d]", orange[1], orange[2], orange[3], orange[4]))

    inspect_siblings(inner, "destructured param")
  end

  print("\n=== End of test ===")
  print("Look at the sibling output. The ',' should appear as next_sibling or prev_sibling with type \",\".")
  print("If inner/outer ranges are identical, the Lua extension logic did not find a comma sibling.")
end

--- Diagnostic test for the swap implementation.
--- Run with: :lua require('textobjects.test').test_swap()
function M.test_swap()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(bufnr, "filetype", "typescript")

  local code = [[
function example(aaaaaaaaa, bbbbbbbbb = 42, { ccccccccc, ddddddddd: eeeeeeeee }) {
  const x = aaaaaaaaa + bbbbbbbbb;
}
]]

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(code, "\n", { plain = true }))

  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, bufnr)

  print("=== Swap Diagnostic Test ===")
  print("Original buffer (line 1):")
  print("  " .. vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1])

  -- Test 1: Swap first ↔ second
  vim.api.nvim_win_set_cursor(win, { 1, 20 })  -- inside aaaaaaaaa
  local before = vim.api.nvim_win_get_cursor(win)
  print(string.format("\n[1] Cursor on first param (row %d, col %d) → swap_next", before[1], before[2]))
  require('textobjects').swap_next({ "parameter.inner" })
  local after = vim.api.nvim_win_get_cursor(win)
  print(string.format("  After (cursor at row %d, col %d): %s", after[1], after[2], vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]))

  -- Reset buffer
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(code, "\n", { plain = true }))

  -- Test 2: Swap second ↔ third (the one that was producing garbage before)
  vim.api.nvim_win_set_cursor(win, { 1, 38 })  -- inside bbbbbbbbb
  before = vim.api.nvim_win_get_cursor(win)
  print(string.format("\n[2] Cursor on middle param (row %d, col %d) → swap_next (this used to mangle)", before[1], before[2]))
  require('textobjects').swap_next({ "parameter.inner" })
  after = vim.api.nvim_win_get_cursor(win)
  print(string.format("  After (cursor at row %d, col %d): %s", after[1], after[2], vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]))

  -- Reset again
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(code, "\n", { plain = true }))

  vim.api.nvim_win_set_cursor(win, { 1, 38 })
  before = vim.api.nvim_win_get_cursor(win)
  print(string.format("\n[3] Cursor on middle param (row %d, col %d) → swap_prev", before[1], before[2]))
  require('textobjects').swap_prev({ "parameter.inner" })
  after = vim.api.nvim_win_get_cursor(win)
  print(string.format("  After (cursor at row %d, col %d): %s", after[1], after[2], vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]))

  print("\n=== Swap test complete ===")
end

return M
