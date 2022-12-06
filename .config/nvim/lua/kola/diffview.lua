-- Lua
local cb = require("diffview.config").diffview_callback
local lazy = require("diffview.lazy")
local lib = lazy.require("diffview.lib")

local goto_file = function()
  cb("goto_file")()
  vim.fn.feedkeys("zR")
end

local goto_file_and_close = function()
  goto_file()
  vim.cmd("only")
  vim.cmd("tabonly")
  vim.fn.feedkeys("zR")
end

local open = function()
  local file_location = vim.fn.expand("%")
  if file_location:find(".config") then
    vim.env.GIT_WORK_TREE = vim.fn.expand("~/.local/share/yadm/repo.git")
    vim.env.GIT_DIR = vim.fn.expand("~")
  else
    vim.env.GIT_WORK_TREE = vim.fn.fnamemodify(vim.fn.finddir(".git/..", ";"), ":p:h") .. "\\"
    vim.env.GIT_DIR = vim.fn.fnamemodify(vim.fn.finddir(".git/..", ";"), ":p:h") .. "\\.git"
  end
  vim.cmd("DiffviewOpen")
end

local load_files_into_buffer = function()
  for _, filetree in pairs(lib.get_current_view().files) do
    for _, value in ipairs(filetree) do
      vim.fn.bufload(vim.fn.bufadd(value.absolute_path))
    end
  end
  P("All change files loaded")
end

require("diffview").setup({
  key_bindings = {
    file_panel = {
      ["<c-d>"] = load_files_into_buffer,
      s = cb("toggle_stage_entry"),
      o = goto_file,
      ["<cr>"] = goto_file_and_close,
      ["cc"] = "<Cmd>botright Git commit<CR>",
    },
  },
  hooks = {
    view_closed = function()
      vim.env.GIT_WORK_TREE = nil
      vim.env.GIT_DIR = nil
    end,
  },
})

function string:firstword()
  return self:match("^([%w]+)")
end

local function view_commit()
  local line = vim.fn.getline(".")
  vim.cmd("DiffviewOpen " .. line:firstword() .. "^!")
end

return {
  view_commit = view_commit,
  open = open,
}
