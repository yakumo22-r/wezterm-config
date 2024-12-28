local wezterm = require('wezterm')
local dir = wezterm.home_dir .. '/.config'
local filepath = dir .. '/wezterm-user.lua'

---@class WindowConfig
---@field width number
---@field height number
---@field font string
---@field frame_font_size number
---@field background string

---@class WorkTab
---@field name string
---@field des? string
---@field domain? string
---@field cwd? string
---@field args? string[]
---@field group? boolean
---@field tabs? WorkTab[]


---@class UserConfig
---@field ws WorkTab[]
---@field window WindowConfig

local file = io.open(filepath, 'r')
if file then
	file:close()
else
	local d = io.open(dir, "r")
	if d == nil then
		os.execute('mkdir -p "' .. dir .. '"')
	end

	file = io.open(filepath, 'w')
	local default_content = [[
-- add ssh connect here
local user = {}
user.ws = {}

user.window =
{
    -- max chars horizontal
    width = 140,
    -- max chars verticle
    height = 40,

    -- https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
    font = "JetBrainsMono Nerd Font Propo",
    fontsize = 14,
    frame_font_size = 12,

    -- image file under backdrops/
    background = 'shermie.png',
}

local wez_user = {
	name = "wez-user",
	domain = "local",
	cwd = "]] ..dir:gsub("\\", "\\\\").. [[",
    args = {'zsh', '-c', 'nvim "wezterm-user.lua"'},
}

table.insert(user.ws, wez_user)

local test_group = {
    name = "test-group", group=true, tabs = {wez_user},
}
table.insert(user.ws, test_group)

return user
]]

	if file then
		file:write(default_content)
		file:close()
	else
		print('cannot open file for writting: ' .. filepath)
	end
end

local originalPath = package.path
package.path = filepath .. ';' .. package.path
local user = require('wezterm-user') -- ~/.config/wezterm-user.lua
package.path = originalPath

---@type UserConfig
return user
