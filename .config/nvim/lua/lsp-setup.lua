local function is_executable(name)
  -- Determine the OS for the appropriate command
  local command = package.config:sub(1, 1) == "\\" and "where" or "which"
  -- Run the command and capture the result
  local cmd = command .. " " .. name
  local success, exit_code = os.execute(cmd .. " > /dev/null 2>&1")
  -- Return true if the command executed successfully (exit code 0)
  return success and exit_code == 0
end

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
      { name = 'ultisnips' },
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

local function get_git_root()
  local dot_git_path = vim.fn.finddir(".git", ".;")
  -- /path/project/.git/ -> /path/project
  return vim.fn.fnamemodify(dot_git_path, ":p:h:h")
end

local function setupDap()
  local dap, dapui = require("dap"), require("dapui")
  dapui.setup()
  require("nvim-dap-virtual-text").setup()

  -- make breakpoint red circle
  vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })

  vim.keymap.set("n", "<leader>dc", function() dap.continue() end)
  -- vim.keymap.set("n", "<leader>dr", function() dap.repl.toggle() end)
  -- vim.keymap.set("n", "<leader>dK", function() require("dap.ui.widgets").hover() end)
  vim.keymap.set("n", "<leader>dx", function() dap.toggle_breakpoint() end)

  vim.keymap.set("n", "<leader>dso", function() dap.step_over() end)
  vim.keymap.set("n", "<leader>dsi", function() dap.step_into() end)
  vim.keymap.set("n", "<leader>dsr", function() dap.restart() end)
  vim.keymap.set("n", "<leader>dsc", function() dap.run_to_cursor() end)
  vim.keymap.set("n", "<leader>dss", function()
    dap.terminate()
    dapui.close()
  end)
  vim.keymap.set("n", "<leader>dsp", function() dapui.open() end)
  -- very limited support
  vim.keymap.set("n", "<leader>dsb", function() dap.step_back() end)
  vim.keymap.set("n", "<leader>dsv", function() dap.reverse_continue() end)

  -- vim.keymap.set("n", "<leader>dl", function() dap.run_last() end)
  vim.keymap.set("n", "<leader>d?", function() dapui.eval(nil, { enter = true }) end)

  -- auto open debugger
  dap.listeners.before.attach.dapui_config = function() dapui.open() end
  dap.listeners.before.launch.dapui_config = function() dapui.open() end
  dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
  dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
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

  -- ln -s ~/ws/dotfiles/custom_lsp/stratols.lua ~/.local/share/nvim/plugged/nvim-lspconfig/lua/lspconfig/configs/stratols.lua
  if vim.loop.fs_stat(vim.env.HOME ..
        '/.local/share/nvim/plugged/nvim-lspconfig/lua/lspconfig/configs/stratols.lua') then
    lspconfig.stratols.setup {}
  end

  -- ln -s ~/ws/dotfiles/custom_lsp/bazel_lsp.lua ~/.local/share/nvim/plugged/nvim-lspconfig/lua/lspconfig/configs/bazel_lsp.lua
  if vim.loop.fs_stat(vim.env.HOME ..
        '/.local/share/nvim/plugged/nvim-lspconfig/lua/lspconfig/configs/bazel_lsp.lua') then
    lspconfig.bazel_lsp.setup {}
  end
  -- ln -s ~/ws/dotfiles/custom_lsp/llama_ls.lua ~/.vim/plugged/nvim-lspconfig/lua/lspconfig/configs/llama_ls.lua
  if vim.loop.fs_stat(vim.env.HOME ..
        '/.vim/plugged/nvim-lspconfig/lua/lspconfig/configs/llama_ls.lua') then
    lspconfig.llama_ls.setup {}
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
        hint = {
          enable = true,
        }
      },
    },
  }
  -- npm i -g bash-language-server
  lspconfig.bashls.setup {}
  -- brew tap dart-lang/dart && brew install dart
  lspconfig.dartls.setup {}
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
  -- lspconfig.pyright.setup {}

  -- basically better than pyright
  -- brew install basedpyright
  lspconfig.basedpyright.setup {}

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
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
        includeCompletionsForModuleExports = true,
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
  if is_executable("cssmodules-language-server") then
    lspconfig.cssmodules_ls.setup {}
  end

  -- npm install -g @tailwindcss/language-server
  if is_executable("tailwindcss-language-server") then
    lspconfig.tailwindcss.setup {}
  end

  -- rustup component add rust-analyzer
  -- vim.lsp.set_log_level('info')
  -- setup per project
  local git_root = get_git_root()
  local project_name = vim.fn.fnamemodify(git_root, ":t")
  if project_name == "bazel-demo" then
    lspconfig.rust_analyzer.setup {
      settings = {
        ['rust-analyzer'] = {
          check = {
            overrideCommand = { "bazel", "--output_base=/tmp/bazel/rust", "build", "--@rules_rust//rust/settings:error_format=json", "//rust-code/..." },
            enabled = true
          },
        },
      },
    }
  else
    lspconfig.rust_analyzer.setup {}
  end

  lspconfig.ccls.setup {}

  -- brew install kotlin-language-server
  -- lspconfig.kotlin_language_server.setup {}

  -- included by default with xcode dev tools? https://github.com/apple/sourcekit-lsp
  -- setup per project
  if project_name == "bazel-demo" or project_name == "monorepo" then
    local package_modules = { "swiftpkg_swift_snapshot_testing" }
    local package_args = utils.flat_map(package_modules, function(pack)
      return { "-Xswiftc", "-I" .. git_root .. "/.bazel/bin/external/rules_swift_package_manager~~swift_deps~" .. pack }
    end)
    -- .bazel/bin/external/rules_swift_package_manager~~swift_deps~swiftpkg_swift_snapshot_testing
    if vim.fn.getcwd():find("example-ios-app", 1, true) then
      local swiftmodule_dirs = { "JsWrap", "Log", "utils" }
      local args = utils.flat_map(swiftmodule_dirs, function(dir)
        return { "-Xswiftc", "-I" .. git_root .. "/.bazel/bin/example-ios-app/" .. dir }
      end)
      table.move(package_args, 1, #package_args, #args + 1, args)
      lspconfig.sourcekit.setup { cmd = { 'sourcekit-lsp', unpack(args) } }
    elseif vim.fn.getcwd():find("g1-app", 1, true) then
      local swiftmodule_dirs = { "content", "../swift-shared/Log", "../swift-shared/LogUtils", "../swift-shared/Jotai",
        "utils", "maps", "snapshot-testing" }
      local args = utils.flat_map(swiftmodule_dirs, function(dir)
        return { "-Xswiftc", "-I" .. git_root .. "/.bazel/bin/g1-app/" .. dir }
      end)
      table.move(package_args, 1, #package_args, #args + 1, args)
      -- print(vim.inspect(args))
      -- tests run in macOS mode
      if vim.fn.expand('%:t'):match("Tests.swift") then
        lspconfig.sourcekit.setup { cmd = { 'sourcekit-lsp', unpack(args) } }
      else
        lspconfig.sourcekit.setup { cmd = utils.concat({ 'sourcekit-lsp', unpack(args) }, {
          -- "-Xswiftc", "-sdk",
          -- "-Xswiftc", "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk",
          -- "-Xswiftc", "-target",
          -- "-Xswiftc", "arm64-apple-ios18.4",

          -- simulator
          "-Xswiftc", "-sdk",
          "-Xswiftc", "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk",
          "-Xswiftc", "-target",
          "-Xswiftc", "arm64-apple-ios18.4-simulator",
        }) }
      end
    elseif vim.fn.getcwd():find("card-wallet-app", 1, true) then
      -- local swiftmodule_dirs = { "LogUtils", "Log", "Jotai", "SwiftUIUtils" }
      -- local args = utils.flat_map(swiftmodule_dirs, function(dir)
      --   return { "-Xswiftc", "-I" .. git_root .. "/.bazel/bin/swift-shared/" .. dir }
      -- end)
      -- table.move(package_args, 1, #package_args, #args + 1, args)
      -- lspconfig.sourcekit.setup { cmd = { 'sourcekit-lsp', unpack(args) } }

      lspconfig.sourcekit.setup {}

      -- if vim.fn.expand('%:t'):match("Tests.swift") then
      --   lspconfig.sourcekit.setup { cmd = { 'sourcekit-lsp', unpack(args) } }
      -- else
      -- lspconfig.sourcekit.setup { cmd = utils.concat({ 'sourcekit-lsp' }, {
      --   -- "-Xswiftc", "-sdk",
      --   -- "-Xswiftc", "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk",
      --   -- "-Xswiftc", "-target",
      --   -- "-Xswiftc", "arm64-apple-ios18.4",

      --   -- simulator
      --   "-Xswiftc", "-sdk",
      --   "-Xswiftc", "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk",
      --   "-Xswiftc", "-target",
      --   "-Xswiftc", "arm64-apple-ios18.4-simulator",
      -- }) }
      -- end
    else
      lspconfig.sourcekit.setup { cmd = { 'sourcekit-lsp', unpack(package_args) } }
    end
  else
    lspconfig.sourcekit.setup {}
  end

  -- npm install -g svelte-language-server
  lspconfig.svelte.setup {}

  -- go install golang.org/x/tools/gopls@latest
  lspconfig.gopls.setup {
    on_attach = function(client, bufnr)
      -- print(vim.inspect(client.server_capabilities))
      vim.keymap.set('n', '<leader>ag', function()
        local uri = vim.uri_from_bufnr(bufnr)
        client:exec_cmd({ command = "gopls.gc_details", arguments = { uri } }, { bufnr = bufnr })
      end)
      vim.api.nvim_buf_create_user_command(bufnr, "GoTest", function(opts)
        local uri = vim.uri_from_bufnr(bufnr)
        client:exec_cmd({ command = "gopls.run_tests", arguments = { { URI = uri, Tests = opts.fargs } } },
          { bufnr = bufnr },
          function(err, result, ctx)
            if err then
              print(err)
              return
            end
            if result then
              print(result)
            end
          end)
      end, { nargs = '*' })
    end,
    settings = {
      gopls = {
        analyses = {
          unusedvariable = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    }
  }
  require('dap-go').setup {}
  -- https://github.com/go-delve/delve/tree/master/Documentation/installation
  -- ensure: go install github.com/go-delve/delve/cmd/dlv@latest
  -- sudo /usr/sbin/DevToolsSecurity -enable
  -- sudo dscl . append /Groups/_developer GroupMembership $(whoami)
  vim.keymap.set("n", "<leader>dt", function() require("dap-go").debug_test() end)
  vim.keymap.set("n", "<leader><leader>dt", function() require("dap-go").debug_last_test() end)

  setupDap()

  -- curl -fLO https://github.com/redhat-developer/vscode-xml/releases/download/0.27.1/lemminx-osx-aarch_64.zip
  -- unzip lemminx-osx-aarch_64.zip
  -- mv lemminx-osx-aarch_64 ~/bin/lemminx
  -- xattr -d com.apple.quarantine ~/bin/lemminx
  lspconfig.lemminx.setup {}

  -- brew install terraform-ls
  lspconfig.terraformls.setup {}

  -- Global mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  vim.keymap.set('n', '<leader>ai', vim.diagnostic.open_float)
  -- vim.keymap.set('n', '[[', vim.diagnostic.goto_prev)
  -- vim.keymap.set('n', ']]', vim.diagnostic.goto_next)
  vim.keymap.set('n', '[[', function() vim.diagnostic.jump({ count = -1 }) end)
  vim.keymap.set('n', ']]', function() vim.diagnostic.jump({ count = 1 }) end)
  vim.diagnostic.config({
    jump = { float = true },
    virtual_text = true,
  })
  vim.keymap.set('n', '<leader>aa', vim.diagnostic.setqflist)
  vim.keymap.set('n', '<leader>ae', '<cmd>lua vim.diagnostic.setqflist({severity = "E"})<cr>')
  vim.keymap.set('n', '<leader>aw', '<cmd>lua vim.diagnostic.setqflist({severity = "W"})<cr>')
  vim.keymap.set('n', '<leader>al', vim.diagnostic.setloclist)

  vim.keymap.set('n', '<leader>K', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)

  -- Use LspAttach autocommand to only map the following keys
  -- after the language server attaches to the current buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/1131
      -- Use internal formatting for bindings like gq.
      -- vim.bo[ev.buf].formatexpr = nil

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

      vim.keymap.set("n", "gi", "<cmd>Lspsaga finder imp<CR>", opts)
      vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")
      vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>Lspsaga code_action<CR>")
      vim.keymap.set("n", "gT", "<cmd>Lspsaga goto_type_definition<CR>")
      -- vim.keymap.set("n", "<leader>dl", "<cmd>Lspsaga show_line_diagnostics<CR>")
      -- vim.keymap.set("n", "<leader>dc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")
      -- vim.keymap.set("n", "<leader>db", "<cmd>Lspsaga show_buf_diagnostics<CR>")
      vim.keymap.set("n", "[[", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
      vim.keymap.set("n", "]]", "<cmd>Lspsaga diagnostic_jump_next<CR>")

      vim.keymap.set('n', 'gv', ':vsplit | lua vim.lsp.buf.definition()<CR>', opts)

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
      -- vim.lsp.handlers['textDocument/hover'] = function(_, result, ctx, config)
      --   config = config or {}
      --   config.focus_id = ctx.method
      --   if not (result and result.contents) then
      --     return
      --   end
      --   local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
      --   markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
      --   if vim.tbl_isempty(markdown_lines) then
      --     return
      --   end
      --   return vim.lsp.util.open_floating_preview(markdown_lines, 'markdown', config)
      -- end

      --   if client.supports_method("textDocument/rangeFormatting") then
      --     vim.keymap.set("x", "<Leader>j", function()
      --       vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      --     end, { buffer = bufnr, desc = "[lsp] format" })
      --   end
    end,
  })
end

local function show_popup_under_cursor(content)
  local opts = {
    border = "rounded", -- Border style: "rounded", "double", "single", etc.
    focus_id = "test-1",
  }
  vim.lsp.util.open_floating_preview(content, "plaintext", opts)
end

-- Call the function with some sample content
local function doit()
  show_popup_under_cursor({ "This is a hover popup!", "It works under your cursor." })
end
vim.keymap.set("n", "<leader>L", doit)


pcall(setupLsp)
