-- sign 3
local ycolors = require('colors.ykm22_wez_colors')

local text_color = ycolors.light1
local base_color = ycolors.dark0_hard
local crust_color = ycolors.dark0_hard
local mantle_color = ycolors.dark0
local colorscheme = {
	foreground = text_color,
	background = base_color,
	cursor_bg = ycolors.rosewater,
	cursor_border = ycolors.rosewater,
	cursor_fg = crust_color,
	selection_bg = ycolors.dark3,
	selection_fg = text_color,
	ansi = ycolors.get_range(ycolors.term, 1,8),
	brights = ycolors.get_range(ycolors.term, 9,16),
	tab_bar = {
		background = '#000000',
		active_tab = {
			bg_color = ycolors.surface2,
			fg_color = text_color,
		},
		inactive_tab = {
			bg_color = ycolors.surface0,
			fg_color = ycolors.subtext,
		},
		inactive_tab_hover = {
			bg_color = ycolors.surface0,
			fg_color = text_color,
		},
		new_tab = {
			bg_color = base_color,
			fg_color = text_color,
		},
		new_tab_hover = {
			bg_color = mantle_color,
			fg_color = text_color,
			italic = true,
		},
	},
	visual_bell = ycolors.surface0,
	indexed = {
		[16] = ycolors.peach,
		[17] = ycolors.rosewater,
	},
	scrollbar_thumb = ycolors.surface2,
	split = ycolors.overlay,
	compose_cursor = ycolors.flamingo, -- nightbuild only
}

return colorscheme
