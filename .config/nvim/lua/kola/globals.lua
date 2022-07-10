P = function(value)
	print(vim.inspect(value))
end

JSON_PARSE = function(filename)
	local dir = vim.fn.expand("%:p:h")
	vim.fn.json_decode(vim.fn.readfile(dir .. "/" .. filename))
end
