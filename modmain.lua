PrefabFiles = {
	"klee", "klee_none", "jumpy_dumpty", "minebomb"
}

Assets = {
	Asset( "IMAGE", "bigportraits/klee.tex" ),
	Asset( "ATLAS", "bigportraits/klee.xml" ),

	Asset( "IMAGE", "images/avatars/avatar_klee.tex" ),
	Asset( "ATLAS", "images/avatars/avatar_klee.xml" ),

	Asset( "IMAGE", "images/avatars/avatar_ghost_klee.tex" ),
	Asset( "ATLAS", "images/avatars/avatar_ghost_klee.xml" ),

	Asset( "IMAGE", "images/avatars/self_inspect_klee.tex" ),
	Asset( "ATLAS", "images/avatars/self_inspect_klee.xml" ),

	Asset( "IMAGE", "images/map_icons/klee.tex" ),
	Asset( "ATLAS", "images/map_icons/klee.xml" ),

	Asset( "IMAGE", "images/saveslot_portraits/klee.tex" ),
	Asset( "ATLAS", "images/saveslot_portraits/klee.xml" ),

	Asset( "IMAGE", "images/selectscreen_portraits/klee.tex" ),
	Asset( "ATLAS", "images/selectscreen_portraits/klee.xml" ),

	Asset( "IMAGE", "images/selectscreen_portraits/klee_silho.tex" ),
	Asset( "ATLAS", "images/selectscreen_portraits/klee_silho.xml" ),

	Asset( "IMAGE", "images/names_klee.tex" ),
	Asset( "ATLAS", "images/names_klee.xml" ),

	Asset( "IMAGE", "images/names_gold_klee.tex" ),
	Asset( "ATLAS", "images/names_gold_klee.xml" ),

	--有关技能图标
	Asset( "IMAGE", "images/skills/klee_skill_02.tex" ),
	Asset( "ATLAS", "images/skills/klee_skill_02.xml" ),

	Asset( "IMAGE", "images/skills/klee_skill_12.tex" ),
	Asset( "ATLAS", "images/skills/klee_skill_12.xml" ),

	Asset( "IMAGE", "images/skills/klee_skill_22.tex" ),
	Asset( "ATLAS", "images/skills/klee_skill_22.xml" ),
	
	--天赋
	Asset( "IMAGE", "images/ui/talents_klee/talent_icon_1.tex" ),
	Asset( "ATLAS", "images/ui/talents_klee/talent_icon_1.xml" ),
	Asset( "IMAGE", "images/ui/talents_klee/talent_icon_2.tex" ),
	Asset( "ATLAS", "images/ui/talents_klee/talent_icon_2.xml" ),
	Asset( "IMAGE", "images/ui/talents_klee/talent_icon_3.tex" ),
	Asset( "ATLAS", "images/ui/talents_klee/talent_icon_3.xml" ),
	Asset( "IMAGE", "images/ui/talents_klee/talent_icon_4.tex" ),
	Asset( "ATLAS", "images/ui/talents_klee/talent_icon_4.xml" ),
	Asset( "IMAGE", "images/ui/talents_klee/talent_icon_5.tex" ),
	Asset( "ATLAS", "images/ui/talents_klee/talent_icon_5.xml" ),
	Asset( "IMAGE", "images/ui/talents_klee/talent_icon_6.tex" ),
	Asset( "ATLAS", "images/ui/talents_klee/talent_icon_6.xml" ),

	-- 元素爆发图标
	Asset( "ANIM", "anim/klee_energy.zip" ),
	Asset( "ANIM", "anim/klee_anim.zip" ),

	Asset( "IMAGE", "images/map_icons/klee_bag.tex" ),
	Asset( "ATLAS", "images/map_icons/klee_bag.xml" ),
}

AddMinimapAtlas("images/map_icons/klee.xml")

GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

-- GLOBAL env
local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

------------------------------------------
--技能参数
TUNING.KLEE_SKILL_NORMALATK = 
{
    --LEVEL             1      2      3      4      5      6      7      8      9      10     11     12     13     14     15
    ATK_DMG =        {0.899, 0.967, 1.030, 1.120, 1.190, 1.260, 1.350, 1.440, 1.530, 1.620, 1.710, 1.710, 1.710, 1.710, 1.710},
    CHARGE_ATK_DMG = {1.570, 1.690, 1.810, 1.970, 2.090, 2.200, 2.360, 2.520, 2.680, 2.830, 3.000, 3.000, 3.000, 3.000, 3.000},
}

TUNING.KLEE_SKILL_ELESKILL = 
{
    CD = 20,
    DURATION = 15,
    --LEVEL             1      2      3      4      5      6      7      8      9      10     11     12     13     14     15
    DMG =            {0.952, 1.020, 1.090, 1.190, 1.260, 1.330, 1.430, 1.520, 1.620, 1.710, 1.810, 1.900, 2.020, 2.020, 2.020},
    CO_DMG =         {0.328, 0.353, 0.377, 0.410, 0.435, 0.459, 0.492, 0.525, 0.558, 0.590, 0.623, 0.656, 0.697, 0.697, 0.697},
}

TUNING.KLEE_SKILL_ELEBURST = 
{
    CD = 15,
    ENERGY = 60, 
    DURATION = 10,
    --LEVEL             1      2      3      4      5      6      7      8      9      10     11     12     13     14     15
    DMG =            {0.426, 0.458, 0.490, 0.533, 0.565, 0.597, 0.640, 0.682, 0.725, 0.768, 0.810, 0.852, 0.906, 0.959, 0.959},
}

TUNING.KLEE_SKILL_NORMALATK_SORT = 
{
    "ATK_DMG",
    "CHARGE_ATK_DMG",
}

TUNING.KLEE_SKILL_ELESKILL_SORT = 
{
    "DMG",
    "CO_DMG",
    "DURATION",
    "CD",
}

TUNING.KLEE_SKILL_ELEBURST_SORT = 
{
    "DMG",
    "DURATION",
    "CD",
    "ENERGY", 
}

--------------------- 设置定义 -----------------------

TUNING.ELEMENTALBURST_KEY = GetModConfigData("key_elementalburst")

TUNING.ELEMENTALSKILL_KEY = GetModConfigData("key_elementalskill")

TUNING.KLEE_CONST_BREAK = GetModConfigData("const_work")

TUNING.KLEE_BURN = GetModConfigData("const_burn")

----------------------------------------------------
---------------------- 描述 ------------------------

modimport("scripts/import/klee_description.lua")
----------------------- UI -------------------------

modimport("scripts/import/kleeUI_postconstruct.lua")
----------------------- SG -------------------------

modimport("scripts/import/klee_sg.lua")


local language = GetModConfigData("lang")
if language == 0 then
	if STRINGS.UI.OPTIONS.LANGUAGES == "语言" then
		language = 2
	else
		language = 1
	end
end

if language == 1 then
	STRINGS.CHARACTER_TITLES.klee = "Fleeing Sunlight"
	STRINGS.CHARACTER_NAMES.klee = "Klee"
	STRINGS.CHARACTER_DESCRIPTIONS.klee = ""
	STRINGS.CHARACTER_QUOTES.klee = "Do you wanna come fish blasting with me?"
	STRINGS.CHARACTER_SURVIVABILITY.klee = "Kaboom!"

	STRINGS.NAMES.KLEE = "Klee"
	STRINGS.SKIN_NAMES.klee_none = "Klee"

	STRINGS.NAMES.KLEE_STELLA = "Klee's Stella Fortuna"
	STRINGS.NAMES.DOCOCOTALES = "Dodoco Tales"
	STRINGS.NAMES.DOCOCO_REFINEMENT = "Fragments of Innocence"

	STRINGS.RECIPE_DESC.KLEE_STELLA = "Klee's Constellation Activation Materials"
	STRINGS.RECIPE_DESC.DOCOCOTALES = "A children's book filled with childish short stories."
	STRINGS.RECIPE_DESC.DOCOCO_REFINEMENT = "Dodoco Tales's refinement material"

	STRINGS.NAMES.MINEBOMB = "Mine"
	STRINGS.NAMES.KLEE_BAG = "Klee's bag"
elseif language == 2 then
	STRINGS.CHARACTER_TITLES.klee = "逃跑的太阳"
	STRINGS.CHARACTER_NAMES.klee = "可莉"
	STRINGS.CHARACTER_DESCRIPTIONS.klee = ""
	STRINGS.CHARACTER_QUOTES.klee = "要和可莉一起去炸鱼吗？"
	STRINGS.CHARACTER_SURVIVABILITY.klee = "Kaboom!"

	STRINGS.NAMES.KLEE = "可莉"
	STRINGS.SKIN_NAMES.klee_none = "可莉"

	STRINGS.NAMES.KLEE_STELLA = "可莉的命星"
	STRINGS.NAMES.DOCOCOTALES = "嘟嘟可故事集"
	STRINGS.NAMES.DOCOCO_REFINEMENT = "童真的断篇"

	STRINGS.RECIPE_DESC.KLEE_STELLA = "可莉的命座激活素材"
	STRINGS.RECIPE_DESC.DOCOCOTALES = "一本封面华丽的童书。"
	STRINGS.RECIPE_DESC.DOCOCO_REFINEMENT = "「嘟嘟可故事集」的精炼道具"

	STRINGS.NAMES.MINEBOMB = "诡雷"
	STRINGS.NAMES.KLEE_BAG = "可莉的背包"
end
	STRINGS.CHARACTERS.KLEE = require "speech_wilson"

-- 人物属性
TUNING.KLEE_HEALTH = 150
TUNING.KLEE_HUNGER = 150
TUNING.KLEE_SANITY = 150

TUNING.KLEE_BASEATK = 15


AddModCharacter("klee", "FEMALE")