-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require("lualine")

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local colors = {
  background = "#1e1e1e",
  foreground = "#dcdcdc",
  black = "#000000",
  red = "#D16969",
  green = "#608B4E",
  yellow = "#DCDCAA",
  blue = "#569CD6",
  magenta = "#C586C0",
  cyan = "#569CD6",
  white = "#eaeaea",
}
-- Config
local config = {
  globalstauts = true,
  sections = {
    -- these are to remove the defaults
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left({
  "branch",
  icon = "",
  color = { fg = colors.green, gui = "bold" },
})

ins_left({
  "diff",
  -- Is it me or the symbol for modified us really weird
  symbols = { added = "+ ", modified = "~ ", removed = "- " },
  cond = conditions.hide_in_width,
  color_added = colors.green,
  color_modified = colors.orange,
  color_removed = colors.red,
})

ins_left({
  "lsp_progress",
  separators = {
    component = " ",
    progress = " | ",
    message = { pre = "", post = "" },
    percentage = { pre = "", post = "%% " },
    title = { pre = "", post = ": " },
    lsp_client_name = { pre = "[", post = "]" },
    spinner = { pre = "", post = "" },
  },
  message = { commenced = "starting...", completed = "done" },
  display_components = { "lsp_client_name", { "message" } },
})

ins_left({
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = { error = " ", warn = " ", info = " " },
  color_error = colors.red,
  color_warn = colors.yellow,
  color_info = colors.cyan,
})

ins_left({
  "%f",
  max_length = vim.o.columns * 1 / 3,
})

ins_right({
  -- Lsp server name .
  function()
    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return "No Active Lsp"
    end
    local clientNames = {}
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        if client.name ~= "null-ls" then
          table.insert(clientNames, client.name)
        end
      end
    end
    if #clientNames == 0 then
      return "No Active Lsp"
    end
    local msg = ""
    local maxClientsToPrint = 1
    local separator = "·"
    for i = 1, math.min(maxClientsToPrint, #clientNames) do
      msg = msg .. (i == 1 and "" or separator) .. clientNames[i]
    end
    return msg
  end,
  icon = " ",
  color = { fg = colors.yellow, gui = "bold" },
})

-- Add components to right sections
ins_right({
  "",
  fmt = function()
    return vim.fn.fnamemodify(vim.fn.finddir(".git/..", ";"), ":p:h:t")
  end,
  cond = conditions.hide_in_width,
  color = { fg = colors.green, gui = "bold" },
})

ins_right({
  "fileformat",
  fmt = string.upper,
  icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
  color = { fg = colors.green, gui = "bold" },
})

-- Now don't forget to initialize lualine
lualine.setup(config)
