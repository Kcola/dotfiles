local telescope = require("telescope.builtin")

local set_keymaps = function()
	vim.keymap.set("n", "K", function()
		vim.api.nvim_command("set eventignore=CursorHold")
		vim.lsp.buf.hover()
		vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
	end, { buffer = 0 })
	if vim.bo.filetype == "cs" then
		vim.keymap.set("n", "gd", require("omnisharp_extended").telescope_lsp_definitions, { buffer = 0 })
	else
		vim.keymap.set("n", "gd", telescope.lsp_definitions, { buffer = 0 })
	end
	vim.keymap.set("n", "gt", telescope.lsp_type_definitions, { buffer = 0 })
	vim.keymap.set("n", "gi", telescope.lsp_implementations, { buffer = 0 })
	vim.keymap.set("n", "gr", telescope.lsp_references, { buffer = 0 })
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = 0 })
	vim.keymap.set("n", "<leader>qf", function()
		vim.lsp.buf.code_action({ only = { "quickfix" } })
	end, { buffer = 0 })
	vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, { buffer = 0 })
	vim.keymap.set("n", "]g", vim.diagnostic.goto_next, { buffer = 0 })
	vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", { buffer = 0 })
end

return { set_keymaps = set_keymaps }
