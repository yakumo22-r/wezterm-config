local user = {}

-- add ssh connect here
user.ssh = 
{
	{label = "example-ssh", args = { 'ssh','example-server'}},
}


user.window = 
{
	-- max chars horizontal
	width = 120,
	-- max chars verticle
	height = 60,

	-- https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
	font = "JetBrainsMono Nerd Font Propo",
	fontsize = 18,

	-- image file under backdrops/
	background = 'shermie.png',
}


return user;
