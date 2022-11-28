local set_keymaps = require("kola.lsp.keymaps").set_keymaps
local capabilities = require("kola.lsp.config").get_capabilities()
local register_autocommands = require("kola.lsp.config").register_autocommands

require("lspconfig").sumneko_lua.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "CONFIG_PATH", "P", "NOOP" },
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
  capabilities = capabilities,
  on_attach = function(client)
    if client.name == "sumneko_lua" then
      client.server_capabilities.document_formatting = false
    end
    set_keymaps()
    register_autocommands()
  end,
})
