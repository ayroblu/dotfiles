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
Plug 'mfussenegger/nvim-dap'
Plug 'scalameta/nvim-metals'

" Plugins to provide code completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
