local utils = require("telescope.utils")
local entry_display = require("telescope.pickers.entry_display")
local strings = require("plenary.strings")
local conf = require("telescope.config").values
local pickers = require("telescope.pickers")
local actions = require("telescope.actions")
local finders = require("telescope.finders")
local action_state = require("telescope.actions.state")

local checkout = function(prompt_bufnr)
	local selection = action_state.get_selected_entry()
	if selection == nil then
		utils.__warn_no_selection("actions.git_switch_branch")
		return
	end
	actions.close(prompt_bufnr)
	local pattern = "^refs/remotes/%w+/"
	local branch = selection.value
	if string.match(selection.refname, pattern) then
		branch = string.gsub(selection.refname, pattern, "")
	end
	vim.cmd("G checkout " .. branch)
end

local M = {}

M.git_branches = function()
	local format = "%(HEAD)" .. "%(refname)" .. "%(authorname)" .. "%(upstream:lstrip=2)" .. "%(committerdate:relative)"
	local output = utils.get_os_command_output({ "git", "for-each-ref", "--perl", "--format", format })

	local results = {}
	local widths = {
		name = 0,
		authorname = 0,
		upstream = 0,
		committerdate = 0,
	}
	local unescape_single_quote = function(v)
		return string.gsub(v, "\\([\\'])", "%1")
	end
	local parse_line = function(line)
		local fields = vim.split(string.sub(line, 2, -2), "''", true)
		local entry = {
			head = fields[1],
			refname = unescape_single_quote(fields[2]),
			authorname = unescape_single_quote(fields[3]),
			upstream = unescape_single_quote(fields[4]),
			committerdate = fields[5],
		}
		local prefix
		if vim.startswith(entry.refname, "refs/remotes/") then
			prefix = "refs/remotes/"
		elseif vim.startswith(entry.refname, "refs/heads/") then
			prefix = "refs/heads/"
		else
			return
		end
		local index = 1
		if entry.head ~= "*" then
			index = #results + 1
		end

		entry.name = string.sub(entry.refname, string.len(prefix) + 1)
		for key, value in pairs(widths) do
			widths[key] = math.max(value, strings.strdisplaywidth(entry[key] or ""))
		end
		if string.len(entry.upstream) > 0 then
			widths.upstream_indicator = 2
		end
		table.insert(results, index, entry)
	end
	for _, line in ipairs(output) do
		parse_line(line)
	end
	if #results == 0 then
		return
	end

	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 1 },
			{ width = 70 },
			{ width = 20 },
			{ width = widths.upstream_indicator },
			{ width = widths.committerdate },
		},
	})

	local make_display = function(entry)
		return displayer({
			{ entry.head },
			{ entry.name, "TelescopeResultsIdentifier" },
			{ entry.authorname, "TelescopePreviewUser" },
			{ string.len(entry.upstream) > 0 and "" or "" },
			{ entry.committerdate, "TelescopePreviewDate" },
		})
	end

	pickers.new({}, {
		prompt_title = "Git Branches",
		finder = finders.new_table({
			results = results,
			entry_maker = function(entry)
				entry.value = entry.name
				entry.ordinal = entry.name .. " " .. entry.authorname
				entry.display = make_display
				return entry
			end,
		}),
		previewer = false,
		layout_strategy = "vertical",
		layout_config = { prompt_position = "top", width = 0.4, height = 0.4 },
		sorter = conf.file_sorter(),
		attach_mappings = function(_, map)
			actions.select_default:replace(checkout)
			map("i", "<c-t>", actions.git_track_branch)
			map("n", "<c-t>", actions.git_track_branch)

			map("i", "<c-r>", actions.git_rebase_branch)
			map("n", "<c-r>", actions.git_rebase_branch)

			map("i", "<c-a>", actions.git_create_branch)
			map("n", "<c-a>", actions.git_create_branch)

			map("i", "<c-s>", actions.git_switch_branch)
			map("n", "<c-s>", actions.git_switch_branch)

			map("i", "<c-d>", actions.git_delete_branch)
			map("n", "<c-d>", actions.git_delete_branch)

			map("i", "<c-y>", actions.git_merge_branch)
			map("n", "<c-y>", actions.git_merge_branch)
			return true
		end,
	}):find()
end

return M
