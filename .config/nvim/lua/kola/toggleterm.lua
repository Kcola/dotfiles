------

local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

local config = require("kola.config") or {}

local get_package_root = require("kola.utils").get_package_root
local get_jest_nearest_test = require("kola.utils").get_jest_nearest_test

toggleterm.setup({
	size = function(term)
		if term.direction == "vertical" then
			return 80
		elseif term.direction == "horizontal" then
			return 15
		end
	end,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
		width = function()
			return math.ceil(vim.o.columns * 0.8)
		end,
		height = function()
			return math.ceil(vim.o.lines * 0.8)
		end,
	},
})

function _G.set_terminal_keymaps()
	local opts = { noremap = true }
	vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<F12>", "<cmd>lua require('kola.toggleterm').vert_toggle()<CR>", opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

local Terminal = require("toggleterm.terminal").Terminal

local M = {}

local lazygit = Terminal:new({
	cmd = "lazygit",
	dir = "git_dir",
	direction = "float",
	float_opts = {
		border = "double",
	},
	close_on_exit = true,
	on_open = function(term)
		if vim.fn.mapcheck("<esc>", "t") ~= "" then
			vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<esc>")
		end
	end,
})

function M._LAZYGIT_TOGGLE()
	lazygit:toggle()
end

local vert = Terminal:new({ direction = "vertical", hidden = true })

local try_close_vert = function()
	if vert:is_open() then
		vert:close()
	end
end

vim.api.nvim_create_autocmd("BufDelete", {
	callback = try_close_vert,
})

function M.vert_toggle()
	vert:toggle()
	vert:resize(80)
end

function M.vert_test()
	local current_buffer = vim.fn.expand("%:p")
	local jest_nearest_test = get_jest_nearest_test()
	local package_root = get_package_root()

	if not jest_nearest_test then
		return
	end

	vert:change_dir(package_root)

	vert:send(
		(config.jest or "node --inspect (npm root)/jest/bin/jest.js -- -t '")
			.. jest_nearest_test
			.. "' -- "
			.. current_buffer
	)
	require("dap").terminate()
	require("kola.dap.node").attach()
end

function M.vert_e2e_test()
	vert:send("cd " .. get_package_root())
	local current_buffer = vim.fn.expand("%:p")
	local env = config.playwright or {}

	local set_env_string = ""
	for key, value in pairs(env) do
		set_env_string = set_env_string .. key .. "=" .. value .. " "
	end

	local command = set_env_string .. "playwright test " .. current_buffer

	vert:send(command)
end

local node = Terminal:new({ cmd = "node", hidden = true })

function M._NODE_TOGGLE()
	node:toggle()
end

local ncdu = Terminal:new({ cmd = "ncdu", hidden = true })

function M._NCDU_TOGGLE()
	ncdu:toggle()
end

local htop = Terminal:new({ cmd = "htop", hidden = true })

function M._HTOP_TOGGLE()
	htop:toggle()
end

local python = Terminal:new({ cmd = "python", hidden = true })

function M._PYTHON_TOGGLE()
	python:toggle()
end

M.try_close_vertical_terminal = try_close_vert

return M
