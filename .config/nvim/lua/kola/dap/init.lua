require("telescope").load_extension("dap")
require("kola.dap.node")
require("dapui").setup()
require("nvim-dap-virtual-text").setup()
local dap = require("dap")
local dapui = require("dapui")
vim.g.dap_virtual_text = true

vim.keymap.set("n", "<F5>", require("kola.dap.node").attach)
vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>dH", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<A-k>", dap.step_out)
vim.keymap.set("n", "<A-l>", dap.step_into)
vim.keymap.set("n", "<F9>", dap.step_over)
vim.keymap.set("n", "<F10>", dap.continue)
vim.keymap.set("n", "<leader>k", require("dapui").eval)

-- dap.listeners.after.event_initialized["dapui_config"] = function()
--   vim.cmd("tabnew")
--   dapui.open()
--   vim.cmd("q")
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--   dapui.close()
--   vim.cmd("tabclose")
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--   dapui.close()
--   vim.cmd("tabclose")
-- end
