local entry_display = require("telescope.pickers.entry_display")

local config = require("kola.config").get()

local entry_from_quickfix = function(opts)
	opts = opts or {}

	local displayer = entry_display.create({
		separator = "▏",
		items = {
			{ width = 8 },
			{ remaining = true },
		},
	})

	local make_display = function(entry)
		local filename = vim.fn.fnamemodify(entry.filename, ":h:t") .. "/" .. vim.fn.fnamemodify(entry.filename, ":t")

		local line_info = { table.concat({ entry.lnum, entry.col }, ":"), "TelescopeResultsLineNr" }

		return displayer({
			line_info,
			filename,
		})
	end
	return function(entry)
		local filename = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr)

		return {
			valid = true,

			value = entry,
			ordinal = (not opts.ignore_filename and filename or "") .. " " .. entry.text,
			display = make_display,

			bufnr = entry.bufnr,
			filename = filename,
			lnum = entry.lnum,
			col = entry.col,
			text = entry.text,
			start = entry.start,
			finish = entry.finish,
		}
	end
end

require("telescope").setup({
	defaults = {
		file_sorter = require("telescope.sorters").get_fzy_sorter,
		file_ignore_patterns = { "node_modules", "lib" },
		prompt_prefix = " >",
		color_devicons = true,

		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
	},
	pickers = {
		live_grep = {
			search_dirs = config.telescope,
			mappings = {
				i = {
					["<c-p>"] = function()
						print(vim.fn.getcwd())
					end,
				},
			},
		},
		buffers = {
			file_ignore_patterns = {},
		},
		grep_string = {
			search_dirs = config.telescope,
		},
		git_branches = {
			layout_strategy = "center",
		},
		lsp_definitions = {
			initial_mode = "normal",
			entry_maker = entry_from_quickfix(),
		},
		lsp_type_definitions = {
			initial_mode = "normal",
			entry_maker = entry_from_quickfix(),
		},
		lsp_implementations = {
			initial_mode = "normal",
			entry_maker = entry_from_quickfix(),
		},
		lsp_references = {
			initial_mode = "normal",
			entry_maker = entry_from_quickfix(),
		},
	},
	extensions = {
		fzy_native = {
			override_generic_sorter = false,
			override_file_sorter = true,
		},
	},
})

require("telescope").load_extension("fzy_native")

local search_vim_config = function()
	require("telescope.builtin").find_files({
		prompt_title = "<VimRc >",
		cwd = "~/.config",
	})
end

_G.custom_find_files = function()
	require("telescope.builtin").find_files({
		search_dirs = config.telescope,
	})
end

local opts = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap

vim.keymap.set("n", "<leader>vrc", search_vim_config)
map("n", "<c-p>", ":lua _G.custom_find_files()<cr>", opts)
map("n", "<leader>F", "<cmd>Telescope git_files<cr>", opts)
map("n", "<leader>gb", "<cmd>lua require('kola.telescope.custom_builtins').git_branches()<CR>", opts)
map("n", "<leader>ff", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<c-b>", "<cmd>Telescope buffers<cr>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
