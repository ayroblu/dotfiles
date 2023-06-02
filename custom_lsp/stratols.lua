local util = require 'lspconfig.util'

return {
  default_config = {
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
