--初始加载
local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
	Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

local function OnBecameHuman(inst)
	inst.components.locomotor.walkspeed = 4
	inst.components.locomotor.runspeed = 6
end

local function OnLoad(inst)
    inst:ListenForEvent("ms_respawnedfromghost", OnBecameHuman)
    OnBecameHuman(inst)
end

local common_postinit = function(inst) 
	inst.MiniMapEntity:SetIcon( "raiden_shogun.tex" )

	inst.Transform:SetScale(0.85, 0.85, 0.85)

	-- tags
	inst:AddTag("klee")
	inst:AddTag("pyro")
	inst:AddTag("catalyst_class")
	inst:AddTag("genshin_character")

	-- 天赋信息
	inst.talents_path = "images/ui/talents_klee"
	inst.talents_number = 6
	inst.talents_description = TUNING.KLEE_TALENTS_DESC
	inst.talents_attributes = {
		value = {
			TUNING.KLEE_SKILL_NORMALATK,
			TUNING.KLEE_SKILL_ELESKILL,
			TUNING.KLEE_SKILL_ELEBURST,
		},
		text = {
			TUNING.KLEE_SKILL_NORMALATK_TEXT,
			TUNING.KLEE_SKILL_ELESKILL_TEXT,
			TUNING.KLEE_SKILL_ELEBURST_TEXT,
		},
		keysort = {
			TUNING.KLEE_SKILL_NORMALATK_SORT,
			TUNING.KLEE_SKILL_ELESKILL_SORT,
			TUNING.KLEE_SKILL_ELEBURST_SORT,
		},
	}

end

local master_postinit = function(inst)
	inst.soundsname = "willow"

	--天赋
	inst:AddComponent("talents")

	-- 三维设置
	inst.components.health:SetMaxHealth(TUNING.KLEE_HEALTH)
	inst.components.hunger:SetMax(TUNING.KLEE_HUNGER)
	inst.components.sanity:SetMax(TUNING.KLEE_SANITY)

	inst.components.hunger.hungerrate = TUNING.WILSON_HUNGER_RATE

	inst.components.combat:SetDefaultDamage(TUNING.KLEE_BASEATK)
	inst.components.combat.damagemultiplier = 1
	inst.components.combat.damagebonus = 0

	inst.OnLoad = OnLoad
end

return MakePlayerCharacter("klee", prefabs, assets, common_postinit, master_postinit)

