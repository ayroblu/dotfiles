local util = require 'lspconfig.util'

local cmd = { 'nc', 'localhost', 5007 }
-- if vim.fn.has 'nvim-0.8' == 1 then
-- local cmd = vim.lsp.rpc.connect('127.0.0.1', port)
-- end

return {
  default_config = {
    -- cmd = cmd,
    cmd = { 'strato-lsp' },
    filetypes = { 'strato' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
strato-lsp
]],
  },
}
