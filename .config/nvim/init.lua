-- personal json config path
CONFIG_PATH = "$HOME/AppData/Local/nvim/settings.json"

require("kola.globals")
require("kola.plugins")
require("kola.options")
require("kola.keymaps")
require("kola.treesitter")
require("kola.comment")
require("kola.autopairs")
require("kola.diffview")
require("kola.cmp")
require("kola.lualine")
require("kola.formatter")

if vim.env.NVIM_FULL then
	require("neoscroll").setup()
	require("leap").set_default_keymaps(true)
	require("alpha").setup(require("alpha.themes.startify").config)
	require("harpoon").setup({ menu = { width = vim.api.nvim_win_get_width(0) - 70 } })

	require("kola.telescope")
	require("kola.nvimtree")
	require("kola.toggleterm")
	require("kola.gitsigns")
	require("kola.lsp")
	require("kola.dap")
end
