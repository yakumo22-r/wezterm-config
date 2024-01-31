local wezterm = require('wezterm')
local platform = require('utils.platform')

<<<<<<< HEAD
local font = 'JetBrainsMono Nerd Font Propo'
=======
local font = 'JetBrainsMono Nerd Font Mono'
>>>>>>> a28e9cc8c7908d0bb9dea1f39642958c967af442
local font_size = platform().is_mac and 16 or 14

return {
   font = wezterm.font(font),
   font_size = font_size,

   --ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
   freetype_load_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
   freetype_render_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}
