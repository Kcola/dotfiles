-- Lua
local cb = require("diffview.config").diffview_callback
local lazy = require("diffview.lazy")
local lib = lazy.require("diffview.lib")

local goto_file = function()
	cb("goto_file")()
	vim.fn.feedkeys("zR")
end

local goto_file_and_close = function()
	goto_file()
	vim.cmd("only")
	vim.cmd("tabonly")
	vim.fn.feedkeys("zR")
end

local load_files_into_buffer = function()
	for _, filetree in pairs(lib.get_current_view().files) do
		for _, value in ipairs(filetree) do
			vim.fn.bufload(vim.fn.bufadd(value.absolute_path))
		end
	end
	P("All change files loaded")
end

require("diffview").setup({
	key_bindings = {
		file_history_panel = { q = "<Cmd>DiffviewClose<CR>" },
		file_panel = {
			q = "<Cmd>DiffviewClose<CR>",
			["<c-d>"] = load_files_into_buffer,
			s = cb("toggle_stage_entry"),
			o = goto_file,
			["<cr>"] = goto_file_and_close,
			["cc"] = "<Cmd>botright Git commit<CR>",
		},
		view = { q = "<Cmd>DiffviewClose<CR>" },
	},
})

function string:firstword()
	return self:match("^([%w]+)")
end

local function view_commit()
	local line = vim.fn.getline(".")
	vim.cmd("DiffviewOpen " .. line:firstword() .. "^!")
end

return {
	view_commit = view_commit,
}
