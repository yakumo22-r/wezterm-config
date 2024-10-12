local wezterm = require('wezterm')
local wndu = require('utils.window-utils')
local act = wezterm.action

local M = {}
M.setup = function()
	wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
		local index = ''
        local wid = tab.window_id
		if #tabs > 1 then
			index = string.format(' [%d/%d] ', tab.tab_index + 1, #tabs)
		end

        local tab_title = tab.tab_title
        if tab_title == "" then
            tab_title = tab.active_pane.domain_name
        end

        local sub_name = tab_title .. index

        wndu.set_window_subname(wid, sub_name)
        return wndu.get_window_title(wid).. " | " ..sub_name
	end)
end

return M
