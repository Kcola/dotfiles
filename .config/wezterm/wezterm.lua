local wezterm = require("wezterm")
local act = wezterm.action

local mykeys = {
  {
    key = "v",
    mods = "CTRL",
    action = wezterm.action("Paste"),
  },
  {
    key = ",",
    mods = "ALT",
    action = wezterm.action({ SendString = " vrc" }),
  },
  {
    key = "t",
    mods = "ALT",
    action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }),
  },
  {
    key = "w",
    mods = "ALT",
    action = wezterm.action.CloseCurrentTab({ confirm = false }),
  },
  {
    key = "=",
    mods = "CTRL",
    action = wezterm.action.IncreaseFontSize,
  },
  {
    key = "-",
    mods = "CTRL",
    action = wezterm.action.DecreaseFontSize,
  },
  {
    key = "0",
    mods = "CTRL",
    action = wezterm.action("ResetFontSize"),
  },
  {
    key = "/",
    mods = "ALT",
    action = wezterm.action({ SendString = "gc" }),
  },
  {
    key = "Enter",
    mods = "ALT",
    action = wezterm.action({ SendString = " qf" }),
  },
  {
    key = "h",
    mods = "ALT",
    action = wezterm.action({ SendString = " history" }),
  },
}

for i = 1, 8 do
  table.insert(mykeys, {
    key = tostring(i),
    mods = "ALT",
    action = act.ActivateTab(i - 1),
  })
end

local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

local TAB_BAR_BG = "#1e1e1e"
local ACTIVE_TAB_BG = "#608B4E"
local ACTIVE_TAB_FG = "Black"
local HOVER_TAB_BG = "White"
local HOVER_TAB_FG = "Black"
local NORMAL_TAB_BG = "White"
local NORMAL_TAB_FG = "Black"

--get last part of path
local function get_last_part_of_path(path)
  local last = path:match("^.+\\(.+)$")
  if last == nil then
    return path
  end
  return last
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = NORMAL_TAB_BG
  local foreground = NORMAL_TAB_FG

  local is_first = tab.tab_id == tabs[1].tab_id
  local is_last = tab.tab_id == tabs[#tabs].tab_id

  if tab.is_active then
    background = ACTIVE_TAB_BG
    foreground = ACTIVE_TAB_FG
  elseif hover then
    background = HOVER_TAB_BG
    foreground = HOVER_TAB_FG
  end

  local leading_fg = NORMAL_TAB_FG
  local leading_bg = background

  local trailing_fg = background
  local trailing_bg = NORMAL_TAB_BG

  if is_first then
    leading_fg = TAB_BAR_BG
  else
    leading_fg = NORMAL_TAB_BG
  end

  if is_last then
    trailing_bg = TAB_BAR_BG
  else
    trailing_bg = NORMAL_TAB_BG
  end

  local title = get_last_part_of_path(tab.active_pane.foreground_process_name)

  return {
    { Attribute = { Italic = false } },
    { Attribute = { Intensity = hover and "Bold" or "Normal" } },
    { Background = { Color = leading_bg } },
    { Foreground = { Color = leading_fg } },
    { Text = SOLID_RIGHT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = " " .. title .. " " },
    { Background = { Color = trailing_bg } },
    { Foreground = { Color = trailing_fg } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

return {
  color_scheme = "VSCodeDark+ (Gogh)",
  default_cwd = "C:\\Users\\kolacampbell\\Repo",
  font = wezterm.font("JetBrainsMono NF"),
  mouse_bindings = {
    {
      event = { Down = { streak = 1, button = "Right" } },
      mods = "NONE",
      action = act.Copy,
    },
  },
  keys = mykeys,
  tab_bar_at_bottom = true,
  use_fancy_tab_bar = false,
  enable_tab_bar = true,
  tab_max_width = 100,
  default_prog = {
    "powershell",
    "-NoExit",
    "-Command",
    '$vsPath = & "${env:ProgramFiles(x86)}/Microsoft Visual Studio/Installer/vswhere.exe" -property installationpath; Import-Module "$vsPath/Common7/Tools/Microsoft.VisualStudio.DevShell.dll"; Enter-VsDevShell -VsInstallPath $vsPath -SkipAutomaticLocation',
  },
  tab_bar_style = {
    new_tab = wezterm.format({
      { Background = { Color = HOVER_TAB_BG } },
      { Foreground = { Color = TAB_BAR_BG } },
      { Text = SOLID_RIGHT_ARROW },
      { Background = { Color = HOVER_TAB_BG } },
      { Foreground = { Color = HOVER_TAB_FG } },
      { Text = " + " },
      { Background = { Color = TAB_BAR_BG } },
      { Foreground = { Color = HOVER_TAB_BG } },
      { Text = SOLID_RIGHT_ARROW },
    }),
    new_tab_hover = wezterm.format({
      { Attribute = { Italic = false } },
      { Attribute = { Intensity = "Bold" } },
      { Background = { Color = NORMAL_TAB_BG } },
      { Foreground = { Color = TAB_BAR_BG } },
      { Text = SOLID_RIGHT_ARROW },
      { Background = { Color = NORMAL_TAB_BG } },
      { Foreground = { Color = NORMAL_TAB_FG } },
      { Text = " + " },
      { Background = { Color = TAB_BAR_BG } },
      { Foreground = { Color = NORMAL_TAB_BG } },
      { Text = SOLID_RIGHT_ARROW },
    }),
  },
  colors = {
    tab_bar = {
      background = TAB_BAR_BG,
    },
  },
}
