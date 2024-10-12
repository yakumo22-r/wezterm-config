local wezterm = require('wezterm')
local act = wezterm.action

local wndu = require('utils.window-utils')
local user = require('user')

local window_color_choices = {}

for i,p in ipairs(wndu.get_plates()) do
    table.insert(window_color_choices, {
        id = tostring(i),
        label = wezterm.format {
            { Foreground = { Color =  p.default} },
            { Text = p.desc },
        },
    })
end

wezterm.on('augment-command-palette', function(window, pane)
	return {
		{
			brief = 'RenameTab',
			icon = 'md_rename_box',

			action = act.PromptInputLine({
					description = 'Enter new name for tab',
					action = wezterm.action_callback(function(window, pane, line)
						if line then
							window:active_tab():set_title(line)

                            -- refresh ...
                            window:perform_action(
                                act.ActivateTabRelative(1),pane
                            )
                            window:perform_action(
                                act.ActivateTabRelative(-1),pane
                            )
						end
					end),
				}),
		},
	}
end)
