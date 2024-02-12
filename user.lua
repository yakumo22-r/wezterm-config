local wezterm = require('wezterm')
local dir = wezterm.home_dir .. '/.config'
local filepath = dir .. '/wezterm-user.lua'

local file = io.open(filepath, 'r')
if file then
	file:close()
else
	if not vim.loop.fs_stat(dir) then
		vim.fn.system('mkdir -p "' .. dir .. '"')
	end

	file = io.open(filepath, 'w')
	local default_content = [[
	-- add ssh connect here
	local user = {}
	user.ssh =
	{
		{label = "sample-ssh", args = { 'ssh','sample-ssh'}},
	}

	user.window =
	{
		-- max chars horizontal
		width = 140,
		-- max chars verticle
		height = 40,

		-- https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
		font = "JetBrainsMono Nerd Font Propo",
		fontsize = 18,

		-- image file under backdrops/
		background = 'shermie.png',
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
local user = require('wezterm-user')
package.path = originalPath

return user
