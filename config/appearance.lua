local wezterm = require('wezterm')
local colors = require('colors.custom')
local user = require('user')

return {
	animation_fps = 60,
	max_fps = 60,
	front_end = 'WebGpu',
	webgpu_power_preference = 'HighPerformance',

	-- color scheme
	colors = colors,

	-- background
	background = {
		{
			source = { File = wezterm.GLOBAL.background },
		},
		{
			source = { Color = colors.background },
			height = '100%',
			width = '100%',
			opacity = 0.9,
		},
	},

	-- scrollbar
	enable_scroll_bar = true,

	-- cursor
	default_cursor_style = 'BlinkingBlock',
	cursor_blink_ease_in = "Constant",
	cursor_blink_ease_out = "Constant",
	cursor_blink_rate = 600,

	-- tab bar
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = false,
	use_fancy_tab_bar = true,
	tab_max_width = 40,
	show_tab_index_in_tab_bar = true,
	switch_to_last_active_tab_when_closing_tab = true,

	-- window
	window_decorations = "INTEGRATED_BUTTONS|RESIZE",
	integrated_title_buttons = { 'Hide', 'Maximize', 'Close' },
	integrated_title_button_alignment = "Right",
	integrated_title_button_color = "Auto",

	initial_cols = user.window.width,
	initial_rows = user.window.height,

    window_frame = {
        active_titlebar_bg = require('utils.window-utils').get_plate(-1).bg,
        font_size = user.frame_font_size or 12,
    },

	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	},
	window_close_confirmation = 'NeverPrompt',
	-- inactive_pane_hsb = {
	-- 	saturation = 0.7,
	-- 	brightness = 0.6,
	-- },
}
