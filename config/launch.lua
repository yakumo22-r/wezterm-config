local platform = require('utils.platform')()

local options = {
	default_prog = {},
	launch_menu = {},
}

if platform.is_win then
	local zsh_args = { 'zsh', '-h' }
	options.default_prog = zsh_args
	options.launch_menu = {
		{ label = 'PowerShell Core', args = { 'pwsh' } },
		{ label = 'zsh', args = zsh_args },
	}
elseif platform.is_mac then
	options.default_prog = { 'zsh' }
	options.launch_menu = {
		{ label = 'Zsh', args = { 'zsh' } },
		{ label = 'Bash', args = { 'bash' } },
	}
elseif platform.is_linux then
	options.default_prog = { 'fish' }
	options.launch_menu = {
		{ label = 'Bash', args = { 'bash' } },
		{ label = 'Fish', args = { 'fish' } },
		{ label = 'Zsh', args = { 'zsh' } },
	}
end

-- add ssh config
local ssh_conf = require('user').ssh
for k, v in ipairs(ssh_conf) do
	options.launch_menu[#options.launch_menu + 1] = v
end

return options
