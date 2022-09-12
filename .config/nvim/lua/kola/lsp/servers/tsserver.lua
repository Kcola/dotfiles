local lspconfig = require("lspconfig")
local set_keymaps = require("kola.lsp.keymaps").set_keymaps
local register_autocommands = require("kola.lsp.config").register_autocommands
local capabilities = require("kola.lsp.config").get_capabilities()

lspconfig.tsserver.setup({
	cmd = {
		"typescript-language-server.cmd",
		"--stdio",
		"--tsserver-path",
		"/Users/kolacampell/.nvm/versions/node/v14.17.4/lib/node_modules/typescript/lib/",
	},
	capabilities = capabilities,
	on_attach = function(client)
		local ts_utils = require("nvim-lsp-ts-utils")

		ts_utils.setup({
			enable_import_on_completion = true,
			filter_out_diagnostics_by_severity = {},
			filter_out_diagnostics_by_code = {},
			-- update imports on file move
			update_imports_on_move = false,
			require_confirmation_on_move = true,
			always_organize_imports = false,
		})

		-- required to fix code action ranges and filter diagnostics
		ts_utils.setup_client(client)

		if client.name == "tsserver" then
			client.resolved_capabilities.document_formatting = false
		end

		local opts = { noremap = true, silent = true }
		local map = vim.api.nvim_set_keymap
		map("n", "<leader>gr", ":TSLspRenameFile<CR>", opts)
		map("n", "<leader>gi", ":TSLspImportAll<CR>", opts)
		set_keymaps()
		register_autocommands()
	end,
})
