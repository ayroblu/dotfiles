local function setupCmp()
  local lspkind = require('lspkind')
  local cmp = require 'cmp'
  cmp.setup({
    formatting = {
      format = lspkind.cmp_format({
        -- mode = 'symbol_text',
        -- maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        -- -- can also be a function to dynamically calculate max width such as
        -- -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
        -- ellipsis_char = '...',    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        -- show_labelDetails = true, -- show labelDetails in menu. Disabled by default
      })
    },
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }),
    mapping = {
      ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })),
      ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })),
      ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<C-space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
    },
  })
end

local function setupLsp()
  require("scrollbar").setup()
  local lspconfig = require('lspconfig')
  local root_pattern = require('lspconfig.util').root_pattern
  local utils = require('utils')
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  require("lspsaga").setup {
    symbol_in_winbar = {
      enable = false,
    },
    lightbulb = {
      enable = false,
      enable_in_insert = false,
    },
  }

  -- ln -s ~/ws/dotfiles/custom_lsp/stratols.lua ~/.local/share/nvim/plugged/nvim-lspconfig/lua/lspconfig/server_configurations/stratols.lua
  if vim.loop.fs_stat(vim.env.HOME ..
        '/.local/share/nvim/plugged/nvim-lspconfig/lua/lspconfig/server_configurations/stratols.lua') then
    lspconfig.stratols.setup {}
  end

  -- ln -s ~/ws/dotfiles/custom_lsp/bazel_lsp.lua ~/.local/share/nvim/plugged/nvim-lspconfig/lua/lspconfig/server_configurations/bazel_lsp.lua
  if vim.loop.fs_stat(vim.env.HOME ..
        '/.local/share/nvim/plugged/nvim-lspconfig/lua/lspconfig/server_configurations/bazel_lsp.lua') then
    lspconfig.bazel_lsp.setup {}
  end
  -- ln -s ~/ws/dotfiles/custom_lsp/llama_ls.lua ~/.vim/plugged/nvim-lspconfig/lua/lspconfig/server_configurations/llama_ls.lua
  if vim.loop.fs_stat(vim.env.HOME ..
        '/.vim/plugged/nvim-lspconfig/lua/lspconfig/server_configurations/llama_ls.lua') then
    lspconfig.llama_ls.setup {}
  end

  lspconfig.sourcekit.setup {
    filetypes = { "swift", "c", "cpp", "objective-c", "objective-cpp", "objc" }
  }

  -- brew install lua-language-server
  lspconfig.lua_ls.setup {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim', 'hs' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          -- library = vim.api.nvim_get_runtime_file("", true),
          -- with nothing: 2s, with this, 3s, with everything: 15s
          library = utils.str_not_contains(vim.api.nvim_get_runtime_file("", true), ".vim"),
          -- -- not sure how to make hammerspoon work
          -- -- https://www.reddit.com/r/neovim/comments/pla7bv/since_everyone_is_getting_more_familiar_with_lua/
          -- library = utils.table_concat(
          --   utils.str_not_contains(vim.api.nvim_get_runtime_file("", true), ".vim"),
          --   { ['/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/'] = true }
          -- ),
          -- https://github.com/neovim/nvim-lspconfig/issues/1700
          checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }
  -- npm i -g bash-language-server
  lspconfig.bashls.setup {}
  -- npm i -g vscode-langservers-extracted
  lspconfig.eslint.setup {
    filetypes = { "javascriptflow", "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro" }
  }
  -- npx flow
  lspconfig.flow.setup {
    cmd = { "npx", "--no-install", "flow", "lsp" },
    filetypes = { "javascriptflow" }
    -- default: filetypes = { "javascript", "javascriptreact", "javascript.jsx" }
    -- cmd = { "web-flow-lsp" }
  }
  -- npx relay-compiler
  -- lspconfig.relay_lsp.setup {
  --   cmd = { "./scripts/relay-for-extension", "lsp" },
  --   root_dir = root_pattern("relay.config.*")
  -- }
  -- npm i -g vscode-langservers-extracted
  lspconfig.html.setup {
    capabilities = capabilities,
  }
  -- npm i -g vscode-langservers-extracted
  lspconfig.jsonls.setup {
    capabilities = capabilities,
  }
  -- npm i -g yaml-language-server
  --lspconfig.yamlls.setup {
  --  capabilities = capabilities,
  --  -- settings = {
  --  --   yaml = {
  --  --     ... -- other settings. note this overrides the lspconfig defaults.
  --  --     schemas = {
  --  --       ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
  --  --       ["../path/relative/to/file.yml"] = "/.github/workflows/*"
  --  --       ["/path/from/root/of/project"] = "/.github/workflows/*"
  --  --     },
  --  --   },
  --  -- }
  --}
  -- npm install -g vim-language-server
  lspconfig.vimls.setup {}
  -- npm install -g graphql-language-service-cli
  lspconfig.graphql.setup {
    root_dir = root_pattern(".graphqlrc.yml")
  }
  -- npm install -g pyright
  lspconfig.pyright.setup {}
  -- npm i -g typescript-language-server
  -- lspconfig.tsserver.setup {
  --   filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  --   root_dir = root_pattern("tsconfig.json"),
  --   capabilities = capabilities,
  -- }

  -- local typescript = require('typescript')
  -- -- :TypescriptRenameFile
  -- typescript.setup({
  --   server = { -- pass options to lspconfig's setup method
  --     filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  --     root_dir = root_pattern("tsconfig.json"),
  --     capabilities = capabilities,
  --     on_attach = function()
  --       vim.keymap.set('n', '<leader>am', typescript.actions.addMissingImports)
  --       vim.keymap.set('n', '<leader>ao', typescript.actions.organizeImports)
  --       vim.keymap.set('n', '<leader>ar', typescript.actions.removeUnused)
  --       vim.keymap.set('n', 'gD', '<cmd>TypescriptGoToSourceDefinition<cr>')
  --       vim.keymap.set('n', '<leader>rf', '<cmd>TypescriptRenameFile<cr>')
  --     end,
  --   },
  -- })
  local api = require("typescript-tools.api")
  require("typescript-tools").setup {
    on_attach = function()
      vim.keymap.set('n', '<leader>am', '<cmd>TSToolsAddMissingImports<cr>')
      vim.keymap.set('n', '<leader>ao', '<cmd>TSToolsOrganizeImports<cr>')
      vim.keymap.set('n', '<leader>ar', '<cmd>TSToolsRemoveUnused<cr>')
      vim.keymap.set('n', 'gD', '<cmd>TSToolsGoToSourceDefinition<cr>')
      vim.keymap.set('n', '<leader>rf', '<cmd>TSToolsRenameFile<cr>')
    end,
    handlers = {
      ["textDocument/publishDiagnostics"] = api.filter_diagnostics(
      -- Ignore 'This may be converted to an async function' diagnostics.
        { 80006 }
      ),
    },
    settings = {
      -- spawn additional tsserver instance to calculate diagnostics on it
      separate_diagnostic_server = true,
      -- "change"|"insert_leave" determine when the client asks the server about diagnostic
      publish_diagnostic_on = "insert_leave",
      -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
      -- "remove_unused_imports"|"organize_imports") -- or string "all"
      -- to include all supported code actions
      -- specify commands exposed as code_actions
      expose_as_code_action = {},
      -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
      -- not exists then standard path resolution strategy is applied
      tsserver_path = nil,
      -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
      -- (see 💅 `styled-components` support section)
      tsserver_plugins = {},
      -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
      -- memory limit in megabytes or "auto"(basically no limit)
      tsserver_max_memory = "auto",
      -- described below
      tsserver_format_options = {},
      tsserver_file_preferences = {
        importModuleSpecifierEnding = 'js',
      },
      -- locale of all tsserver messages, supported locales you can find here:
      -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
      tsserver_locale = "en",
      -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
      complete_function_calls = false,
      include_completions_with_insert_text = true,
      -- CodeLens
      -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
      -- possible values: ("off"|"all"|"implementations_only"|"references_only")
      code_lens = "off",
      -- by default code lenses are displayed on all referencable values and for some of you it can
      -- be too much this option reduce count of them by removing member references from lenses
      disable_member_code_lens = true,
      -- JSXCloseTag
      -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
      -- that maybe have a conflict if enable this feature. )
      jsx_close_tag = {
        enable = false,
        filetypes = { "javascriptreact", "typescriptreact" },
      },
    },
  }

  -- npm i -g vscode-langservers-extracted
  lspconfig.cssls.setup {
    capabilities = capabilities,
  }
  -- npm install -g cssmodules-language-server
  lspconfig.cssmodules_ls.setup {}
  -- rustup component add rust-analyzer
  lspconfig.rust_analyzer.setup {
    -- Server-specific settings. See `:help lspconfig-setup`
    settings = {
      ['rust-analyzer'] = {},
    },
  }

  -- npm install -g svelte-language-server
  lspconfig.svelte.setup {}

  -- Global mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  vim.keymap.set('n', '<leader>ai', vim.diagnostic.open_float)
  vim.keymap.set('n', '[[', vim.diagnostic.goto_prev)
  vim.keymap.set('n', ']]', vim.diagnostic.goto_next)
  vim.keymap.set('n', '<leader>aa', vim.diagnostic.setqflist)
  vim.keymap.set('n', '<leader>ae', '<cmd>lua vim.diagnostic.setqflist({severity = "E"})<cr>')
  vim.keymap.set('n', '<leader>aw', '<cmd>lua vim.diagnostic.setqflist({severity = "W"})<cr>')
  vim.keymap.set('n', '<leader>al', vim.diagnostic.setloclist)

  -- Use LspAttach autocommand to only map the following keys
  -- after the language server attaches to the current buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1131
      -- Use internal formatting for bindings like gq.
      vim.bo[ev.buf].formatexpr = nil

      setupCmp()
      -- Enable completion triggered by <c-x><c-o>
      -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

      -- Buffer local mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local opts = { buffer = ev.buf }
      -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
      vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      -- vim.keymap.set('n', '<leader>ac', vim.lsp.buf.code_action, opts)

      vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")
      vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>Lspsaga code_action<CR>")
      vim.keymap.set("n", "gt", "<cmd>Lspsaga goto_type_definition<CR>")
      vim.keymap.set("n", "<leader>dl", "<cmd>Lspsaga show_line_diagnostics<CR>")
      vim.keymap.set("n", "<leader>dc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")
      vim.keymap.set("n", "<leader>db", "<cmd>Lspsaga show_buf_diagnostics<CR>")
      vim.keymap.set("n", "[[", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
      vim.keymap.set("n", "]]", "<cmd>Lspsaga diagnostic_jump_next<CR>")

      -- -- lspsaga versions: don't want
      -- vim.keymap.set("n", "gr", "<cmd>Lspsaga rename<CR>")
      -- vim.keymap.set("n", "rn", "<cmd>Lspsaga rename ++project<CR>")
      -- vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
      -- vim.keymap.set("n","gd", "<cmd>Lspsaga goto_definition<CR>")
      -- vim.keymap.set("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>")
      --
      -- vim.keymap.set("n", "[E", function()
      --   require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
      -- end)
      -- vim.keymap.set("n", "]E", function()
      --   require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
      -- end)
      --
      -- vim.keymap.set("n","<leader>o", "<cmd>Lspsaga outline<CR>")
      -- vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc ++quiet<CR>")
      -- vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>")
      -- vim.keymap.set("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
      -- vim.keymap.set("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

      -- Floating terminal
      -- vim.keymap.set({"n", "t"}, "<A-d>", "<cmd>Lspsaga term_toggle<CR>")

      -- https://github.com/neovim/neovim/issues/20457#issuecomment-1266782345
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.handlers['textDocument/hover'] = function(_, result, ctx, config)
        config = config or {}
        config.focus_id = ctx.method
        if not (result and result.contents) then
          return
        end
        local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
        markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
        if vim.tbl_isempty(markdown_lines) then
          return
        end
        return vim.lsp.util.open_floating_preview(markdown_lines, 'markdown', config)
      end
      local supported_formatting_clients = Set { "null-ls", "lua_ls", "rust_analyzer", "metals" }
      local function format()
        -- local before = vim.loop.now()
        -- print("before eslint", string.format("%s:%03d", os.date("%H:%M:%S"), vim.loop.now() % 1000))
        -- print("after eslint", string.format("%s:%03d", os.date("%H:%M:%S"), vim.loop.now() % 1000),
        --   vim.loop.now() - before)
        -- vim.cmd "Prettier"
        -- print("after prettier", string.format("%s:%03d", os.date("%H:%M:%S"), vim.loop.now() % 1000),
        --   vim.loop.now() - before)
        if vim.bo.filetype == 'python' then
          if vim.fn.exists(':ALEFix') > 0 then vim.cmd('ALEFix') end
        end
        if vim.fn.exists(':EslintFixAll') > 0 then vim.cmd('EslintFixAll') end
        -- prettier errors on non supported filetypes
        -- if vim.fn.exists(':Prettier') > 0 then vim.cmd("Prettier") end
        vim.lsp.buf.format({
          filter = function(client)
            return supported_formatting_clients[client.name]
          end,
          timeout_ms = 10000,
        })
      end

      vim.keymap.set('n', '<leader>j', format, opts)
      local bufnr = vim.api.nvim_get_current_buf()
      local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
      vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = format,
        buffer = bufnr,
        group = group,
        desc = "[lsp] format on save",
      })
      --   if client.supports_method("textDocument/rangeFormatting") then
      --     vim.keymap.set("x", "<Leader>j", function()
      --       vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      --     end, { buffer = bufnr, desc = "[lsp] format" })
      --   end
    end,
  })
end

pcall(setupLsp)

local function setupPrettier()
  local null_ls = require("null-ls")

  local sources = {
    null_ls.builtins.formatting.prettier.with({
      filetypes = { "javascriptflow", "javascript", "javascriptreact",
        "typescript", "typescriptreact", "vue", "css", "scss", "less", "html",
        "json", "jsonc", "graphql" },
      only_local = "node_modules/.bin",
    })
  }
  ---@diagnostic disable-next-line: redundant-parameter
  null_ls.setup { sources = sources }

  local prettier = require("prettier")

  prettier.setup({
    bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
    filetypes = {
      "css",
      "graphql",
      "javascript",
      "javascriptflow",
      "javascriptreact",
      "json",
      "html",
      "less",
      "scss",
      "typescript",
      "typescriptreact",
    },
  })
end

pcall(setupPrettier)
