local utils = require("kola.utils")

function string:firstword()
    return self:match("^([%w]+)")
end

local function view_commit()
    local line = vim.fn.getline(".")
    vim.cmd("DiffviewOpen " .. line:firstword() .. "^!")
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "git",
    callback = function()
        vim.keymap.set("n", "<cr>", view_commit, { noremap = true, silent = true, buffer = true })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "git",
    command = "nnoremap <buffer><silent> q <cmd>q<cr>",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "fugitiveblame",
    callback = function()
        vim.keymap.set("n", "<cr>", view_commit, { noremap = true, silent = true, buffer = true })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "fugitiveblame",
    command = "nnoremap <buffer><silent> q <cmd>q<cr>",
})

local job = nil

vim.api.nvim_create_user_command("StartLiveServer", function(opts)
    -- start live server
    job = vim.fn.jobstart("live-server " .. opts.args, {
        on_stdout = function(_, data)
            P(data[1])
        end,
    })
    print("Live server started")
end, {
    nargs = 1,
})

vim.api.nvim_create_user_command("StopLiveServer", function()
    vim.fn.jobstop(job)
    print("Live server stopped")
end, {})

vim.api.nvim_create_user_command("Jest", function()
    print(utils.get_jest_nearest_test())
end, {})
