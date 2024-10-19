local wezterm = require('wezterm')
local act = wezterm.action

local wsu = {}

local domain_load = false

local domain_infos = {}

local domain_ignores = {
	'^SSHMUX',
	'^unix',
	'SSH:github.com',
	'SSH:gitee.com',
}
local function domain_ignore(name)
	for _, v in ipairs(domain_ignores) do
		if name:match(v) then
			return true
		end
	end
end

local function load_domain_infos()
	local domains = wezterm.mux.all_domains()

	local sortgrp = {}

	domain_infos = {}

	for _, v in ipairs(domains) do
		if v:is_spawnable() and not domain_ignore(v:name()) then
			table.insert(sortgrp, {
				i = v:domain_id(),
				v = {
					id = v:name(),
					label = v:label(),
				},
			})
		end
	end

	table.sort(sortgrp, function(a, b)
		return a.i < b.i
	end)

	for _, v in ipairs(sortgrp) do
		table.insert(domain_infos, v.v)
	end
end

function wsu.select_domain(window, pane, callback, desc)
	if not domain_load then
		load_domain_infos()
		domain_load = true
	end

	window:perform_action(
		act.InputSelector({
			choices = domain_infos,
			description = '\n' .. (desc or 'No Tips'),
			action = wezterm.action_callback(function(_window, _pane, domain)
				if not domain then
					return
				end

				if domain ~= 'CurrentPaneDomain' or domain ~= 'DefaultDomain' then
					domain = { DomainName = domain }
				end

				callback(_window, _pane, domain)
			end),
			fuzzy = true,
		}),
		pane
	)
end

wsu.SpawnTabSelect = wezterm.action_callback(function(_window, _pane)
	wsu.select_domain( --
		_window,
		_pane,
		function(window, pane, domain)
			window:perform_action(act.SpawnTab(domain), pane)
			local tabs = window:mux_window():tabs()
			window:perform_action(wezterm.action.ActivateTab(#tabs - 1), window:active_pane())
		end,
		'Spawn New Tab With Domain'
	)
end)

wsu.RenameTab = act.PromptInputLine({
	description = 'Enter new name for current tab',
	action = wezterm.action_callback(function(window, pane, line)
		if line then
			window:active_tab():set_title(line)

			window:perform_action(wezterm.action.ActivateLastTab, window:active_pane())
			window:perform_action(wezterm.action.ActivateLastTab, window:active_pane())
		end
	end),
})

wsu.CloseCurrentPane = wezterm.action_callback(function(window, pane)
    local paneNum = #(window:mux_window():active_tab():panes())
	window:perform_action(act.CloseCurrentPane({ confirm = false }), pane)
    if paneNum == 1 then
        window:perform_action(wezterm.action.ActivateLastTab, window:active_pane())
    end
end)

wsu.SpawnSplitPaneSelect = wezterm.action_callback(function(_window, _pane)
	wsu.select_domain( --
		_window,
		_pane,
		function(window, pane, domain)
			window:perform_action(act.SplitPane{
                direction = "Right",
                command = {domain = domain},
            }, pane)
		end,
		'Spawn New Tab With Domain'
	)
end)
return wsu
