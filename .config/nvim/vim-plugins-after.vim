lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = {
    "javascript", "typescript", "tsx", "graphql", "markdown", "vim", "lua",
    "scala"
  },

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,

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

-- Configure completion
-- local cmp = require'cmp'
-- cmp.setup({
--   snippet = {
--     expand = function(args)
--       vim.fn["vsnip#anonymous"](args.body)
--     end,
--   },
--   mapping = {
--     ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })),
--     ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })),
--     ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
--     ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
--     ['<CR>'] = cmp.mapping.confirm({ select = true }),
--   },
--   sources = cmp.config.sources({
--     { name = 'nvim_lsp' },
--   })
-- })
--
-- -- Configure Metals
-- metals_config = require("metals").bare_config()
-- metals_config.settings = {
--   showImplicitArguments = true,
--   showImplicitConversionsAndClasses = true,
--   showInferredType = true,
-- }
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- metals_config.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
EOF
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

function! EnableScala()
  autocmd FileType scala nnoremap <silent> <C-]>       <cmd>lua vim.lsp.buf.definition()<CR>
  autocmd FileType scala nnoremap <silent> K           <cmd>lua vim.lsp.buf.hover()<CR>
  autocmd FileType scala nnoremap <silent> gi          <cmd>lua vim.lsp.buf.implementation()<CR>
  autocmd FileType scala nnoremap <silent> gr          <cmd>lua vim.lsp.buf.references()<CR>
  autocmd FileType scala nnoremap <silent> <C-s>       <cmd>lua vim.lsp.buf.document_symbol()<CR>
  autocmd FileType scala nnoremap <silent> <C-p>       <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
  autocmd FileType scala nnoremap <silent> <leader>r   <cmd>lua vim.lsp.buf.rename()<CR>
  autocmd FileType scala nnoremap <silent> <leader>f   <cmd>lua vim.lsp.buf.formatting()<CR>
  autocmd FileType scala nnoremap <silent> <leader>a   <cmd>lua vim.lsp.buf.code_action()<CR>
  autocmd FileType scala nnoremap <silent> <leader>w   <cmd>lua require'metals'.hover_worksheet()<CR>
  autocmd FileType scala nnoremap <silent> [c          <cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>
  autocmd FileType scala nnoremap <silent> ]c          <cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>
  autocmd FileType scala setl shortmess+=c
  autocmd FileType scala setl shortmess-=F

  autocmd FileType scala,sbt lua require("metals").initialize_or_attach(metals_config)
  autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc

  lua <<EOF
  -- Configure completion
  local cmp = require'cmp'
  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = {
      ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })),
      ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })),
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    })
  })

  -- Configure Metals
  metals_config = require("metals").bare_config()
  metals_config.settings = {
    showImplicitArguments = true,
    showImplicitConversionsAndClasses = true,
    showInferredType = true,
  }
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  metals_config.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
EOF
endfunction

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

