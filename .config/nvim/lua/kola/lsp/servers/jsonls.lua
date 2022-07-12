local default_schemas = nil
local status_ok, jsonls_settings = pcall(require, "nlspsettings.jsonls")
if status_ok then
	default_schemas = jsonls_settings.get_default_schemas()
end

local schemas = {
	{
		description = "JSON Schema",
		fileMatch = {
			"*.schema.json",
		},
		url = "https://json-schema.org/draft/2020-12/schema",
	},
	{
		description = "TypeScript compiler configuration file",
		fileMatch = {
			"tsconfig.json",
			"tsconfig.*.json",
		},
		url = "https://json.schemastore.org/tsconfig.json",
	},
	{
		description = "ESLint config",
		fileMatch = {
			".eslintrc.json",
			".eslintrc",
		},
		url = "https://json.schemastore.org/eslintrc.json",
	},
	{
		description = "Packer template JSON configuration",
		fileMatch = {
			"packer.json",
		},
		url = "https://json.schemastore.org/packer.json",
	},
	{
		description = "NPM configuration file",
		fileMatch = {
			"package.json",
		},
		url = "https://json.schemastore.org/package.json",
	},
}

local function extend(tab1, tab2)
	for _, value in ipairs(tab2 or {}) do
		table.insert(tab1, value)
	end
	return tab1
end

local extended_schemas = extend(schemas, default_schemas)

local lspconfig = require("lspconfig")
local set_keymaps = require("kola.lsp.keymaps").set_keymaps
local capabilities = require("kola.lsp.config").get_capabilities()

lspconfig.jsonls.setup({
	capabilities = capabilities,
	on_attach = function(client)
		if client.name == "tsserver" then
			client.resolved_capabilities.document_formatting = false
		end
		if client.name == "jsonls" then
			client.resolved_capabilities.document_formatting = false
		end
		set_keymaps()
	end,
	settings = {
		json = {
			schemas = extended_schemas,
		},
	},
	setup = {
		commands = {
			Format = {
				function()
					vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
				end,
			},
		},
	},
})
