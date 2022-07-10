return require("packer").startup(function(use)
	-- My plugins here
	use("wbthomason/packer.nvim")
	use("nvim-lua/plenary.nvim")
	use({
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	})
	use({
		"goolord/alpha-nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	})

	-- LSP
	use({
		"williamboman/nvim-lsp-installer",
		"neovim/nvim-lspconfig",
	})
	use("jose-elias-alvarez/nvim-lsp-ts-utils")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/nvim-cmp")
	use("windwp/nvim-autopairs")
	use({ "nvim-lualine/lualine.nvim", "arkav/lualine-lsp-progress" })
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")
	use("jose-elias-alvarez/null-ls.nvim")
	use({ "mfussenegger/nvim-dap" })
	use({ "nvim-telescope/telescope-dap.nvim" })
	use({ "theHamsta/nvim-dap-virtual-text" })
	use({ "rcarriga/nvim-dap-ui" })
	use({ "Pocco81/DAPInstall.nvim" })
	use("David-Kunz/jester")

	--Terminal
	use("akinsho/toggleterm.nvim")
	use("sindrets/diffview.nvim")

	-- Git
	use("tpope/vim-fugitive")
	use("lewis6991/gitsigns.nvim")

	-- Nav
	use("nvim-telescope/telescope.nvim")
	use("nvim-telescope/telescope-fzy-native.nvim")
	use("kyazdani42/nvim-web-devicons")
	use("kyazdani42/nvim-tree.lua")
	use("akinsho/bufferline.nvim")
	use("karb94/neoscroll.nvim")

	-- Colorschemes
	use("morhetz/gruvbox")
	use("ackyshake/Spacegray.vim")
	use("tomasiser/vim-code-dark")

	-- Treesitter
	use("p00f/nvim-ts-rainbow")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

	-- Comments
	use("numToStr/Comment.nvim")
	use("JoosepAlviste/nvim-ts-context-commentstring")
end)
