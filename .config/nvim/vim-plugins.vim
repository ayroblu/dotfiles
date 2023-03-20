Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

Plug 'stevearc/aerial.nvim'

Plug 'MunifTanjim/nui.nvim'
Plug 'folke/noice.nvim'

Plug 'lewis6991/gitsigns.nvim'

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

Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
command! -count=1 TermWebTest TermExec cmd="web test --watch %"
command! -count=1 TermBazelBuild TermExec cmd="ibazel build %"
command! -count=1 TermBazelTest TermExec cmd="ibazel test %"

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'MunifTanjim/prettier.nvim'
"autocmd FileType css,graphql,html,javascript,javascriptreact,json,less,markdown,scss,typescript,typescriptreact,yaml autocmd BufWritePre <buffer> Prettier

" Plugins for Metals, a language server for Scala
Plug 'nvim-lua/plenary.nvim'
Plug 'mfussenegger/nvim-dap'
Plug 'scalameta/nvim-metals'

" Plugins to provide code completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" https://vi.stackexchange.com/questions/38203/nvim-lspconfig-omnifunc-opens-preview-window
set completeopt-=preview

