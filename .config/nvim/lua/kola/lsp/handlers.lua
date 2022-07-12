local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local utils = require("telescope.utils")

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", width = 100 })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
	vim.lsp.handlers.signature_help,
	{ border = "rounded", width = 100 }
)

local custom_diagnostics_handler = function(err, result, ...)
	P(result)
	vim.lsp.handlers["textDocument/diagnostics"](err, result, ...)
end

-- Telescipe UI select
-- Code actions doesn't have a global handler so we need to roll our sleeves a bit
--------------------------------------------------------------------------------------------------
vim.ui.select = function(_items, opts, on_choice)
	local items = {}
	local low_priority_items = {}

	for _, item in ipairs(_items) do
		local low_priority = string.find(string.lower((item[2] or {}).title or "") or "", "disable")
			and item[2].command == "NULL_LS_CODE_ACTION"

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

return { custom_diagnostics_handler = custom_diagnostics_handler }
