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

-- Resize with arrows
map("n", "<C-Up>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Git
-- map("n", "gs", ":vertical Git<CR><C-W>H:vertical resize 100<CR>", opts)
-- map("n", "gs", "<cmd>lua require('kola._toggleterm')._LAZYGIT_TOGGLE()<CR>", opts)
-- map("n", "gs", "<cmd>Telescope git_status<CR>", opts)
map("n", "gs", "<cmd>DiffviewOpen<CR> <cmd>lua require('kola.nvimtree').resizeToFit()<CR>", opts)
map("n", "<leader>gh", ":diffget //3<CR>", opts)
map("n", "<leader>gf", ":diffget //2<CR>", opts)
map("n", "<leader>h", "<cmd>DiffviewFileHistory %<cr>", opts)

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
