local util = require 'lspconfig.util'

-- local port = '5007'
-- local cmd = { 'nc', 'localhost', port }
-- if vim.fn.has 'nvim-0.8' == 1 then
--   cmd = vim.lsp.rpc.connect('127.0.0.1', port)
-- end

return {
  default_config = {
    cmd = { 'strato-lsp' },
    -- cmd = cmd,
    filetypes = { 'strato' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
strato-lsp
]],
  },
}
