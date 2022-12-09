local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

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
  use("goolord/alpha-nvim")

  -- LSP
  use({ "mhartington/formatter.nvim" })
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
  use({ "jose-elias-alvarez/null-ls.nvim", commit = "de751688c991216f0d17ced7d5076e0c37fa383f" })
  use({ "mfussenegger/nvim-dap" })
  use({ "nvim-telescope/telescope-dap.nvim" })
  use({ "theHamsta/nvim-dap-virtual-text" })
  use({ "rcarriga/nvim-dap-ui" })
  use({ "Pocco81/DAPInstall.nvim" })
  use("David-Kunz/jester")
  use("Hoffs/omnisharp-extended-lsp.nvim")
  use({
    "zbirenbaum/copilot.lua",
    event = "VimEnter",
    config = function()
      vim.defer_fn(function()
        require("copilot").setup()
      end, 100)
    end,
  })
  use({
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  })

  --Terminal
  use("akinsho/toggleterm.nvim")
  use("sindrets/diffview.nvim")

  -- Git
  use("tpope/vim-fugitive")
  use("lewis6991/gitsigns.nvim")
  use("rhysd/git-messenger.vim")

  -- Nav
  use({ "nvim-telescope/telescope.nvim", tag = "0.1.0" })
  use("nvim-telescope/telescope-fzy-native.nvim")
  use("kyazdani42/nvim-web-devicons")
  use("kyazdani42/nvim-tree.lua")
  use("akinsho/bufferline.nvim")
  use("karb94/neoscroll.nvim")
  use("mkitt/tabline.vim")
  use({
    "ThePrimeagen/harpoon",
  })
  use("ggandor/leap.nvim")

  -- Colorschemes
  use("morhetz/gruvbox")
  use("ackyshake/Spacegray.vim")
  use("tomasiser/vim-code-dark")

  -- Treesitter
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use("p00f/nvim-ts-rainbow")

  -- Comments
  use("numToStr/Comment.nvim")
  use("JoosepAlviste/nvim-ts-context-commentstring")
end)
