if $HOME ==# '/home/sandbox'
  augroup metals_lsp
    autocmd!
    autocmd FileType scala nnoremap <buffer><silent> <C-]>       <cmd>lua vim.lsp.buf.definition()<CR>
    autocmd FileType scala nnoremap <buffer><silent> gd          <cmd>lua vim.lsp.buf.definition()<CR>
    autocmd FileType scala nnoremap <buffer><silent> K           <cmd>lua vim.lsp.buf.hover()<CR>
    autocmd FileType scala nnoremap <buffer><silent> gi          <cmd>lua vim.lsp.buf.implementation()<CR>
    autocmd FileType scala nnoremap <buffer><silent> gr          <cmd>lua vim.lsp.buf.references()<CR>
    autocmd FileType scala nnoremap <buffer><silent> gsd         <cmd>lua vim.lsp.buf.document_symbol()<CR>
    autocmd FileType scala nnoremap <buffer><silent> gsw         <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>or  :MetalsOrganizeImports<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>cl  <cmd>lua vim.lsp.codelens.run()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>sh  <cmd>lua vim.lsp.signature_help()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>rn  <cmd>lua vim.lsp.buf.rename()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>j   <cmd>lua vim.lsp.buf.formatting()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>ac  <cmd>lua vim.lsp.buf.code_action()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>ws  <cmd>lua require'metals'.hover_worksheet()<CR>
    " All workspace diagnostics, errors, or warnings only
    autocmd FileType scala nnoremap <buffer><silent> <leader>aa  <cmd>lua vim.diagnostic.setqflist()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>ae  <cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>aw  <cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>
    " buffer diagnostics only
    autocmd FileType scala nnoremap <buffer><silent> <leader>qf  <cmd>lua vim.diagnostic.loclist()<CR>
    autocmd FileType scala nnoremap <buffer><silent> [[          <cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>
    autocmd FileType scala nnoremap <buffer><silent> ]]          <cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>

    " Example mappings for usage with nvim-dap. If you don't use that, you can skip these
    autocmd FileType scala nnoremap <buffer><silent> <leader>dc  <cmd>lua require'dap'.continue()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>dr  <cmd>lua require'dap'.repl.toggle()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>dK  <cmd>lua require'dap.ui.widgets'.hover()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>dt  <cmd>lua require'dap'.toggle_breakpoint()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>dso <cmd>lua require'dap'.step_over()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>dsi <cmd>lua require'dap'.step_into()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>dl  <cmd>lua require'dap'.run_last()<CR>

    autocmd FileType scala setl shortmess+=c
    autocmd FileType scala setl shortmess-=F

    autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc
  augroup end
else
  augroup metals_lsp
    autocmd FileType scala setl shortmess+=c
    autocmd FileType scala setl shortmess-=F
    autocmd FileType scala nnoremap <buffer><silent> <leader>or  :MetalsOrganizeImports<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>dc  <cmd>lua require'dap'.continue()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>dr  <cmd>lua require'dap'.repl.toggle()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>dK  <cmd>lua require'dap.ui.widgets'.hover()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>dt  <cmd>lua require'dap'.toggle_breakpoint()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>dso <cmd>lua require'dap'.step_over()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>dsi <cmd>lua require'dap'.step_into()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>dl  <cmd>lua require'dap'.run_last()<CR>
    autocmd FileType scala nnoremap <buffer><silent> <leader>ws  <cmd>lua require'metals'.hover_worksheet()<CR>
  augroup end
endif

lua <<EOF
function setupTreeSitter()
  require'nvim-treesitter.configs'.setup {
    -- One of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = {
      "javascript", "typescript", "tsx", "graphql", "vim", "lua", "sql",
      "scala", "python", "markdown", "markdown_inline", "css", "bash",
      "swift", "regex"
    },

    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = false,

    -- List of parsers to ignore installing
    ignore_install = {},

    highlight = {
      -- `false` will disable the whole extension
      enable = true,

      -- list of language that will be disabled
      disable = {},

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
  }
end
pcall(setupTreeSitter)

function setupAerial()
  require('aerial').setup({
    -- optionally use on_attach to set keymaps when aerial has attached to a buffer
    on_attach = function(bufnr)
      -- Jump forwards/backwards with '{' and '}'
      vim.keymap.set('n', '<Leader>{', '<cmd>AerialPrev<CR>', {buffer = bufnr})
      vim.keymap.set('n', '<Leader>}', '<cmd>AerialNext<CR>', {buffer = bufnr})
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

function setupGitSigns()
  require('gitsigns').setup{
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
      end, {expr=true})

      map('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, {expr=true})

      -- Actions
      map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
      map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
      map('n', '<leader>hS', gs.stage_buffer)
      map('n', '<leader>hu', gs.undo_stage_hunk)
      map('n', '<leader>hR', gs.reset_buffer)
      map('n', '<leader>hp', gs.preview_hunk)
      map('n', '<leader>hb', function() gs.blame_line{full=true} end)
      map('n', '<leader>htb', gs.toggle_current_line_blame)
      map('n', '<leader>hd', gs.diffthis)
      map('n', '<leader>hD', function() gs.diffthis('~') end)
      map('n', '<leader>htd', gs.toggle_deleted)

      -- Text object
      map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
  }
end
pcall(setupGitSigns)

function setupToggleTerm()
  require("toggleterm").setup{
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

function setupNoice()
  require("noice").setup({
    routes = {
      {
        view = "notify",
        filter = { event = "msg_showmode" },
      },
    },
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = {
        -- asked to do this because textDocument/hover override in lsp-setup
        enabled = false,
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    -- https://github.com/folke/noice.nvim/issues/226
    views = {
      mini = {
        win_options = {
          winblend = 0
        }
      },
    },
  })
end
pcall(setupNoice)

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
    showImplicitArguments = true,
    showImplicitConversionsAndClasses = true,
    showInferredType = true,
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
EOF
set foldmethod=expr
"set foldexpr=nvim_treesitter#foldexpr()
"https://www.reddit.com/r/neovim/comments/seq0q1/plugin_request_autofolding_file_imports_using/
set foldexpr=v:lnum==1?'>1':getline(v:lnum)=~'import'?1:nvim_treesitter#foldexpr()

"function! GetLongestLineLength()
"  let maxlength   = 0
"  let linenumber  = 1
"  while linenumber <= line("$")
"    exe ":".linenumber
"    let linelength  = virtcol("$")
"    if maxlength < linelength
"      let maxlength = linelength
"    endif
"    let linenumber  = linenumber+1
"  endwhile
"endfunction
"
"autocmd BufReadPost * if GetLongestLineLength() > 5000 | execute('TSBufDisable highlight') | endif
" autocmd BufReadPost * if getfsize(@%) > 100000 | execute('TSBufDisable highlight') | endif

