local dap = require("dap")

dap.adapters.node2 = {
	type = "executable",
	command = "node",
	args = {
		"~/Tools/vscode-node-debug2/out/src/nodeDebug.js",
	},
}

local function attach()
	print(require("kola.utils").get_package_root())
	dap.run({
		type = "node2",
		request = "attach",
		cwd = require("kola.utils").get_package_root(),
		sourceMaps = true,
		protocol = "inspector",
		skipFiles = { "<node_internals>/**/*.js" },
	})
end

return {
	attach = attach,
}
