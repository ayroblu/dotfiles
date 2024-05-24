local util = require 'lspconfig.util'

-- curl -fL https://github.com/cameron-martin/bazel-lsp/releases/download/v0.6.0/bazel-lsp-0.6.0-osx-arm64 -o bazel-lsp
return {
  default_config = {
    cmd = { 'bazel-lsp' },
    filetypes = { 'bzl' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
bazel-lsp
]],
  },
}
