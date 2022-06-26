Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
if exists('g:started_by_firenvim')
  let g:firenvim_config = {
  \  'localSettings': {
  \    '.*': {
  \      'takeover': 'never',
  \    },
  \  }
  \}
  au BufEnter github.com_*.txt set filetype=markdown
  function RunOnFirenvim(timer)
    "setl guifont=Monaco:h20
    setl guifont=Monaco:h14
    set background=dark
    colorscheme tokyonight
    "setl laststatus=0
  endfunction
  "au CursorHold *.* call RunOnFirenvim()
  au BufEnter *.* call timer_start(100, function("RunOnFirenvim"))
endif

" Plugins for Metals, a language server for Scala
Plug 'nvim-lua/plenary.nvim'
Plug 'scalameta/nvim-metals'

" Plugins to provide code completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'

if 0
  augroup lsp
    autocmd!
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
  augroup end
endif
