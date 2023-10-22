local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'llama-ls', '--stdio' },
    -- cmd = { 'node', '/Users/blu/ws/vscode-extension-samples/lsp-sample/server/out/server.js', '--stdio' },
    filetypes = { 'text', 'javascript', 'typescript' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
llama-ls is a basic codellama infill tool
]]   ,
  },
}
