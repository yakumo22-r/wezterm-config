local wezterm = require('wezterm')
local platform = require('utils.platform')()
local backdrops = require('utils.backdrops')
local wndu = require('utils.window-utils')
local wsu = require('utils.workspace-utils')
local act = wezterm.action

local mod = {}

if platform.is_mac then
	mod.SUPER = 'SUPER'
	mod.LOWSUPER = 'CTRL'
	mod.SUPER_REV = 'SUPER|CTRL'
	mod.SYS = 'SUPER'
elseif platform.is_win then
	mod.SUPER = 'SHIFT|CTRL' -- to not conflict with Windows key shortcuts
	mod.LOWSUPER = 'CTRL'
	mod.SYS = 'ALT'
end

local keys = {
	-- misc/useful --
	{
		key = 'n',
		mods = mod.SYS,
		action = wsu.SpawnTabSelect,
	},
	{ key = 'm', mods = mod.SUPER, action = act.ShowTabNavigator },
	{ key = 'F12', mods = 'NONE', action = act.ShowDebugOverlay },
	{
		key = 'F5',
		mods = 'NONE',
		action = wezterm.action_callback(function(window, pane)
			window:perform_action(wezterm.action.ActivateLastTab, window:active_pane())
			window:perform_action(wezterm.action.ActivateLastTab, window:active_pane())
		end),
	},

	-- copy/paste --
	{ key = 'c', mods = mod.SYS, action = act.CopyTo('Clipboard') },
	{ key = 'v', mods = mod.SYS, action = act.PasteFrom('Clipboard') },

	-- tabs: navigation
	{ key = 'Tab', mods = mod.LOWSUPER, action = wndu.WindowFocus },
	{ key = '[', mods = mod.LOWSUPER, action = act.ActivateTabRelative(-1) },
	{ key = ']', mods = mod.LOWSUPER, action = act.ActivateTabRelative(1) },
	{ key = '[', mods = mod.SYS, action = act.MoveTabRelative(-1) },
	{ key = ']', mods = mod.SYS, action = act.MoveTabRelative(1) },
	{ key = 'p', mods = mod.SUPER, action = wezterm.action.ActivateCommandPalette },
	-- window --
	-- spawn windows
	{ key = 'w', mods = mod.SYS, action = wndu.WindowOperation },
	{ key = 'q', mods = mod.SYS, action = wsu.CloseCurrentPane },
	{ key = 'UpArrow', mods = mod.LOWSUPER, action = act.ScrollByLine(-10) },
	{ key = 'DownArrow', mods = mod.LOWSUPER, action = act.ScrollByLine(10) },

	-- panes: navigatioRn
	{ key = 'k', mods = mod.SUPER, action = act.ActivatePaneDirection('Up') },
	{ key = 'j', mods = mod.SUPER, action = act.ActivatePaneDirection('Down') },
	{ key = 'h', mods = mod.SUPER, action = act.ActivatePaneDirection('Left') },
	{ key = 'l', mods = mod.SUPER, action = act.ActivatePaneDirection('Right') },
	{ key = 'x', mods = mod.LOWSUPER, action = wezterm.action.ActivateCopyMode },

	{ key = 'r', mods = mod.SYS, action = wsu.RenameTab },
	{ key = 's', mods = mod.SYS, action = wsu.SpawnSplitPaneSelect },
	{ key = 'i', mods = mod.SYS, action = wsu.SpawnFastWorkSelect },
	{ key = 'm', mods = mod.SYS, action = act.PaneSelect },
	-- key-tables --
	-- resizes fonts
	-- {
	-- 	key = 'f',
	-- 	mods = mod.SUPER,
	-- 	action = act.ActivateKeyTable({
	-- 		name = 'resize_font',
	-- 		one_shot = false,
	-- 		timemout_miliseconds = 1000,
	-- 	}),
	-- },
	-- -- resize panes
	-- {
	-- 	key = 'p',
	-- 	mods = 'LEADER',
	-- 	action = act.ActivateKeyTable({
	-- 		name = 'resize_pane',
	-- 		one_shot = false,
	-- 		timemout_miliseconds = 1000,
	-- 	}),
	-- },
}

local key_tables = {
	-- resize_font = {
	-- 	{ key = 'k', action = act.IncreaseFontSize },
	-- 	{ key = 'j', action = act.DecreaseFontSize },
	-- 	{ key = 'r', action = act.ResetFontSize },
	-- 	{ key = 'Escape', action = 'PopKeyTable' },
	-- 	{ key = 'q', action = 'PopKeyTable' },
	-- },
	-- resize_pane = {
	-- 	{ key = 'k', action = act.AdjustPaneSize({ 'Up', 1 }) },
	-- 	{ key = 'j', action = act.AdjustPaneSize({ 'Down', 1 }) },
	-- 	{ key = 'h', action = act.AdjustPaneSize({ 'Left', 1 }) },
	-- 	{ key = 'l', action = act.AdjustPaneSize({ 'Right', 1 }) },
	-- 	{ key = 'Escape', action = 'PopKeyTable' },
	-- 	{ key = 'q', action = 'PopKeyTable' },
	-- },
}

local mouse_bindings = {
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = 'Left' } },
		mods = 'CTRL',
		action = act.OpenLinkAtMouseCursor,
	},
}

return {
	disable_default_key_bindings = true,
	leader = { key = 'Space', mods = 'CTRL|SHIFT' },
	keys = keys,
	key_tables = key_tables,
	mouse_bindings = mouse_bindings,
}
