local Config = require('config')

require('utils.backdrops'):set_files():random()

-- require('events.right-status').setup()
require('events.window-title').setup()
require('events.tab-title').setup()
require('events.new-tab-button').setup()

require('commands.common')

return Config:init()
	:append(require('config.appearance'))
	:append(require('config.bindings'))
	:append(require('config.fonts'))
	:append(require('config.general'))
	:append(require('config.launch')).options
