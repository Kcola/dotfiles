require("nvim-lsp-installer").setup({})
require("kola.lsp.servers.null-ls")
require("kola.lsp.servers.jsonls")
require("kola.lsp.servers.tsserver")
require("kola.lsp.servers.sumneko")
require("kola.lsp.handlers")

local load_changed_files_into_memory = function()
	local handle = io.popen("git ls-files -m; git diff --name-only --cached;")
	if handle then
		vim.schedule(function()
			local out = handle:read("*a")
			handle:close()
			local changed_files = out:split("\n")
			for _, path in ipairs(changed_files) do
				vim.fn.bufload(vim.fn.bufadd(path))
			end

			P("Changed files loaded into memory")
		end)
	end
end

vim.api.nvim_create_autocmd("VimEnter", {
	callback = load_changed_files_into_memory,
})
