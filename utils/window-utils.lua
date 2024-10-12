local wezterm = require('wezterm')
local act = wezterm.action
local user = require('user')

---@class Plate
---@field desc string
---@field bg string
---@field default string
---@field active string
---@field hover string
---@field text string

local wndu = {}

---@type Plate[]
local plates = {
	{
		desc = 'blue(default)',
		default = '#7290a2',
		active = '#acd8f2',
		hover = '#75717b',
		bg = '#344149',
		text = '#000000',
	},
	{
		desc = 'orange',
		bg = '#7a3800',
		default = '#f57000',
		active = '#ffa200',
		hover = '#ff8b00',
		text = '#000000',
	},
	{
		desc = 'red',
		bg = '#490010',
		default = '#cc002b',
		active = '#ef6d00',
		hover = '#f50034',
		text = '#000000',
	},
	{
		desc = 'green',
		bg = '#2f4416',
		default = '#2e8e3a',
		active = '#40c7ab',
		hover = '#37aa46',
		text = '#000000',
	},
	{
		desc = 'purple',
		bg = '#390028',
		default = '#c500ff',
		active = '#ff00be',
		hover = '#ec00ff',
		text = '#000000',
	},
}

---@class WindowInfo
---@field col_id number
---@field title string
---@field subname string

---@type table<number,WindowInfo>
local WindowInfos = {}

---@return WindowInfo
local function get_window_info(wid)
    if not WindowInfos[wid] then
        WindowInfos[wid] = {col_id = 1, title = "(unnamed)", subname = ""}
    end
    return WindowInfos[wid]
end

function wndu.set_window_title(wid, title)
    if title then
        get_window_info(wid).title = title
    end
end

function wndu.set_window_subname(wid, subname)
    if subname then
        get_window_info(wid).subname = subname
    end
end

---@return Plate
function wndu.map_plate(wid, plate_id)
    local info = get_window_info(wid)
    if plate_id then
        info.col_id = plate_id
    end
    return plates[info.col_id]
end

function wndu.get_window_title(wid)
    return get_window_info(wid).title
end

function wndu.get_window_subname(wid)
    return get_window_info(wid).subname
end


---@param wid number|nil
---@return Plate
function wndu.get_plate(wid)
    return plates[get_window_info(wid).col_id]
end

---@return Plate[]
function wndu.get_plates()
	return plates
end

-- TAG: Window Operation
---@class WindowOp
---@field label string
---@field action any

---@type WindowOp[]
local WND_OP = {}

WND_OP[1] = {
	label = 'spawn window',
	action = act.SpawnWindow,
}

WND_OP[2] = {
	label = 'rename',
	action = act.PromptInputLine({
		description = 'Enter new name for window',
		action = wezterm.action_callback(function(window, pane, line)
			if line then
                wndu.set_window_title(window:window_id(),line)
				window:mux_window():set_title(line)

				-- refresh ...
				window:perform_action(act.ActivateTabRelative(1), pane)
				window:perform_action(act.ActivateTabRelative(-1), pane)
			end
		end),
	}),
}

local window_color_choices = {}
for i, p in ipairs(wndu.get_plates()) do
	table.insert(window_color_choices, {
		id = tostring(i),
		label = wezterm.format({
			{ Background = { Color = p.bg } },
			{ Foreground = { Color = p.active } },
			{ Text = p.desc },
		}),
	})
end

WND_OP[3] = {
	label = 'set color',
	action = act.InputSelector({
		description = 'set window color, press / to search',
		choices = window_color_choices,
		action = wezterm.action_callback(function(window, pane, id)
			if id then
				id = tonumber(id)
				local plate = wndu.map_plate(window:window_id(), id)
				window:set_config_overrides({
					window_frame = {
						active_titlebar_bg = plate.bg,
						font_size = user.frame_font_size or 12,
					},
				})
				-- refresh ...
				window:perform_action(act.ActivateTabRelative(1), pane)
				window:perform_action(act.ActivateTabRelative(-1), pane)
			end
		end),
		-- fuzzy = true,
	}),
}

WND_OP[4] = {
	label = 'maximize',
	action = wezterm.action_callback(function(window, pane)
		window:maximize()
	end),
}

WND_OP[5] = {
	label = 'restore',
	action = wezterm.action_callback(function(window, pane)
		window:restore()
	end),
}

WND_OP[6] = {
	label = 'toggle fullscreen',
	action = wezterm.action_callback(function(window, pane)
		window:toggle_fullscreen()
	end),
}

local wnd_op_opts = {}
for i, op in ipairs(WND_OP) do
	table.insert(wnd_op_opts, {
		id = tostring(i),
		label = op.label,
	})
end

wndu.WindowOperation = act.InputSelector({
	description = 'select window operation, press / to search',
	choices = wnd_op_opts,
	action = wezterm.action_callback(function(window, pane, id)
		if id then
			id = tonumber(id)
			window:perform_action(WND_OP[id].action, pane)
		end
	end),
})

-- TAG: Window Jump

wndu.WindowFocus = wezterm.action_callback(function(window, pane, id)
	local wnd_list = {}
	local wnds = wezterm.gui.gui_windows()

	for _, wnd in ipairs(wnds) do
		local wid = wnd:window_id()
		local p = wndu.get_plate(wid)

		local fmt = {}
        local info = get_window_info(wid)

		local title = info.title .. " | " .. info.subname
		if wnd:is_focused() then
			title = '* ' .. title
		end

		table.insert(fmt, { Background = { Color = p.bg } })
		table.insert(fmt, { Foreground = { Color = p.active } })
		table.insert(fmt, { Text = title })

		table.insert(wnd_list, {
			id = tostring(wid),
			label = wezterm.format(fmt),
		})
	end

	window:perform_action(
		act.InputSelector({
			choices = wnd_list,
			description = 'focus window, press / to search',
			action = wezterm.action_callback(function(window, pane, id)
				if id then
					tonumber(id)
					for _, wnd in ipairs(wnds) do
						if wnd:window_id() == tonumber(id) then
							wnd:focus()
							return
						end
					end
				end
			end),
		}),
		pane
	)
end)

return wndu
