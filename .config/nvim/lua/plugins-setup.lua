local oil_success, oil = pcall(require, "oil")
if oil_success then
  oil.setup({
    view_options = {
      show_hidden = true,
    }
  })
  vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
  local nvim_oil_group = vim.api.nvim_create_augroup("oil", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "oil" },
    callback = function()
      vim.cmd [[nnoremap <buffer> <silent> <leader><leader>tr :Files <C-R>=expand('%:h')[6:]<CR><CR>]]
      vim.cmd [[nnoremap <buffer> <Leader><Leader>te :Files <C-R>=expand('%:h:h')[6:]<CR><CR>]]
      -- vim.cmd [[nnoremap <silent> <Leader>e :Files <C-R>=split(expand('%:h')[6:],'/')[0]<CR><CR>]]
    end,
    group = nvim_oil_group,
  })
end

local ts_success, ts = pcall(require, "nvim-treesitter.configs")
if ts_success then
  ---@diagnostic disable-next-line: missing-fields
  ts.setup {
    -- One of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = {
      "cpp", "javascript", "typescript", "tsx", "graphql", "vim", "lua", "sql",
      "scala", "python", "markdown", "markdown_inline", "css", "bash",
      "swift", "regex", "starlark", "kotlin", "go", "hcl", "rust"
    },

    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = false,

    -- List of parsers to ignore installing
    ignore_install = {},

    highlight = {
      -- `false` will disable the whole extension
      enable = false,

      -- list of language that will be disabled
      disable = {},

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
  }
  vim.treesitter.language.register('tsx', { 'javascriptflow' })
  vim.treesitter.language.register('python', { 'aurora' })

  require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
      return { 'treesitter', 'indent' }
    end
  })
  vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
  vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
  vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
  -- vim.o.foldcolumn = '1'
  vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true
end

local tsp_success, ts = pcall(require, "nvim-treesitter.parsers")
if tsp_success then
  -- Don't fold everything
  -- https://github.com/nvim-treesitter/nvim-treesitter/discussions/1513
  local treesitter_parsers = require('nvim-treesitter.parsers')

  if treesitter_parsers.has_parser "typescript" then
    -- Note we don't fold (export_statement) because these are "important"
    local folds_query = [[
      (program [
        (function_declaration)
        (class_declaration)
        (method_definition)
        (export_statement)
        (lexical_declaration)
        (variable_declaration)
        (type_alias_declaration)
      ] @fold)
      (class_declaration (class_body (_) @fold))

      ((import_statement)+ @fold)

      ; tests only
      ((call_expression . function: (_) @variable.builtin (_) .)
        (#eq? @variable.builtin "describe")) @fold
      ((call_expression . function: (_) @variable.builtin (_) .)
        (#eq? @variable.builtin "it")) @fold
      ((call_expression . function: (_) @variable.builtin (_) .)
        (#eq? @variable.builtin "test")) @fold
    ]]

    require("vim.treesitter.query").set("typescript", "folds", folds_query)
    require("vim.treesitter.query").set("tsx", "folds", folds_query)
  end
end

local function setupTextObjects()
  -- debug with :InspectTree

  -- example: `as` for outer subword, `is` for inner subword
  vim.keymap.set({ "o", "x" }, "as", '<cmd>lua require("various-textobjs").subword("outer")<CR>')
  vim.keymap.set({ "o", "x" }, "is", '<cmd>lua require("various-textobjs").subword("inner")<CR>')

  -- vim.keymap.set({ "o", "x" }, "iv", "<cmd>lua require('various-textobjs').value('inner')<CR>")
  -- vim.keymap.set({ "o", "x" }, "av", "<cmd>lua require('various-textobjs').value('outer')<CR>")

  -- vim.keymap.set({ "o", "x" }, "ik", "<cmd>lua require('various-textobjs').key('inner')<CR>")
  -- vim.keymap.set({ "o", "x" }, "ak", "<cmd>lua require('various-textobjs').key('outer')<CR>")

  -- vim.keymap.set({ "o", "x" }, "gc", "<cmd>lua require('various-textobjs').multiCommentedLines()<CR>")

  ---@diagnostic disable-next-line: missing-fields
  require 'nvim-treesitter.configs'.setup {
    textobjects = {
      select = {
        enable = true,

        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,

        keymaps = {
          -- t, b, w, are defined already
          -- s is subword plugin
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          -- ["ac"] = "@class.outer",
          -- ["ic"] = "@class.inner",
          ["ad"] = "@assign.outer",
          ["id"] = "@assignment.inner",
          ["il"] = "@assign_left.inner",
          ["al"] = "@assign_left_outer",
          ["ir"] = "@assign_right.inner",
          ["ar"] = "@assign_right_outer",
          ["ie"] = "@expression.inner",
          ["ae"] = "@expression.outer",
          ["ic"] = "@call_name.inner",
          ["ac"] = "@call_name.outer",
          ["in"] = "@func_decl_name.inner",
          ["an"] = "@func_decl_name.outer",
          ["ii"] = "@params.inner",
          -- ["ic"] = "@call.inner",
          -- ["ac"] = "@call.outer",
          -- ["ib"] = "@block.inner",
          -- ["ab"] = "@block.outer",
          -- ["i<"] = "@conditional.inner",
          -- ["a<"] = "@conditional.outer",
          ["ip"] = "@parameter.inner",
          ["ap"] = "@parameter.outer",
          ["ia"] = "@type_annotation.inner",
          ["aa"] = "@type_annotation.outer",

          -- You can optionally set descriptions to the mappings (used in the desc parameter of
          -- nvim_buf_set_keymap) which plugins like which-key display
          -- ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
          -- You can also use captures from other query groups like `locals.scm`
          -- ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
        },
        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          -- ['@function.outer'] = 'V',  -- linewise
          ['@class.outer'] = 'V',
          -- ['@class.outer'] = '<c-v>', -- blockwise
        },
        -- If you set this to `true` (default is `false`) then any textobject is
        -- extended to include preceding or succeeding whitespace. Succeeding
        -- whitespace has priority in order to act similarly to eg the built-in
        -- `ap`.
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * selection_mode: eg 'v'
        -- and should return true of false
        -- include_surrounding_whitespace = true,
      },
      swap = {
        enable = true,
        swap_next = {
          [">,"] = { query = { "@swappable.inner", "@parameter.inner" } },
        },
        swap_previous = {
          ["<,"] = { query = { "@swappable.inner", "@parameter.inner" } },
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]e"] = "@expression.inner",
          ["]d"] = "@assignment.outer",
          ["]o"] = "@export.outer",
          ["]i"] = "@params.inner",
          ["]f"] = "@function.outer",
          ["]a"] = "@type_annotation.inner",
          -- ["]<"] = "@conditional.outer",
          ["]p"] = "@parameter.outer",
          -- ["]("] = "@call.outer",
          -- ["]b"] = "@block.inner",
        },
        goto_next_end = {
          ["]F"] = "@function.outer",
          ["]B"] = "@block.inner",
          ["]P"] = "@parameter.outer",
          -- ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[e"] = "@expression.inner",
          ["[d"] = "@assignment.outer",
          ["[o"] = "@export.outer",
          ["[i"] = "@params.inner",
          ["[f"] = "@function.outer",
          ["[a"] = "@type_annotation.inner",
          -- ["[<"] = "@conditional.outer",
          ["[p"] = "@parameter.outer",
          -- ["[("] = "@call.outer",
          -- ["[b"] = "@block.inner",
          -- ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[F"] = "@function.outer",
          ["[B"] = "@block.inner",
          ["[P"] = "@parameter.outer",
          -- ["[]"] = "@class.outer",
        },
        -- goto_next = {
        --   ["]d"] = "@conditional.outer",
        -- },
        -- goto_previous = {
        --   ["[d"] = "@conditional.outer",
        -- }
      },
    },
    -- textsubjects = {
    --   -- I don't love this, but . to select surrounding scope is kinda useful
    --   enable = true,
    --   prev_selection = ',', -- (Optional) keymap to select the previous selection
    --   keymaps = {
    --     ['.'] = 'textsubjects-smart',
    --     -- [';'] = 'textsubjects-container-outer',
    --     -- ['i;'] = 'textsubjects-container-inner',
    --     -- ['i;'] = { 'textsubjects-container-inner', desc = "Select inside containers (classes, functions, etc.)" },
    --   },
    -- },
  }

  local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

  -- Repeat movement with ; and ,
  -- ensure ; goes forward and , goes backward regardless of the last direction
  vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
  vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

  -- vim way: ; goes to the direction you were moving.
  -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
  -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

  -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
  vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
  vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
  vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
  vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

  -- example: make gitsigns.nvim movement repeatable with ; and , keys.
  local gs = require("gitsigns")

  -- make sure forward function comes first
  local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
  -- Or, use `make_repeatable_move` or `set_last_move` functions for more control. See the code for instructions.

  vim.keymap.set({ "n", "x", "o" }, "]h", next_hunk_repeat)
  vim.keymap.set({ "n", "x", "o" }, "[h", prev_hunk_repeat)
end

pcall(setupTextObjects)

local treeclimber_success, treeclimber = pcall(require, "nvim-treeclimber")
if treeclimber_success then
  vim.keymap.set({ "x", "o" }, "<C-j>", "<Plug>(treeclimber-select-shrink)", { desc = "select child node" })
  vim.keymap.set({ "x", "o" }, "<C-k>", "<Plug>(treeclimber-select-expand)", { desc = "select parent node" })
  -- local tc = require('nvim-treeclimber')
  -- tc.setup()
  -- vim.keymap.set(
  --   { "n", "x", "o" },
  --   "©" --[[ <M-g> ]],
  --   tc.select_top_level,
  --   { desc = "select the top level node from the current position" }
  -- )
  -- vim.keymap.set({ "n", "x", "o" }, "“" --[[ <M-[> ]], tc.select_siblings_backward, {})
  -- vim.keymap.set({ "n", "x", "o" }, "‘" --[[ <M-]> ]], tc.select_siblings_forward, {})
  -- vim.keymap.set({ "n", "x", "o" }, "˙" --[[ <M-h> ]], tc.select_backward, { desc = "select previous node" })
  -- vim.keymap.set({ "n", "x", "o" }, "∆" --[[ <M-j> ]], tc.select_shrink, { desc = "select child node" })
  -- vim.keymap.set({ "n", "x", "o" }, "˚" --[[ <M-k> ]], tc.select_expand, { desc = "select parent node" })
  -- vim.keymap.set({ "n", "x", "o" }, "¬" --[[ <M-l> ]], tc.select_forward, { desc = "select the next node" })
  -- vim.keymap.set({ "n", "x", "o" }, "Ò" --[[ <M-S-l> ]], tc.select_grow_forward,
  --   { desc = "Add the next node to the selection" })
  -- vim.keymap.set({ "n", "x", "o" }, "Ó" --[[ <M-S-h> ]], tc.select_grow_backward,
  --   { desc = "Add the next node to the selection" })


  -- vim.keymap.set({ "x", "o" }, "i.", tc.select_current_node, { desc = "select current node" })
  -- vim.keymap.set({ "x", "o" }, "a.", tc.select_expand, { desc = "select parent node" })
  -- vim.keymap.set(
  --   { "n", "x", "o" },
  --   "´" --[[ <M-e> ]],
  --   tc.select_forward_end,
  --   { desc = "select and move to the end of the node, or the end of the next node" }
  -- )
  -- vim.keymap.set(
  --   { "n", "x", "o" },
  --   "∫" --[[ <M-b> ]],
  --   tc.select_backward,
  --   { desc = "select and move to the begining of the node, or the beginning of the next node" }
  -- )
end

local function setupAerial()
  require('aerial').setup({
    -- optionally use on_attach to set keymaps when aerial has attached to a buffer
    on_attach = function(bufnr)
      -- Jump forwards/backwards with '{' and '}'
      vim.keymap.set('n', '<Leader>{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
      vim.keymap.set('n', '<Leader>}', '<cmd>AerialNext<CR>', { buffer = bufnr })
    end,
    layout = {
      max_width = { 40, 0.4 },
    },
    filter_kind = {
      "Class",
      "Constructor",
      "Constant",
      "Enum",
      "Function",
      "Interface",
      "Module",
      "Method",
      "Struct",
      "Variable",
      -- Event
      -- Field
      -- File
      -- Key
      -- Namespace
      -- Null
      -- Number
      -- Object
      -- Operator
      -- Package
      -- Property
      -- String
      -- TypeParameter

    },
    open_automatic = false,
  })
  -- You probably also want to set a keymap to toggle aerial
  vim.keymap.set('n', '<leader>l', '<cmd>AerialToggle!<CR>')
end

pcall(setupAerial)

local function setupGitSigns()
  require('gitsigns').setup {
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      map('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      -- Actions
      map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
      map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
      map('n', '<leader>hS', gs.stage_buffer)
      map('n', '<leader>hu', gs.undo_stage_hunk)
      map('n', '<leader>hR', gs.reset_buffer)
      map('n', '<leader>hp', gs.preview_hunk)
      map('n', '<leader>hb', function() gs.blame_line { full = true } end)
      map('n', '<leader>htb', gs.toggle_current_line_blame)
      map('n', '<leader>hd', gs.diffthis)
      map('n', '<leader>hD', function() gs.diffthis('~') end)
      map('n', '<leader>htd', gs.toggle_deleted)

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
  }
end

if not string.find(vim.api.nvim_buf_get_name(0), "workspace/source") and not string.find(vim.fn.getcwd(), "workspace/source") then
  pcall(setupGitSigns)
end

local function setupToggleTerm()
  require("toggleterm").setup {
    size = function(term)
      if term.direction == "horizontal" then
        return 20
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[†]],
    direction = "float",
  }
  -- vim.cmd [[nnoremap <leader>rw <Cmd>exe "ToggleTermSendCurrentLine " . v:count1<CR>j]]
  -- visual selection doesn't work that well, needs double visual to actually select
  -- vim.cmd [[xnoremap <leader>rw <Cmd>exe "ToggleTermSendVisualSelection " . v:count1<CR>]]
  -- vim.cmd [[nnoremap <silent><leader>gg <Cmd>exe v:count1 . "ToggleTerm direction=vertical"<CR>]]
end

pcall(setupToggleTerm)

local function setupNoice()
  require("noice").setup({
    routes = {
      {
        view = "notify",
        filter = { event = "msg_showmode" },
      },
      -- https://github.com/folke/noice.nvim/discussions/908
      { filter = { event = "msg_show", find = "written" } },
      { filter = { event = "msg_show", find = "yanked" } },
      { filter = { event = "msg_show", find = "%d+L, %d+B" } },
      { filter = { event = "msg_show", find = "; after #%d+" } },
      { filter = { event = "msg_show", find = "; before #%d+" } },
      { filter = { event = "msg_show", find = "%d fewer lines" } },
      { filter = { event = "msg_show", find = "%d more lines" } },
      { filter = { event = "msg_show", find = "<ed" } },
      { filter = { event = "msg_show", find = ">ed" } },
    },
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = false,        -- use a classic bottom cmdline for search
      command_palette = false,      -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false,           -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false,       -- add a border to hover docs and signature help
    },
    -- https://github.com/folke/noice.nvim/issues/226
    views = {
      mini = {
        timeout = 3000,
        size = {
          width = "auto",
          height = "auto",
          max_height = 3,
        },
        win_options = {
          winblend = 0
        },
      },
    },
  })
end

pcall(setupNoice)

-- vim.fn.timer_start(10, function()
--   require('lsp-setup')
-- end)
require('lsp-setup')

local function setupMetals()
  -- Configure completion
  -- https://github.com/scalameta/nvim-metals/discussions/39

  -- local function map(mode, lhs, rhs, opts)
  --   local options = { noremap = true }
  --   if opts then
  --     options = vim.tbl_extend("force", options, opts)
  --   end
  --   api.nvim_set_keymap(mode, lhs, rhs, options)
  -- end

  ----------------------------------
  -- OPTIONS -----------------------
  ----------------------------------
  -- global
  vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }
  -- vim.opt_global.shortmess:remove("F"):append("c")

  -- LSP mappings (commented out cause can't target just scala)
  --map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  --map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  --map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
  --map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
  --map("n", "gds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
  --map("n", "gws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
  --map("n", "<leader>or", ":MetalsOrganizeImports<CR>")
  --map("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
  --map("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
  --map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
  --map("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")
  --map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  --map("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')
  --map("n", "<leader>aa", [[<cmd>lua vim.diagnostic.setqflist()<CR>]]) -- all workspace diagnostics
  --map("n", "<leader>ae", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]]) -- all workspace errors
  --map("n", "<leader>aw", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]]) -- all workspace warnings
  --map("n", "<leader>qf", "<cmd>lua vim.diagnostic.setloclist()<CR>") -- buffer diagnostics only
  --map("n", "[c", "<cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>")
  --map("n", "]c", "<cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>")

  ---- Example mappings for usage with nvim-dap. If you don't use that, you can
  ---- skip these
  --map("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]])
  --map("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]])
  --map("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]])
  --map("n", "<leader>dt", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]])
  --map("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]])
  --map("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]])
  --map("n", "<leader>dl", [[<cmd>lua require"dap".run_last()<CR>]])


  -- local cmp = require'cmp'
  -- cmp.setup({
  --   snippet = {
  --     expand = function(args)
  --       vim.fn["vsnip#anonymous"](args.body)
  --     end,
  --   },
  --   sources = cmp.config.sources({
  --     { name = 'nvim_lsp' },
  --   })
  -- })
  -- cmp.setup.filetype('scala', {
  --   mapping = {
  --     ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })),
  --     ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })),
  --     ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
  --     ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
  --     ['<CR>'] = cmp.mapping.confirm({ select = true }),
  --     ['<C-Space>'] = cmp.mapping.complete(),
  --     ['<C-e>'] = cmp.mapping.abort(),
  --   },
  -- })

  ----------------------------------
  -- LSP Setup ---------------------
  ----------------------------------
  local metals_config = require("metals").bare_config()

  -- Example of settings
  metals_config.settings = {
    inlayHints = {
      hintsInPatternMatch = { enable = true },
      implicitArguments = { enable = true },
      implicitConversions = { enable = true },
      inferredTypes = { enable = true },
      typeParameters = { enable = true },
    },
    excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
  }

  -- *READ THIS*
  -- I *highly* recommend setting statusBarProvider to true, however if you do,
  -- you *have* to have a setting to display this in your statusline or else
  -- you'll not see any messages from metals. There is more info in the help
  -- docs about this
  -- metals_config.init_options.statusBarProvider = "on"

  -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
  metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- Debug settings if you're using nvim-dap
  local dap = require("dap")

  dap.configurations.scala = {
    {
      type = "scala",
      request = "launch",
      name = "RunOrTest",
      metals = {
        runType = "runOrTestFile",
        --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
        cmd = { "bazel" },
        args = { "bazel", "run", "strato/src/main/scala/com/twitter/strato/lsp:bin", "--", "--server" },
      },
    },
    {
      type = "scala",
      request = "launch",
      name = "Test Target",
      metals = {
        runType = "testTarget",
      },
    },
  }

  metals_config.on_attach = function(client, bufnr)
    require("metals").setup_dap()
  end

  -- Autocmd that will actually be in charging of starting the whole thing
  local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    -- NOTE: You may or may not want java included here. You will need it if you
    -- want basic Java support but it may also conflict if you are using
    -- something like nvim-jdtls which also works on a java filetype autocmd.
    pattern = { "scala", "sbt", "java" },
    callback = function()
      vim.opt.cmdheight = 2
      vim.env.JAVA_HOME =
      "/Users/benlu/Library/Caches/Coursier/arc/https/github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.13%252B11/OpenJDK17U-jdk_aarch64_mac_hotspot_17.0.13_11.tar.gz/jdk-17.0.13+11/Contents/Home"
      require("metals").initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
  })
end
if os.getenv("HOME") == "/home/sandbox" then
  setupMetals()
else
  pcall(setupMetals)
end

local function setupFlash()
  vim.keymap.set({ 'n', 'x', 'o' }, '<leader>f', require("flash").jump)
  vim.keymap.set({ 'n', 'x', 'o' }, '<leader>F', require("flash").treesitter)
  vim.keymap.set({ 'o' }, '<leader><leader>f', require("flash").remote)
  vim.keymap.set({ 'x', 'o' }, '<leader><leader>F', require("flash").treesitter_search)
end

pcall(setupFlash)

local function setupConform()
  local conform = require("conform")
  -- breaking change: https://github.com/stevearc/conform.nvim/issues/508#issuecomment-2272706085
  ---@param bufnr integer
  ---@param ... string
  ---@return string
  local function first(bufnr, ...)
    for i = 1, select("#", ...) do
      local formatter = select(i, ...)
      if conform.get_formatter_info(formatter, bufnr).available then
        return formatter
      end
    end
    return select(1, ...)
  end
  local jsformat = function(bufnr)
    return { "biome-check", "eslint_d", first(bufnr, "prettierd", "prettier"), lsp_format = "never" }
  end
  local util = require("conform.util")
  conform.setup({
    formatters = {
      eslint_d = {
        cwd = util.root_file({
          ".eslintrc",
          ".eslintrc.js",
        }),
        require_cwd = true
      },
      cblack = {
        command = "cblack",
        args = {
          "--stdin-filename",
          "$FILENAME",
          "--quiet",
          "-",
        },
        cwd = util.root_file({
          -- https://black.readthedocs.io/en/stable/usage_and_configuration/the_basics.html#configuration-via-a-file
          "pyproject.toml",
        }),
      },
    },
    formatters_by_ft = {
      -- Conform will run multiple formatters sequentially
      python = function(bufnr) return { "isort", first(bufnr, "cblack", "black") } end,
      css = { "biome-check", stop_after_first = true },
      javascript = jsformat,
      javascriptreact = jsformat,
      javascriptflow = jsformat,
      typescript = jsformat,
      typescriptreact = jsformat,
      graphql = { "biome-check", "prettierd", "prettier", stop_after_first = true },
      json = { "biome-check", "prettierd", "prettier", stop_after_first = true },
      jsonc = { "biome-check", "prettierd", "prettier", stop_after_first = true },
      -- npm i -g @bazel/buildifier
      bzl = { "buildifier" },
      kotlin = { "ktfmt" },
      rust = { "rustfmt" },
      cpp = { lsp_format = "never" },
      terraform = { "terraform_fmt" },
      hcl = { "terraform_fmt" },
      go = { "goimports", "gofmt" },
      swift = { "swift" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = {
      timeout_ms = 5000,
      lsp_format = "fallback",
    },
  })
  local function format()
    if vim.fn.exists(':MetalsOrganizeImports') > 0 and vim.bo.filetype == 'scala' then vim.cmd('MetalsOrganizeImports') end
    conform.format({ bufnr = vim.api.nvim_get_current_buf(), timeout_ms = 10000 })
  end

  vim.keymap.set('n', '<leader>j', format)

  -- local bufnr = vim.api.nvim_get_current_buf()
  -- local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
  -- vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
  -- vim.api.nvim_create_autocmd("BufWritePre", {
  --   callback = format,
  --   buffer = bufnr,
  --   group = group,
  --   desc = "[conform] format on save",
  -- })
end
pcall(setupConform)

local typr_success, typr = pcall(require, "typr")
if typr_success then
  typr.setup({})
end

-- Adds an extra second of latency
-- local image_success, image = pcall(require, "image")
-- if image_success then
--   image.setup({
--     integrations = {
--       markdown = {
--         -- floating_windows = true,
--       }
--     },
--     tmux_show_only_in_active_window = true,
--     window_overlap_clear_enabled = true,
--   })
-- end
