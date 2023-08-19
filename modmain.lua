PrefabFiles = {
	-- 人物
	"klee", "klee_none", 
	-- 武器
	"klee_proj", "dococotales", "fragments_of_innocence", 
	"klee_bag", "apprentices_notes",
	-- 元素战技
	"jumpy_dumpty", "minebomb",
	-- 元素爆发
	"sparks_n_splash", "klee_sparks",
	-- 重击
	"klee_charge_fx",
	-- 命座
	"klee_constellation_star"
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
	Asset( "IMAGE", "images/ui/skills/klee_skill_02.tex" ),
	Asset( "ATLAS", "images/ui/skills/klee_skill_02.xml" ),

	Asset( "IMAGE", "images/ui/skills/klee_skill_12.tex" ),
	Asset( "ATLAS", "images/ui/skills/klee_skill_12.xml" ),

	Asset( "IMAGE", "images/ui/skills/klee_skill_22.tex" ),
	Asset( "ATLAS", "images/ui/skills/klee_skill_22.xml" ),
	
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

	-- 背包地图图标
	Asset( "IMAGE", "images/map_icons/klee_bag_map.tex" ),
	Asset( "ATLAS", "images/map_icons/klee_bag_map.xml" ),

	-- 童真的断章 图标
	Asset("IMAGE", "images/inventoryimages/dococo_refinement.tex"),
	Asset("ATLAS", "images/inventoryimages/dococo_refinement.xml"),
}

AddMinimapAtlas("images/map_icons/klee.xml")
AddMinimapAtlas("images/map_icons/klee_bag_map.xml")

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

-- 战技可用次数
TUNING.KLEE_SKILL_ELESKILL_COUNT = 2

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

TUNING.KLEE_AREA_ATK_NOTAGS = {"FX", "NOCLICK", "DECOR", "INLIMBO", "player", "playerghost", "companion", "abigail", "wall"}

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

-- 沐风蘑菇没做先用红蘑菇替代
TUNING.KLEE_TALENTS_INGREDIENTS = 
{
    {Ingredient("red_cap", 2),  Ingredient("redgem", 1), Ingredient("goldnugget", 1)},  --1~2
    {Ingredient("red_cap", 4),  Ingredient("redgem", 1), Ingredient("goldnugget", 2)},  --2~3
    {Ingredient("red_cap", 6),  Ingredient("redgem", 2), Ingredient("goldnugget", 3)},  --3~4
    {Ingredient("red_cap", 8),  Ingredient("redgem", 2), Ingredient("goldnugget", 4)},  --4~5
    {Ingredient("red_cap", 10), Ingredient("redgem", 3), Ingredient("goldnugget", 5)},  --5~6
    {Ingredient("red_cap", 12), Ingredient("redgem", 3), Ingredient("goldnugget", 6)},  --6~7
    {Ingredient("red_cap", 15), Ingredient("redgem", 4), Ingredient("goldnugget", 7)},  --7~8
    {Ingredient("red_cap", 20), Ingredient("redgem", 4), Ingredient("goldnugget", 8)},  --8~9
    {Ingredient("red_cap", 30), Ingredient("redgem", 5), Ingredient("goldnugget", 9)},   --Ingredient("crown_of_insight", 1, "images/inventoryimages/crown_of_insight.xml")},  --9~10
}

-- TUNING.POLEARM_WEAPONS

--------------------- 设置定义 -----------------------

TUNING.ELEMENTALBURST_KEY = GetModConfigData("key_elementalburst")

TUNING.ELEMENTALSKILL_KEY = GetModConfigData("key_elementalskill")

TUNING.KLEE_CONST_BREAK = GetModConfigData("const_work")

TUNING.KLEE_BURN = GetModConfigData("const_burn")

TUNING.KLEE_EXPLODE_LIGHT = GetModConfigData("explode_light")

----------------------------------------------------
---------------------- 描述 ------------------------

modimport("scripts/import/klee_description.lua")
----------------------- UI -------------------------

modimport("scripts/import/kleeUI_postconstruct.lua")
----------------------- SG -------------------------

modimport("scripts/import/klee_sg.lua")
---------------------- 配方 ------------------------

modimport("scripts/import/klee_recipes.lua")


-- 人物属性
TUNING.KLEE_HEALTH = GetModConfigData("hp") or 150
TUNING.KLEE_HUNGER = 150
TUNING.KLEE_SANITY = 150

TUNING.KLEE_BASEATK = 10
TUNING.KLEE_ATK_CD = 1

-- 初始物品
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.KLEE = {"klee_bag"}
TUNING.STARTING_ITEM_IMAGE_OVERRIDE.klee_bag = {
	atlas = "images/inventoryimages/klee_bag.xml",
	image = "klee_bag.tex"
}

-- 武器
TUNING.WEAPONEFFECT_DOCOCOTALES_DESC = {
	"嘟嘟！大冒险\n·普通攻击命中敌人后的6秒内，重击造成的伤害提升16%；重击命中敌人后的6秒内，攻击力提升8%。",
	"嘟嘟！大冒险\n·普通攻击命中敌人后的6秒内，重击造成的伤害提升20%；重击命中敌人后的6秒内，攻击力提升10%。",
	"嘟嘟！大冒险\n·普通攻击命中敌人后的6秒内，重击造成的伤害提升24%；重击命中敌人后的6秒内，攻击力提升12%。",
	"嘟嘟！大冒险\n·普通攻击命中敌人后的6秒内，重击造成的伤害提升28%；重击命中敌人后的6秒内，攻击力提升14%。",
	"嘟嘟！大冒险\n·普通攻击命中敌人后的6秒内，重击造成的伤害提升32%；重击命中敌人后的6秒内，攻击力提升16%。",
}
TUNING.DOCOCOTALES_DAMAGE = 25
-- 主要效果持续时间
TUNING.DOCOCOTALES_EFFECT_DURATION = 6
-- 附属效果攻击上升
TUNING.DOCOCOTALES_SECONDARY_EFFECT_RATE = 0.551
-- 主要效果倍率
TUNING.DOCOCOTALES_EFFECT_RATE = {
	normal = {0.16, 0.20, 0.24, 0.28, 0.32},
	charge = {0.08, 0.10, 0.12, 0.14, 0.16}
}

AddModCharacter("klee", "FEMALE")