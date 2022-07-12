P = function(value)
	print(vim.inspect(value))
	return value
end

JSON_PARSE = function(filename)
	vim.fn.json_decode(vim.fn.readfile(filename))
end

NOOP = function()
	return {}
end
