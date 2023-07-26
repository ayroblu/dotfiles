local function setupCmp()
  local cmp = require 'cmp'
  cmp.setup({
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
      ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs( -4), { 'i', 'c' }),
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<C-space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
    },
  })
end

local function setupLsp()
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
  lspconfig.eslint.setup {}
  -- npx flow
  lspconfig.flow.setup {}
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
  local typescript = require('typescript')
  -- :TypescriptRenameFile
  typescript.setup({
    server = { -- pass options to lspconfig's setup method
      filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
      root_dir = root_pattern("tsconfig.json"),
      capabilities = capabilities,
      on_attach = function()
        vim.keymap.set('n', '<leader>am', typescript.actions.addMissingImports)
        vim.keymap.set('n', '<leader>ao', typescript.actions.organizeImports)
        vim.keymap.set('n', '<leader>ar', typescript.actions.removeUnused)
        vim.keymap.set('n', 'gD', '<cmd>TypescriptGoToSourceDefinition<cr>')
        vim.keymap.set('n', '<leader>rf', '<cmd>TypescriptRenameFile<cr>')
      end,
    },
  })
  -- npm i -g vscode-langservers-extracted
  lspconfig.cssls.setup {
    capabilities = capabilities,
  }
  -- npm install -g cssmodules-language-server
  lspconfig.cssmodules_ls.setup {}
  lspconfig.rust_analyzer.setup {
    -- Server-specific settings. See `:help lspconfig-setup`
    settings = {
      ['rust-analyzer'] = {},
    },
  }

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
      local supported_formatting_clients = Set { "null-ls", "lua_ls", "metals" }
      local function format()
        -- local before = vim.loop.now()
        -- print("before eslint", string.format("%s:%03d", os.date("%H:%M:%S"), vim.loop.now() % 1000))
        -- print("after eslint", string.format("%s:%03d", os.date("%H:%M:%S"), vim.loop.now() % 1000),
        --   vim.loop.now() - before)
        -- vim.cmd "Prettier"
        -- print("after prettier", string.format("%s:%03d", os.date("%H:%M:%S"), vim.loop.now() % 1000),
        --   vim.loop.now() - before)
        if vim.fn.exists(':EslintFixAll') > 0 then vim.cmd('EslintFixAll') end
        -- prettier errors on non supported filetypes
        -- if vim.fn.exists(':Prettier') > 0 then vim.cmd("Prettier") end
        vim.lsp.buf.format({
          filter = function(client)
            return supported_formatting_clients[client.name]
          end
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
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "css", "scss", "less",
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
      "javascriptreact",
      "json",
      "less",
      "scss",
      "typescript",
      "typescriptreact",
    },
  })
end

pcall(setupPrettier)
