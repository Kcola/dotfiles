local telescope = require("telescope.builtin")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local utils = require("telescope.utils")

function _G.put(...)
	local objects = {}
	for i = 1, select("#", ...) do
		local v = select(i, ...)
		table.insert(objects, vim.inspect(v))
	end

	print(table.concat(objects, "\n"))
	return ...
end

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

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", width = 100 })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
	vim.lsp.handlers.signature_help,
	{ border = "rounded", width = 100 }
)
-- UI select
--------------------------------------------------------------------------------------------------
vim.ui.select = function(_items, opts, on_choice)
	local items = {}
	local low_priority_items = {}

	for idx, item in ipairs(_items) do
		local low_priority = string.find(string.lower((item[2] or {}).title or "") or "", "disable")

		if low_priority then
			table.insert(low_priority_items, item)
		else
			table.insert(items, item)
		end
	end

	items = vim.list_extend(items, low_priority_items)

	local topts = require("telescope.themes").get_cursor({
		initial_mode = "normal",
	})
	opts = opts or {}
	local prompt = vim.F.if_nil(opts.prompt, "Select one of")
	if prompt:sub(-1, -1) == ":" then
		prompt = prompt:sub(1, -2)
	end
	opts.format_item = vim.F.if_nil(opts.format_item, function(e)
		return tostring(e)
	end)

	local sopts = {}
	local indexed_items, widths = vim.F.if_nil(sopts.make_indexed, function(items_)
		local indexed_items = {}
		for idx, item in ipairs(items_) do
			table.insert(indexed_items, { idx = idx, text = item })
		end
		return indexed_items
	end)(items)
	local displayer = vim.F.if_nil(sopts.make_displayer, function() end)(widths)
	local make_display = vim.F.if_nil(sopts.make_display, function(_)
		return function(e)
			local x, _ = opts.format_item(e.value.text)
			return x
		end
	end)(displayer)
	local make_ordinal = vim.F.if_nil(sopts.make_ordinal, function(e)
		return opts.format_item(e.text)
	end)

	pickers.new(topts, {
		prompt_title = prompt,
		finder = finders.new_table({
			results = indexed_items,
			entry_maker = function(e)
				return {
					value = e,
					display = make_display,
					ordinal = make_ordinal(e),
				}
			end,
		}),
		attach_mappings = function(prompt_bufnr)
			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
				if selection == nil then
					utils.__warn_no_selection("ui-select")
					return
				end
				actions.close(prompt_bufnr)
				on_choice(selection.value.text, selection.value.idx)
			end)
			return true
		end,
		sorter = conf.generic_sorter(topts),
	}):find()
end

-- keymaps
--------------------------------------------------------------------------------------------------
local M = {}

M.set_keymaps = function()
	vim.keymap.set("n", "K", function()
		vim.api.nvim_command("set eventignore=CursorHold")
		vim.lsp.buf.hover()
		vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
	end, { buffer = 0 })
	vim.keymap.set("n", "gd", telescope.lsp_definitions, { buffer = 0 })
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

M.register_autocommands = function(client)
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
	local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
	return capabilities
end

return M
