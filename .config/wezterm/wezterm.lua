local wezterm = require("wezterm")
local act = wezterm.action

local is_windows = wezterm.target_triple:find("windows") ~= nil

local function terminalIsClosed(pane)
    local tab = pane:tab()
    local panes = tab:panes_with_info()
    return panes[1].is_zoomed or #panes == 1
end

local mykeys = {
    {
        key = "h",
        mods = "CTRL",
        action = wezterm.action_callback(function(win, pane)
            if terminalIsClosed(pane) then
                win:perform_action(act.SendKey({ key = "h", mods = "CTRL" }), pane)
            else
                win:perform_action(act.ActivatePaneDirection("Left"), pane)
            end
        end),
    },
    {
        key = "l",
        mods = "CTRL",
        action = wezterm.action_callback(function(win, pane)
            if terminalIsClosed(pane) then
                win:perform_action(act.SendKey({ key = "l", mods = "CTRL" }), pane)
            else
                win:perform_action(act.ActivatePaneDirection("Right"), pane)
            end
        end),
    },
    {
        key = "k",
        mods = "CTRL",
        action = wezterm.action_callback(function(win, pane)
            if terminalIsClosed(pane) then
                win:perform_action(act.SendKey({ key = "k", mods = "CTRL" }), pane)
            else
                win:perform_action(act.ActivatePaneDirection("Up"), pane)
            end
        end),
    },
    {
        key = "j",
        mods = "CTRL",
        action = wezterm.action_callback(function(win, pane)
            if terminalIsClosed(pane) then
                win:perform_action(act.SendKey({ key = "j", mods = "CTRL" }), pane)
            else
                win:perform_action(act.ActivatePaneDirection("Down"), pane)
            end
        end),
    },
    {
        key = "v",
        mods = "CTRL",
        action = act.PasteFrom("Clipboard"),
    },
    {
        key = "F12",
        action = wezterm.action_callback(function(_, pane)
            local tab = pane:tab()
            local panes = tab:panes_with_info()
            if #panes == 1 then
                pane:split({
                    direction = "Right",
                    size = 0.4,
                    domain = "CurrentPaneDomain",
                })
            elseif not panes[1].is_zoomed then
                panes[1].pane:activate()
                tab:set_zoomed(true)
            elseif panes[1].is_zoomed then
                tab:set_zoomed(false)
                panes[2].pane:activate()
            end
        end),
    },
    {
        key = "T",
        mods = "CTRL",
        action = wezterm.action.TogglePaneZoomState,
    },
    {
        key = "j",
        mods = "ALT",
        action = wezterm.action({ SendString = " J" }),
    },
    {
        key = ",",
        mods = "ALT",
        action = wezterm.action({ SendString = " vrc" }),
    },
    {
        key = "RightArrow",
        mods = "ALT",
        action = wezterm.action({ SendString = ":cnext\n" }),
    },
    {
        key = "LeftArrow",
        mods = "ALT",
        action = wezterm.action({ SendString = ":cprev\n" }),
    },
    { key = "t", mods = "ALT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
    { key = "l", mods = "ALT", action = wezterm.action.ShowLauncherArgs({ flags = "LAUNCH_MENU_ITEMS" }) },
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
        mods = "CTRL",
        action = wezterm.action({ SendString = " cp" }),
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
    {
        key = "c",
        mods = "CTRL",
        action = wezterm.action_callback(function(window, pane)
            local sel = window:get_selection_text_for_pane(pane)
            if not sel or sel == "" then
                window:perform_action(wezterm.action.SendKey({ key = "c", mods = "CTRL" }), pane)
            else
                window:perform_action(wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }), pane)
            end
        end),
    },
}

-- Add mac commands
local macCommands = {}
for _, key in ipairs(mykeys) do
    if key.mods == "ALT" then
        table.insert(macCommands, {
            key = key.key,
            mods = "CMD",
            action = key.action,
        })
    end
end

for i = 1, 8 do
    table.insert(mykeys, {
        key = tostring(i),
        mods = "ALT",
        action = act.ActivateTab(i - 1),
    })
end

--concat lua table
local function concat(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

local TAB_BAR_BG = "#1e1e1e"
local ACTIVE_TAB_BG = "#608B4E"
local ACTIVE_TAB_FG = "White"
local HOVER_TAB_BG = "White"
local HOVER_TAB_FG = "Black"
local NORMAL_TAB_BG = "White"
local NORMAL_TAB_FG = "Black"

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

    local title = tab.active_pane.title

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

mykeys = concat(mykeys, macCommands)

local launch_menu_windows = {
    {
        label = "Powershell",
        domain = { DomainName = "local" },
        args = {
            "pwsh",
        },
    },
    {
        label = "Ubuntu",
        domain = { DomainName = "WSL:Ubuntu" },
        cwd = "~/repo",
    },
}

wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

return {
    launch_menu = is_windows and launch_menu_windows or nil,
    wsl_domains = {
        {
            name = "WSL:Ubuntu",
            distribution = "Ubuntu",
            default_cwd = "~/repo",
        },
    },
    default_prog = is_windows and { "pwsh" } or nil,
    color_scheme = "VSCodeDark+ (Gogh)",
    font = wezterm.font_with_fallback({
        "JetBrainsMono NFM",
        "JetBrainsMono NF",
        "FiraCode Nerd Font",
    }),
    font_size = is_windows and 12 or 14.0,
    mouse_bindings = {
        {
            event = { Down = { streak = 1, button = "Right" } },
            mods = "NONE",
            action = act.CopyTo("ClipboardAndPrimarySelection"),
        },
    },
    keys = mykeys,
    tab_bar_at_bottom = true,
    use_fancy_tab_bar = false,
    enable_tab_bar = true,
    tab_max_width = 100,
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
