-- Debug and inspection tools for custom treesitter captures.
-- These are primarily for development and debugging your .scm query files.

local M = {}

local function get_lang(bufnr)
  bufnr = bufnr or 0
  local ft = vim.bo[bufnr].filetype
  return vim.treesitter.language.get_lang(ft) or ft
end

--- Debug helper. Prints information about the capture under cursor.
--- Very useful while developing / porting queries.
---
--- Now also understands virtual captures (e.g. parameter.outer computed from .inner).
---@param capture_name string
function M.debug(capture_name)
  local bufnr = 0
  local lang = get_lang(bufnr)
  local main = require('textobjects')   -- lazy to avoid circular require

  -- Try real node first
  local node = main.find_best_capture(capture_name, bufnr)

  if node then
    local sr, sc, er, ec = node:range()
    local text = vim.treesitter.get_node_text(node, bufnr):gsub("\n", "\\n")
    print(string.format(
      "%s: %s [%d:%d - %d:%d]  node=%s\ntext: %s",
      lang or "?", capture_name, sr, sc, er, ec, node:type(), text
    ))
    return
  end

  -- Try virtual/computed range
  local virtual_range = main.get_range(capture_name, bufnr)
  if virtual_range then
    local sr, sc, er, ec = unpack(virtual_range)
    local inner_name = capture_name:gsub("%.outer$", ".inner")
    local inner = main.find_best_capture(inner_name, bufnr)
    local inner_type = inner and inner:type() or "?"

    print(string.format(
      "%s: %s [%d:%d - %d:%d]  (computed in Lua from @%s)\ninner node type: %s",
      lang or "?", capture_name, sr, sc, er, ec, inner_name, inner_type
    ))
    return
  end

  print(string.format("No %s found (lang=%s)", capture_name, lang or "???"))
end

--- List all capture names defined in a query group.
--- Example:
---   :lua require('textobjects.debug').list_captures("typescript")
---   :lua require('textobjects.debug').list_captures("typescript", "folds")
function M.list_captures(lang, query_group)
  query_group = query_group or "textobjects"
  lang = lang or get_lang(0)

  local query = vim.treesitter.query.get(lang, query_group)
  if not query then
    print(string.format("No '%s' query found for language '%s'", query_group, lang))
    return
  end

  print(string.format("Captures defined in '%s' group for language '%s':", query_group, lang))
  for _, name in ipairs(query.captures) do
    print(string.format("  @%s", name))
  end
end

--- Show all captures from the "textobjects" query group whose range contains the cursor.
--- This now also includes virtual (Lua-computed) captures.
function M.show_textobject_captures(bufnr)
  bufnr = bufnr or 0
  local lang = get_lang(bufnr)
  local query = vim.treesitter.query.get(lang, "textobjects")

  if not query then
    vim.notify(string.format("No 'textobjects' query for language '%s'", lang or "?"), vim.log.levels.WARN)
    return
  end

  local parser = vim.treesitter.get_parser(bufnr, lang)
  if not parser then
    vim.notify("No parser available", vim.log.levels.WARN)
    return
  end

  local tree = parser:parse()[1]
  if not tree then return end
  local root = tree:root()

  local cursor = vim.api.nvim_win_get_cursor(0)
  local cur_row, cur_col = cursor[1] - 1, cursor[2]

  local matches = {}

  -- Real captures from the query file
  for id, node, _ in query:iter_captures(root, bufnr) do
    local sr, sc, er, ec = node:range()
    local name = query.captures[id]

    local contains = (sr <= cur_row and er >= cur_row) and
                     (sr < cur_row or sc <= cur_col) and
                     (er > cur_row or ec >= cur_col)

    if contains then
      local text = vim.treesitter.get_node_text(node, bufnr)
        :gsub("\n", " ")
        :sub(1, 50)

      table.insert(matches, {
        name = name,
        node_type = node:type(),
        range = { sr, sc, er, ec },
        text = text,
        computed = false,
      })
    end
  end

  -- Virtual / Lua-computed captures
  local main = require('textobjects')
  if main._VIRTUAL_COMPUTERS then
    for vname, _ in pairs(main._VIRTUAL_COMPUTERS) do
      local vrange = main.get_range(vname, bufnr)
      if vrange then
        local sr, sc, er, ec = unpack(vrange)

        local contains = (sr <= cur_row and er >= cur_row) and
                         (sr < cur_row or sc <= cur_col) and
                         (er > cur_row or ec >= cur_col)

        if contains then
          local inner_name = vname:gsub("%.outer$", ".inner")
          local inner_node = main.find_best_capture(inner_name, bufnr)
          local node_type = inner_node and inner_node:type() or "(virtual)"

          local sr2, sc2, er2, ec2 = unpack(vrange)
          local lines = vim.api.nvim_buf_get_text(bufnr, sr2, sc2, er2, ec2, {})
          local text = table.concat(lines, " "):gsub("\n", " "):sub(1, 50)

          table.insert(matches, {
            name = vname,
            node_type = node_type,
            range = vrange,
            text = text,
            computed = true,
          })
        end
      end
    end
  end

  print(string.format("=== 'textobjects' captures at cursor (lang=%s) ===", lang or "?"))

  if #matches == 0 then
    print("  (none contain the cursor)")
    return
  end

  table.sort(matches, function(a, b) return a.name < b.name end)

  for _, m in ipairs(matches) do
    local suffix = m.computed and "  (computed in Lua)" or ""
    print(string.format("  @%-25s  %-18s  [%d:%d - %d:%d]  %s%s",
      m.name,
      m.node_type,
      m.range[1], m.range[2], m.range[3], m.range[4],
      m.text, suffix))
  end
end

--- Quick command: :TSCaptures
vim.api.nvim_create_user_command("TSCaptures", function(opts)
  local arg = opts.args

  if arg == "" or arg == "textobjects" then
    M.show_textobject_captures()
  else
    M.list_captures(nil, arg)
  end
end, {
  nargs = "?",
  complete = function(ArgLead)
    local groups = { "textobjects", "highlights", "folds", "locals", "injections" }
    local matches = {}
    for _, g in ipairs(groups) do
      if vim.startswith(g, ArgLead) then
        table.insert(matches, g)
      end
    end
    return matches
  end,
  desc = "Inspect custom treesitter captures (default: textobjects group at cursor)",
})

return M
