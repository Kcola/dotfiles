local configs_found, configs = pcall(function()
	return vim.fn.json_decode(vim.fn.readfile(vim.fn.expand(CONFIG_PATH)))
end)

if not configs_found then
	return {
		get = NOOP,
	}
end

local getProject = function()
	return vim.fn.fnamemodify(vim.fn.finddir(".git", ";"), ":h:t")
end

return {
	get = function()
		return configs[getProject()] or {}
	end,
}
