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
    autocmd FileType scala nnoremap <buffer><silent> <leader>ao  :MetalsOrganizeImports<CR>
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
require('plugins-setup')
EOF
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
" https://github.com/neovim/neovim/issues/28132
" set foldexpr="v:lua.vim.treesitter.foldexpr()"
"https://www.reddit.com/r/neovim/comments/seq0q1/plugin_request_autofolding_file_imports_using/
" set foldexpr=v:lnum==1?'>1':getline(v:lnum)=~'import'?1:nvim_treesitter#foldexpr()

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

