local utils = require('utils')
----------------------------------------------------------- function style
local function edit(func_name, action_input)
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  local buffer = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local input = utils.merge_tables({
    line = row,
    column = col,
    source = table.concat(buffer, "\n"),
  }, action_input)
  local input_str = vim.fn.json_encode(input)

  vim.system({ func_name }, {
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
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(utils.trim(obj.stdout), "\n"))
        end)
      end
    end
  end)
end
local function js_function_style(action)
  edit("js-function-style", { action = action })
end
local function js_function()
  js_function_style("Function")
end
local function js_arrow_block()
  js_function_style("ArrowBlock")
end
local function js_arrow_inline()
  js_function_style("ArrowInline")
end

local function ternary_condition(action, lang)
  edit("ternary-condition", { action = action, lang = lang })
end
local function js_ternary()
  ternary_condition("Ternary", "TypeScript")
end
local function js_condition()
  ternary_condition("Condition", "TypeScript")
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
    vim.keymap.set("n", "cit", js_ternary, { desc = "Convert to ternary", buffer = true })
    vim.keymap.set("n", "cic", js_condition, { desc = "Convert to condition", buffer = true })
  end,
  group = nvim_commands_group,
})

----------------------------------------------------------- Lang Move
-- disabled for now due to swift incompatibility
-- local function lang_move(lang, action)
--   local bufnr = vim.api.nvim_get_current_buf()
--   local row, col = unpack(vim.api.nvim_win_get_cursor(0))
--   row = row - 1

--   local buffer = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
--   local input = {
--     line = row,
--     column = col,
--     source = table.concat(buffer, "\n"),
--     lang = lang,
--     action = action,
--   }
--   local input_str = vim.fn.json_encode(input)

--   vim.system({ "lang-move" }, {
--     stdin = { input_str, "\n" },
--     text = true
--   }, function(obj)
--     if obj.code ~= 0 then
--       print(obj.code)
--       print("Error executing action: " .. obj.stderr)
--       vim.notify("Error executing action: " .. obj.stderr, vim.log.levels.ERROR)
--     else
--       if string.len(obj.stdout) > 0 then
--         -- nvim_buf_set_lines must not be called in a lua loop callback
--         vim.schedule(function()
--           vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(obj.stdout, "\n"))
--         end)
--       end
--     end
--   end)
-- end
-- local lang_move_config = {
--   {
--     filetype = { "javascript", "javascriptflow", "javascriptreact", "typescript", "typescriptreact" },
--     lang = "TypeScript",
--   },
--   { filetype = { "rust" },   lang = "Rust" },
--   { filetype = { "python" }, lang = "Python" },
--   { filetype = { "scala" },  lang = "Scala" },
--   { filetype = { "go" },     lang = "Go" },
--   { filetype = { "swift" },  lang = "Swift" },
-- }
-- for _, config in ipairs(lang_move_config) do
--   local filetype, lang = config.filetype, config.lang
--   vim.api.nvim_create_autocmd("FileType", {
--     pattern = filetype,
--     callback = function()
--       vim.keymap.set("n", "<,", function() lang_move(lang, "Prev") end, { desc = "move prev", buffer = true })
--       vim.keymap.set("n", ">,", function() lang_move(lang, "Next") end, { desc = "move next", buffer = true })
--     end,
--     group = nvim_commands_group,
--   })
-- end
