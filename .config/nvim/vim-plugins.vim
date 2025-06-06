Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
function! LoadTreesitter()
  if !b:is_minified_file
    exec 'TSBufEnable highlight'
  endif
endfunction
augroup minifiedTreesitterLoad
  autocmd!
  autocmd FileType * call LoadTreesitter()
augroup END

Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" Plug 'rrethy/nvim-treesitter-textsubjects'

Plug 'chrisgrieser/nvim-various-textobjs'

Plug 'onsails/lspkind.nvim'

Plug 'Dkendal/nvim-treeclimber'

Plug 'JoosepAlviste/nvim-ts-context-commentstring'

Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

Plug 'stevearc/aerial.nvim'

Plug 'folke/flash.nvim'
autocmd ColorScheme * highlight FlashLabel guifg=#ffffff guibg=#ff0000

Plug 'kevinhwang91/promise-async'
Plug 'kevinhwang91/nvim-ufo'

Plug 'petertriho/nvim-scrollbar'

Plug 'MunifTanjim/nui.nvim'
" Performance issue maybe?
" Plug 'folke/noice.nvim'

Plug 'lewis6991/gitsigns.nvim'

Plug 'nvim-tree/nvim-web-devicons'
Plug 'glepnir/lspsaga.nvim'

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

Plug 'stevearc/oil.nvim'

" lsp
Plug 'stevearc/conform.nvim'
Plug 'neovim/nvim-lspconfig'
" Plug 'stevearc/flow-coverage.nvim'
"autocmd FileType css,graphql,html,javascript,javascriptreact,json,less,markdown,scss,typescript,typescriptreact,yaml autocmd BufWritePre <buffer> Prettier
" Plug 'jose-elias-alvarez/typescript.nvim'
Plug 'pmizio/typescript-tools.nvim'

" Plugins for Metals, a language server for Scala
Plug 'nvim-lua/plenary.nvim'
Plug 'mfussenegger/nvim-dap'
Plug 'scalameta/nvim-metals'

" dap setup
Plug 'leoluz/nvim-dap-go'
Plug 'nvim-neotest/nvim-nio'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'

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

