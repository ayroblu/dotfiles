----------------------------------------------------------- function style
local function js_edit(action)
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  local buffer = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local input = {
    line = row,
    column = col,
    source = table.concat(buffer, "\n"),
    action = action
  }
  local input_str = vim.fn.json_encode(input)

  vim.system({ "js-function-style" }, {
    stdin = { input_str, "\n" },
    text = true
  }, function(obj)
    if obj.code ~= 0 then
      print(obj.code)
      vim.notify("Error executing action: " .. obj.stderr, vim.log.levels.ERROR)
    else
      if string.len(obj.stdout) > 0 then
        -- nvim_buf_set_lines must not be called in a lua loop callback
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(obj.stdout, "\n"))
        end)
      end
    end
  end)
end
local function js_function()
  js_edit("Function")
end
local function js_arrow_block()
  js_edit("ArrowBlock")
end
local function js_arrow_inline()
  js_edit("ArrowInline")
end

vim.api.nvim_create_user_command('EditJsArrowBlock', js_arrow_block, {})
vim.api.nvim_create_user_command('EditJsArrowInline', js_arrow_inline, {})
vim.api.nvim_create_user_command('EditJsFunction', js_function, {})
local nvim_commands_group = vim.api.nvim_create_augroup("js_commands", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptflow", "javascriptreact", "typescript", "typescriptreact" },
  callback = function()
    vim.keymap.set("n", "ciab", js_arrow_block, { desc = "Convert to arrow block", buffer = true })
    vim.keymap.set("n", "ciai", js_arrow_inline, { desc = "Convert to arrow inline", buffer = true })
    vim.keymap.set("n", "cif", js_function, { desc = "Convert to function", buffer = true })
  end,
  group = nvim_commands_group,
})

----------------------------------------------------------- Lang Move
local function lang_move(lang, action)
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  local buffer = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local input = {
    line = row,
    column = col,
    source = table.concat(buffer, "\n"),
    lang = lang,
    action = action,
  }
  local input_str = vim.fn.json_encode(input)

  vim.system({ "lang-move" }, {
    stdin = { input_str, "\n" },
    text = true
  }, function(obj)
    if obj.code ~= 0 then
      print(obj.code)
      vim.notify("Error executing action: " .. obj.stderr, vim.log.levels.ERROR)
    else
      if string.len(obj.stdout) > 0 then
        -- nvim_buf_set_lines must not be called in a lua loop callback
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(obj.stdout, "\n"))
        end)
      end
    end
  end)
end
local lang_move_config = {
  {
    filetype = { "javascript", "javascriptflow", "javascriptreact", "typescript", "typescriptreact" },
    lang = "TypeScript",
  },
  {
    filetype = { "rust" },
    lang = "Rust",
  },
  {
    filetype = { "python" },
    lang = "Python",
  },
  {
    filetype = { "scala" },
    lang = "Scala",
  },
}
for _, config in ipairs(lang_move_config) do
  local filetype, lang = config.filetype, config.lang
  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetype,
    callback = function()
      vim.keymap.set("n", "<,", function() lang_move(lang, "Prev") end, { desc = "move prev", buffer = true })
      vim.keymap.set("n", ">,", function() lang_move(lang, "Next") end, { desc = "move next", buffer = true })
    end,
    group = nvim_commands_group,
  })
end
