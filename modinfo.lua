name = "Klee modify"
description = [[
Press "R" to use Charge Attack.
Press "Z" to use ELemental Skill.
Press "X" to use Elemental Burst.
]]
author = "Cá Khô/walala"
version = "0.0.1"
forumthread = ""

api_version = 10

priority = -1

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

all_clients_require_mod = true 

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {"character"}

local keys = {"B","C","G","H","J","K","L","N","O","R","T","V","X","Z","LAlt","RAlt","LCtrl","RCtrl","LShift","RShift"}
local list = {}
local string = ""
for i = 1, #keys do
	list[i] = {description = "Key "..string.upper(keys[i]), data = "KEY_"..string.upper(keys[i])}
end

configuration_options = {
	{
		name = "lang",
		label = "Language",
		hover = "",
		options = {
			{description = "(Auto)", data = 0, hover = ""},
			{description = "English", data = 1, hover = ""},
			{description = "中文", data = 2, hover = ""}
		},
		default = 0
	},
	{
		name = "Stats",
		hover = "",
		options={{description = "", data = 0}},
		default = 0
	},
	{
		name = "hp",
		label = "Health",
		hover = "",
		options = {
			{description = "150", data = 150},
			{description = "200", data = 200},
			{description = "250", data = 250},
		},
		default = 150
	},
	{
		name = "er",
		label = "Energy Recharge",
		hover = "",
		options = {
			{description = "100%", data = 1},
			{description = "150%", data = 1.5},
			{description = "200%", data = 2},
		},
		default = 1
	},
	{
		name = "Key",
		hover = "",
		options={{description = "", data = 0}},
		default = 0
	},
	{
		name = "charge",
		label = "Charge Attack",
		hover = "",
		options = list,
		default = "KEY_R",	
	},
	{
		name = "skill",
		label = "Elemental Skill",
		hover = "",
		options = list,
		default = "KEY_Z",	
	},
	{
		name = "burst",
		label = "Elemental Burst",
		hover = "",
		options = list,
		default = "KEY_X",	
	},
	{
		name = "Recipe",
		hover = "",
		options={{description = "", data = 0}},
		default = 0
	},
	{
		name = "stella",
		label = "Stella Fortuna's Recipe",
		hover = "",
		options = {
			{description = "Easy", data = false},
			{description = "(Default)", data = true},
		},
		default = true
	},
	{
		name = "Others",
		hover = "",
		options={{description = "", data = 0}},
		default = 0
	},
	{
		name = "burn",
		label = "Burning",
		hover = "",
		options = {
			{description = "Yes", data = true},
			{description = "No", data = false},
		},
		default = true
	},
	{
		name = "light",
		label = "Explode Light",
		hover = "",
		options = {
			{description = "Yes", data = true},
			{description = "No", data = false},
		},
		default = true
	},
	{
		name = "work",
		label = "Break Construction",
		hover = "",
		options = {
			{description = "Yes", data = true},
			{description = "No", data = false},
		},
		default = true
	},
}