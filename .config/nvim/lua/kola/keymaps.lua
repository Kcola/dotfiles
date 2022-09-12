local opts = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Editing
map("n", "Y", "y$", opts)
map("i", ",", ",<C-g>u", opts)
map("i", ".", ".<C-g>u", opts)
map("i", "!", "!<C-g>u", opts)
map("i", "?", "?<C-g>u", opts)

-- Navigation
map("n", "H", ":bp<CR>", opts)
map("n", "<C-j>", "<C-W><Down>", opts)
map("n", "<C-h>", "<C-W><Left>", opts)
map("n", "<C-k>", "<C-W><Up>", opts)
map("n", "<C-l>", "<C-W><Right>", opts)
map("i", "<Up>", "<Nop>", opts)
map("i", "<Down>", "<Nop>", opts)
map("i", "<Left>", "<Nop>", opts)
map("i", "<Right>", "<Nop>", opts)
map("n", "L", ":bn<CR>", opts)
map("n", "H", ":bp<CR>", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)
map("n", "H", ":bp<CR>", opts)
map("n", "<C-W>", ":%bd!|e#<CR>", opts)
map("n", "<leader>t", ":NvimTreeToggle<CR>", opts)
vim.keymap.set("n", "<leader>comma", require("harpoon.mark").add_file)
vim.keymap.set("n", "]h", require("harpoon.ui").nav_next)
vim.keymap.set("n", "[h", require("harpoon.ui").nav_prev)
vim.keymap.set("n", "q", function()
	local tabNumber = vim.fn.tabpagenr()
	if tabNumber > 1 then
		vim.cmd("tabclose")
	end
end)

-- Resize with arrows
map("n", "<C-Up>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Git
vim.keymap.set("n", "gs", require("kola.diffview").open)
map("n", "<leader>gh", ":diffget //3<CR>", opts)
map("n", "<leader>gf", ":diffget //2<CR>", opts)
map("n", "<leader>history", "<cmd>DiffviewFileHistory %<cr>", opts)

vim.api.nvim_create_autocmd("FileType", {
	pattern = "git",
	command = "nnoremap <buffer><silent> <cr> <cmd>lua require('kola.diffview').view_commit()<cr>",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "fugitiveblame",
	command = "nnoremap <buffer><silent> <cr> <cmd>lua require('kola.diffview').view_commit()<cr>",
})

vim.keymap.set("n", "<F12>", require("kola.toggleterm").vert_toggle)
vim.keymap.set("n", "<leader>J", require("kola.toggleterm").vert_test)
vim.keymap.set("n", "<leader>E2E", require("kola.toggleterm").vert_e2e_test)
vim.keymap.set("n", "<leader>r", function()
	vim.cmd("luafile %")
end)
