vim.o.updatetime = 250

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
		width = 100,
	},
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local M = {}

M.register_autocommands = function()
	vim.api.nvim_create_augroup("lsp_autocommands", {
		clear = false,
	})
	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		group = "lsp_autocommands",
		buffer = bufnr,
		callback = function()
			vim.diagnostic.open_float(nil, { focus = false })
		end,
	})
end

-- capabilities
M.get_capabilities = function()
  local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
	return capabilities
end

return M
