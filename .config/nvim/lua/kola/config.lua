local configs_found, configs = pcall(function()
	return vim.fn.json_decode(vim.fn.readfile(vim.fn.expand(CONFIG_PATH)))
end)

if not configs_found then
	return {}
end

local getProject = function()
	local git_root = vim.fn.finddir(".git/..", vim.fn.expand("%:p:h") .. ";")
	local folderName = vim.fn.fnamemodify(git_root, ":t")
	return folderName
end

return {
	get = function()
		return configs[getProject()] or {}
	end,
}
