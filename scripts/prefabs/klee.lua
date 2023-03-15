--初始加载
local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
	Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

local skillkeys = {
    TUNING.ELEMENTALSKILL_KEY,
	TUNING.ELEMENTALBURST_KEY,
}

local function OnBecameHuman(inst)
	inst.components.locomotor.walkspeed = 4
	inst.components.locomotor.runspeed = 6
end

local function OnLoad(inst)
    inst:ListenForEvent("ms_respawnedfromghost", OnBecameHuman)
    OnBecameHuman(inst)
end

--元素战技
local function elementalskillfn(inst)
	if (inst.components.rider and inst.components.rider:IsRiding()) or inst.sg:HasStateTag("dead") then
	    return
	end
	
	if not inst.components.elementalcaster:outofcooldown("elementalskill") then
	    return
	end

	inst:PushEvent("cast_elementalskill")
	inst.sg:GoToState("klee_elementalskill")
end

--元素爆发(测试)
local function elementalburstfn(inst)
    if (inst.components.rider and inst.components.rider:IsRiding()) or inst.sg:HasStateTag("dead") then
	    return
	end
	
	if not inst.components.elementalcaster:outofcooldown("elementalburst") then
	    return
	end

	-- if inst.burststate then
	-- 	elementalburst_exitfn(inst)
	-- 	if inst.exittask ~= nil then
	-- 		inst.exittask:Cancel()
	-- 		inst.exittask = nil
	-- 	end
	-- end

	-- inst._burststate:set(true)
	-- inst.resolve_stack = TakeChakraStack(inst)
	-- inst.exittask = inst:DoTaskInTime(TUNING.RAIDENSKILL_ELEBURST.DURATION + 2, elementalburst_exitfn)

	-- inst:AddTag("stronggrip")

	inst:PushEvent("cast_elementalburst", {energycost = TUNING.KLEE_SKILL_ELEBURST.ENERGY, element = 4})
	TheWorld:PushEvent("cast_elementalburst", {energycost = TUNING.KLEE_SKILL_ELEBURST.ENERGY, element = 4})

    --这块以后会被sg替代
	-- inst.sg:GoToState("klee_elementalburst")

end

AddModRPCHandler("klee", "elementalskill", elementalskillfn)
AddModRPCHandler("klee", "elementalburst", elementalburstfn)

local common_postinit = function(inst) 
	inst.MiniMapEntity:SetIcon( "klee.tex" )

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

	inst:AddComponent("keyhandler_klee")
	inst.components.keyhandler_klee:SetSkillKeys(skillkeys)
	--释放
	inst.components.keyhandler_klee:AddActionListener(TUNING.ELEMENTALSKILL_KEY, {Namespace = "klee", Action = "elementalskill"}, "keyup", nil)
	inst.components.keyhandler_klee:AddActionListener(TUNING.ELEMENTALBURST_KEY, {Namespace = "klee", Action = "elementalburst"}, "keyup", nil)

end

local master_postinit = function(inst)
	inst.soundsname = "willow"

	--添加元素充能
	inst:AddComponent("energyrecharge")
	inst.components.energyrecharge:SetMax(TUNING.KLEE_SKILL_ELEBURST.ENERGY)

	--设置元素战技和元素爆发施放
	inst:AddComponent("elementalcaster")
	inst.components.elementalcaster:SetElementalSkill(TUNING.KLEE_SKILL_ELESKILL.CD)
	inst.components.elementalcaster:SetElementalBurst(TUNING.KLEE_SKILL_ELEBURST.CD, TUNING.KLEE_SKILL_ELEBURST.ENERGY)
	
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

