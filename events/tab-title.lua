local wezterm = require('wezterm')

-- Inspired by https://github.com/wez/wezterm/discussions/628#discussioncomment-1874614

local GLYPH_ADMIN = '󰞀'
-- local GLYPH_ADMIN = utf8.char(0xf0780)

local M = {}

local tbl_domainsCount = {}
local tbl_domainNames = {}

function get_title_by_domain(domain_name, pane_id)
	if tbl_domainNames[pane_id] == nil then
		if tbl_domainsCount[domain_name] == nil then
			tbl_domainsCount[domain_name] = 1
			tbl_domainNames[pane_id] = domain_name
		else
			tbl_domainsCount[domain_name] = 1 + tbl_domainsCount[domain_name]
			tbl_domainNames[pane_id] = domain_name .. ' ' .. tbl_domainsCount[domain_name]
		end
	end
	return tbl_domainNames[pane_id]
end

local __cells__ = {}

local colors = {
	default = {
		bg = '#65616b',
		fg = '#1c1b19',
	},
	is_active = {
		bg = '#7FB4Ca',
		fg = '#11111b',
	},

	hover = {
		bg = '#75717b',
		fg = '#1c1b19',
	},
}

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
		local baseTitle = tab.active_pane.title
		local title = get_title_by_domain(domain_name, pane_id)
		wezterm.mux.get_tab(tab.tab_id):set_title(title .. ' - ' .. baseTitle)

		if tab.is_active then
			bg = colors.is_active.bg
			fg = colors.is_active.fg
		elseif hover then
			bg = colors.hover.bg
			fg = colors.hover.fg
		else
			bg = colors.default.bg
			fg = colors.default.fg
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
