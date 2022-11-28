local set_keymaps = require("kola.lsp.keymaps").set_keymaps
local capabilities = require("kola.lsp.config").get_capabilities()
local register_autocommands = require("kola.lsp.config").register_autocommands

require("lspconfig").omnisharp.setup({
  handlers = {
    ["textDocument/definition"] = require("omnisharp_extended").handler,
  },
  capabilities = capabilities,
  on_attach = function(client)
    if client.name == "omnisharp" then
      client.server_capabilities.document_formatting = false
    end
    set_keymaps()
    register_autocommands()
  end,
})
