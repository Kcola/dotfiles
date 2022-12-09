local config = require("kola.config").get()
local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("null-ls-autocommands", {})

local eslintConfig = config.eslint or {}
local sources = {}

if eslintConfig.args ~= nil then
	sources[#sources + 1] = null_ls.builtins.diagnostics.eslint_d.with({
		extra_args = eslintConfig.args,
	})

	sources[#sources + 1] = null_ls.builtins.code_actions.eslint_d.with({
		extra_args = eslintConfig.args,
	})
end

null_ls.setup({
	debug = true,
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
	sources = sources,
})
