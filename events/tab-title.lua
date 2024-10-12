local wezterm = require('wezterm')
local act = wezterm.action

local wndu = require('utils.window-utils')
local GLYPH_ADMIN = '󰞀'
-- local GLYPH_ADMIN = utf8.char(0xf0780)

local M = {}

local __cells__ = {}

local _set_process_name = function(s)
	local a = string.gsub(s, '(.*[/\\])(.*)', '%2')
	return a:gsub('%.exe$', '')
end

local _set_title = function(process_name, base_title, max_width, inset)
	local title
	inset = inset or 6

	if process_name:len() > 0 then
		title = process_name .. ' ~ ' .. base_title
	else
		title = base_title
	end

	if title:len() > max_width - inset then
		local diff = title:len() - max_width + inset
		title = wezterm.truncate_right(title, title:len() - diff)
	end

	return title
end

local _check_if_admin = function(p)
	if p:match('^Administrator: ') then
		return true
	end
	return false
end

---@param fg string
---@param bg string
---@param attribute table
---@param text string
local _push = function(bg, fg, attribute, text)
	table.insert(__cells__, { Background = { Color = bg } })
	table.insert(__cells__, { Foreground = { Color = fg } })
	table.insert(__cells__, { Attribute = attribute })
	table.insert(__cells__, { Text = text })
end

M.setup = function()
	wezterm.on('format-tab-title', function(tab, _tabs, _panes, _config, hover, max_width)
		__cells__ = {}

		local bg
		local fg
		local is_admin = _check_if_admin(tab.active_pane.title)
		local pane_id = tab.active_pane.pane_id
		local domain_name = tab.active_pane.domain_name

        local title = tab.tab_title
        if tab.tab_title == "" then
            title = domain_name .. " " .. tab.tab_id
            wezterm.mux.get_tab(tab.tab_id):set_title(title)
        end


        local plate = wndu.get_plate(tab.window_id)
		if tab.is_active then
			bg = plate.active
			fg = plate.text
		elseif hover then
			bg = plate.hover
			fg = plate.text
		else
			bg = plate.default
			fg = plate.text
		end

		-- Left semi-circle
		-- _push(fg, bg, { Intensity = 'Bold' }, GLYPH_SEMI_CIRCLE_LEFT)

		-- Admin Icon
		if is_admin then
			_push(bg, fg, { Intensity = 'Bold' }, ' ' .. GLYPH_ADMIN)
		end

		-- Title
		_push(bg, fg, { Intensity = 'Bold' }, ' ' .. title)

		-- Right padding
		_push(bg, fg, { Intensity = 'Bold' }, ' ')

		-- Right semi-circle
		-- _push(fg, bg, { Intensity = 'Bold' }, GLYPH_SEMI_CIRCLE_RIGHT)

		return __cells__
	end)
end

return M
