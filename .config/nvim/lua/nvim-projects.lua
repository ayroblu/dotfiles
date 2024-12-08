local function setup_bazel_demo()
  -- Note that since this doesn't wait for lspconfig to setup, it outputs a soft error but still works
  local lspconfig = require('lspconfig')
  lspconfig.rust_analyzer.setup {
    settings = {
      ['rust-analyzer'] = {
        check = {
          overrideCommand = { "bazel", "--output_base=/tmp/bazel/rust", "build", "--@rules_rust//rust/settings:error_format=json", "//rust-code/..." },
          enabled = true
        },
      },
    },
  }

  local git_root = vim.b.git_root
  local swiftmodule_dirs = { "JsWrap", "Log", "utils" }
  local utils = require("utils")
  local args = utils.flat_map(swiftmodule_dirs, function(dir)
    return { "-Xswiftc", "-I" .. git_root .. "/.bazel/bin/example-ios-app/" .. dir }
  end)
  lspconfig.sourcekit.setup {
    cmd = { 'sourcekit-lsp', unpack(args) },
  }
end


return {
  setup_bazel_demo = setup_bazel_demo,
  -- setup_bazel_demo = setup_bazel_demo,
}
