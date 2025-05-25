# <leader>? for this help
## To improve
cfdo ...
norm command
tree sitter text objects
- select function
editor commands
- resolve ternary to true or false side
- cit - convert to ternary, also (cic)
- ciai - convert to arrow inline, also (ciab, cif)
- <, - move expressions between commas (also >,)

## General
:InspectTree - tree sitter ast
align: <visual> ga=
Close all buffers: :bufdo bd
Spelling: <leader>s ]s [s ]S [S
<insert> <c-u> to undo in insert mode
<leader>o to open the tagbar
<leader>f<char> easy motion find (F for reverse)
<leader>u to open links under the cursor
:BufDelete to interactively close buffers
:BufOnly for closing all except current buffer
:Bdi for closing all non visible buffers
<leader>yp for yanking the path

## Undo Tree
g-, g+ to jump between undo tree branches
:earlier 5s - 5m, 5h, 5d, also :later

## netrw:
gn for changing root
<c-s-6> for returning to writing buffer

## fzf:
<leader>t to fzf show files
<leader><leader>t to fzf show tags
<leader><leader>r to fzf show tags in current buffer
`:Rg query` to search with ripgrep

## repl + code execution:
<leader>re: Run lines and output (selection or whole file)
<leader>rw: Run repl and push lines (selection or current line)
<leader>rq: Close repl
<leader>rp: Select pane target

## vim-exchange
cxc to cancel

## Abolish
crs - coerce_snake_case
crm - MixedCase
crc - camelCase
cru - UPPER_CASE
cr- - dash-case
cr. - dot.case
cr<space> - space case
crt - Title Case
:%Subvert/facilit{y,ies}/building{,s}/g

## lsp
[[ for previous error
]] for next error
gd go definition
gy go type definition
gi go implementation
gr go references
K Show docs
<leader>ac action (like imports)
