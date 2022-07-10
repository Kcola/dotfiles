-- Lua
local cb = require("diffview.config").diffview_callback
require("diffview").setup({
	key_bindings = {
		file_history_panel = { q = "<Cmd>DiffviewClose<CR>" },
		file_panel = {
			q = "<Cmd>DiffviewClose<CR>",
			s = cb("toggle_stage_entry"),
			["<cr>"] = function()
				local goto_file = cb("goto_file")
				goto_file()

				vim.cmd("only")
				vim.cmd("tabonly")
				vim.cmd("tabonly")
				vim.fn.feedkeys("zR")
			end,
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
