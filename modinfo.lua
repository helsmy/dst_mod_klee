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
-- 在元素反应mod之后加载
priority = -10

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

local opt_Empty = {{description = "", data = 0}}

local function Title(title, hover)
    return {
        name = title,
        hover = hover,
        options = opt_Empty,
        default = 0,
    }
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
	Title("控制"),
	{
		name = "key_elementalskill",
		label = "元素战技键位",
		hover = "自定义释放元素战技的按键",
		options =
		{
			{ description = "TAB", data = 9 },
			{ description = "KP_PERIOD", data = 266 },
			{ description = "KP_DIVIDE", data = 267 },
			{ description = "KP_MULTIPLY", data = 268 },
			{ description = "KP_MINUS", data = 269 },
			{ description = "KP_PLUS", data = 270 },
			{ description = "KP_ENTER", data = 271 },
			{ description = "KP_EQUALS", data = 272 },
			{ description = "MINUS", data = 45 },
			{ description = "EQUALS", data = 61 },
			{ description = "SPACE", data = 32 },
			{ description = "ENTER", data = 13 },
			{ description = "ESCAPE", data = 27 },
			{ description = "HOME", data = 278 },
			{ description = "INSERT", data = 277 },
			{ description = "DELETE", data = 127 },
			{ description = "END", data = 279 },
			{ description = "PAUSE", data = 19 },
			{ description = "PRINT", data = 316 },
			{ description = "CAPSLOCK", data = 301 },
			{ description = "SCROLLOCK", data = 302 },
			{ description = "BACKSPACE", data = 8 },
			{ description = "PERIOD", data = 46 },
			{ description = "SLASH", data = 47 },
			{ description = "LEFTBRACKET", data = 91 },
			{ description = "BACKSLASH", data = 92 },
			{ description = "RIGHTBRACKET", data = 93 },
			{ description = "TILDE", data = 96 },
			{ description = "A", data = 97 },
			{ description = "B", data = 98 },
			{ description = "C", data = 99 },
			{ description = "D", data = 100 },
			{ description = "E", data = 101 },
			{ description = "F", data = 102 },
			{ description = "G", data = 103 },
			{ description = "H", data = 104 },
			{ description = "I", data = 105 },
			{ description = "J", data = 106 },
			{ description = "K", data = 107 },
			{ description = "L", data = 108 },
			{ description = "M", data = 109 },
			{ description = "N", data = 110 },
			{ description = "O", data = 111 },
			{ description = "P", data = 112 },
			{ description = "Q", data = 113 },
			{ description = "R", data = 114 },
			{ description = "S", data = 115 },
			{ description = "T", data = 116 },
			{ description = "U", data = 117 },
			{ description = "V", data = 118 },
			{ description = "W", data = 119 },
			{ description = "X", data = 120 },
			{ description = "Y", data = 121 },
			{ description = "Z", data = 122 },
			{ description = "F1", data = 282 },
			{ description = "F2", data = 283 },
			{ description = "F3", data = 284 },
			{ description = "F4", data = 285 },
			{ description = "F5", data = 286 },
			{ description = "F6", data = 287 },
			{ description = "F7", data = 288 },
			{ description = "F8", data = 289 },
			{ description = "F9", data = 290 },
			{ description = "F10", data = 291 },
			{ description = "F11", data = 292 },
			{ description = "F12", data = 293 },
			{ description = "UP", data = 273 },
			{ description = "DOWN", data = 274 },
			{ description = "RIGHT", data = 275 },
			{ description = "LEFT", data = 276 },
			{ description = "PAGEUP", data = 280 },
			{ description = "PAGEDOWN", data = 281 },
			{ description = "0", data = 48 },
			{ description = "1", data = 49 },
			{ description = "2", data = 50 },
			{ description = "3", data = 51 },
			{ description = "4", data = 52 },
			{ description = "5", data = 53 },
			{ description = "6", data = 54 },
			{ description = "7", data = 55 },
			{ description = "8", data = 56 },
			{ description = "9", data = 57 },
		},
		default = 101,
	},
	{
		name = "key_elementalburst",
		label = "元素爆发键位",
		hover = "自定义释放元素爆发的按键",
		options =
		{
			{ description = "TAB", data = 9 },
			{ description = "KP_PERIOD", data = 266 },
			{ description = "KP_DIVIDE", data = 267 },
			{ description = "KP_MULTIPLY", data = 268 },
			{ description = "KP_MINUS", data = 269 },
			{ description = "KP_PLUS", data = 270 },
			{ description = "KP_ENTER", data = 271 },
			{ description = "KP_EQUALS", data = 272 },
			{ description = "MINUS", data = 45 },
			{ description = "EQUALS", data = 61 },
			{ description = "SPACE", data = 32 },
			{ description = "ENTER", data = 13 },
			{ description = "ESCAPE", data = 27 },
			{ description = "HOME", data = 278 },
			{ description = "INSERT", data = 277 },
			{ description = "DELETE", data = 127 },
			{ description = "END", data = 279 },
			{ description = "PAUSE", data = 19 },
			{ description = "PRINT", data = 316 },
			{ description = "CAPSLOCK", data = 301 },
			{ description = "SCROLLOCK", data = 302 },
			{ description = "BACKSPACE", data = 8 },
			{ description = "PERIOD", data = 46 },
			{ description = "SLASH", data = 47 },
			{ description = "LEFTBRACKET", data = 91 },
			{ description = "BACKSLASH", data = 92 },
			{ description = "RIGHTBRACKET", data = 93 },
			{ description = "TILDE", data = 96 },
			{ description = "A", data = 97 },
			{ description = "B", data = 98 },
			{ description = "C", data = 99 },
			{ description = "D", data = 100 },
			{ description = "E", data = 101 },
			{ description = "F", data = 102 },
			{ description = "G", data = 103 },
			{ description = "H", data = 104 },
			{ description = "I", data = 105 },
			{ description = "J", data = 106 },
			{ description = "K", data = 107 },
			{ description = "L", data = 108 },
			{ description = "M", data = 109 },
			{ description = "N", data = 110 },
			{ description = "O", data = 111 },
			{ description = "P", data = 112 },
			{ description = "Q", data = 113 },
			{ description = "R", data = 114 },
			{ description = "S", data = 115 },
			{ description = "T", data = 116 },
			{ description = "U", data = 117 },
			{ description = "V", data = 118 },
			{ description = "W", data = 119 },
			{ description = "X", data = 120 },
			{ description = "Y", data = 121 },
			{ description = "Z", data = 122 },
			{ description = "F1", data = 282 },
			{ description = "F2", data = 283 },
			{ description = "F3", data = 284 },
			{ description = "F4", data = 285 },
			{ description = "F5", data = 286 },
			{ description = "F6", data = 287 },
			{ description = "F7", data = 288 },
			{ description = "F8", data = 289 },
			{ description = "F9", data = 290 },
			{ description = "F10", data = 291 },
			{ description = "F11", data = 292 },
			{ description = "F12", data = 293 },
			{ description = "UP", data = 273 },
			{ description = "DOWN", data = 274 },
			{ description = "RIGHT", data = 275 },
			{ description = "LEFT", data = 276 },
			{ description = "PAGEUP", data = 280 },
			{ description = "PAGEDOWN", data = 281 },
			{ description = "0", data = 48 },
			{ description = "1", data = 49 },
			{ description = "2", data = 50 },
			{ description = "3", data = 51 },
			{ description = "4", data = 52 },
			{ description = "5", data = 53 },
			{ description = "6", data = 54 },
			{ description = "7", data = 55 },
			{ description = "8", data = 56 },
			{ description = "9", data = 57 },
		},
		default = 113,
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
		name = "const_burn",
		label = "Burning",
		hover = "",
		options = {
			{description = "Yes", data = true},
			{description = "No", data = false},
		},
		default = true
	},
	{
		name = "explode_light",
		label = "Explode Light",
		hover = "",
		options = {
			{description = "Yes", data = true},
			{description = "No", data = false},
		},
		default = true
	},
	{
		name = "const_work",
		label = "Break Construction",
		hover = "",
		options = {
			{description = "Yes", data = true},
			{description = "No", data = false},
		},
		default = true
	},
}