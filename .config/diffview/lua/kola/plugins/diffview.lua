return {
    "sindrets/diffview.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    dependencies = { "nvim-lua/plenary.nvim", "lewis6991/gitsigns.nvim", "nvim-tree/nvim-web-devicons" },
    keys = { "gs" },
    config = function()
        -- Lua
        local opts = { noremap = true, silent = true }
        local actions = require("diffview.actions")
        local lazy = require("diffview.lazy")
        local lib = lazy.require("diffview.lib")
        local gs = require("gitsigns")

        local goto_file = function()
            actions.goto_file()
            vim.fn.feedkeys("zR")
        end

        local goto_file_and_close = function()
            goto_file()
            vim.cmd("only")
            vim.cmd("tabonly")
            vim.fn.feedkeys("zR")
        end

        local open = function()
            vim.cmd("DiffviewOpen")
        end

        require("diffview").setup({
            key_bindings = {
                file_panel = {
                    s = actions.toggle_stage_entry,
                    ["<cr>"] = goto_file_and_close,
                    ["cc"] = "<Cmd>botright Git commit<CR>",
                    ["<2-LeftMouse>"] = actions.select_entry,
                },
                diff_view = {
                    ["<Down>"] = gs.next_hunk,
                    ["<Up>"] = gs.prev_hunk,
                },
            },
        })

        function string:firstword()
            return self:match("^([%w]+)")
        end

        vim.keymap.set("n", "gs", open)
        vim.keymap.set("n", "<leader>history", "<cmd>DiffviewFileHistory %<cr>", opts)
    end,
}
