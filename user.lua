local wezterm = require('wezterm')
local dir = wezterm.home_dir .. '/.config'
local filepath = dir .. '/wezterm-user.lua'

local platform = require('utils.platform')()

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

    local nvim = "nvim"
    if platform.is_mac then
        nvim = "/usr/local/bin/nvim"
    end

	local default_content = [[
-- add ssh connect here
local user = {}

---@class Workspace
---@field name string
---@field des string
---@field domain string
---@field cwd string
---@field args string[]?
---@field group boolean?
---@field tabs Workspace[]?

---@type Workspace[]
user.ws = {}

---@param tab Workspace
local function workspace(tab)
    table.insert(user.ws, tab)
    return tab
end


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

local wez_user = workspace {
	name = "wez-user",
	domain = "local",
	cwd = "]] ..dir:gsub("\\", "/").. [[",
    args = { ']]..nvim..[[', 'wezterm-user.lua'},
}

local test_group = workspace {
    name = "test-group", group=true, tabs = {wez_user},
}

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
