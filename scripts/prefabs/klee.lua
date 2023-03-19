--初始加载
local MakePlayerCharacter = require "prefabs/player_common"
local ElementalSkillFactoryKlee = require "widgets/elementalcaster_factory_klee"

local assets = {
	Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
	Asset("ANIM", "anim/ghost_klee_build.zip"),
	Asset("ANIM", "anim/klee.zip"),
	Asset("ANIM", "anim/klee_hat.zip")
}

local prefabs = {
	"dococotales"
}

local starting_inventory = {
	"dococotales"
}

local skillkeys = {
    TUNING.ELEMENTALSKILL_KEY,
	TUNING.ELEMENTALBURST_KEY,
}

local function KleeHat(inst)
	if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) == nil then
		inst.AnimState:OverrideSymbol("swap_hat", "klee_hat", "swap_hat")
		inst.AnimState:Show("HAT")
	end
end

local function OnBecameHuman(inst)
	inst.components.locomotor.walkspeed = 4
	inst.components.locomotor.runspeed = 6
end

local function OnLoad(inst)
    inst:ListenForEvent("ms_respawnedfromghost", OnBecameHuman)
    OnBecameHuman(inst)
end

local function ChargeSGFn(inst)
	if TheWorld.ismastersim then
		local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
		if weapon == nil then
			return "attack"
		end
	else
		local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
		if equip == nil then
			return "attack"
		end
	end
	return "chargeattack"
end

local function AttackkeyFn(inst, weapon, target)
    if inst.burststate then
		return "elementalburst"
	else
        return inst.sg:HasStateTag("chargeattack") and "charge" or "normal"
	end
end

--普通攻击倍率
local function NormalATKRateFn(inst, target)
	return TUNING.KLEE_SKILL_NORMALATK.ATK_DMG[inst.components.talents:GetTalentLevel(1)]
end

--重击倍率
local function ChargeATKRateFn(inst, target)
	return TUNING.KLEE_SKILL_NORMALATK.CHARGE_ATK_DMG[inst.components.talents:GetTalentLevel(1)]
end

local function CustomAttackFn(inst, target, instancemult, ischarge)
	-- assets(false, "CustomAttackFn breakpoint")
	print("attack status:", ischarge)
	print("attack status chargesgname:", inst.chargesgname)
	print("attack status chargesgname:", inst.chargesgname(inst))
	print("attack status cancharge:", inst.cancharge)
	local weapon = inst.components.combat:GetWeapon()
	if weapon ==nil or not weapon:HasTag("genshin_catalyst") then
		inst.components.combat:DoAttack(target, nil, nil, nil, instancemult)
		return
	end
	if ischarge then
		-- TODO: 完成重击
		print("Do Charge attack")
		inst.sg:GoToState("klee_chargeattack")
	else
		-- 临时将符合条件的武器的投射物设成可莉的投射物
		-- 这样可莉的普攻就永远是一样的了
		local old_proj = weapon.components.weapon.projectile
		weapon.components.weapon:SetProjectile("klee_proj")
		inst.components.combat:DoAttack(target, nil, nil, nil, instancemult)
		weapon.components.weapon:SetProjectile(old_proj)
	end
end


--元素战技
local function elementalskillfn(inst)
	if (inst.components.rider and inst.components.rider:IsRiding()) or inst.sg:HasStateTag("dead") then
	    return
	end
	
	if not inst.components.elementalcaster:outofcooldown("elementalskill") then
	    return
	end

	inst.components.elementalcaster:ConsumeElementalSkill()
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

	inst:PushEvent("cast_elementalburst", {energycost = TUNING.KLEE_SKILL_ELEBURST.ENERGY, element = 1})
	TheWorld:PushEvent("cast_elementalburst", {energycost = TUNING.KLEE_SKILL_ELEBURST.ENERGY, element = 1})

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

	inst.character_description = STRINGS.CHARACTER_DESCRIPTIONS.klee

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

	inst.chargesgname = ChargeSGFn             
end

local master_postinit = function(inst)
	inst.soundsname = "willow"

	--添加元素充能
	inst:AddComponent("energyrecharge")
	inst.components.energyrecharge:SetMax(TUNING.KLEE_SKILL_ELEBURST.ENERGY)

	--设置元素战技和元素爆发施放
	inst:AddComponent("elementalcaster")
	ElementalSkillFactoryKlee(inst)
	inst.components.elementalcaster:SetElementalSkill(TUNING.KLEE_SKILL_ELESKILL.CD, TUNING.KLEE_SKILL_ELESKILL_COUNT)
	inst.components.elementalcaster:SetElementalBurst(TUNING.KLEE_SKILL_ELEBURST.CD, TUNING.KLEE_SKILL_ELEBURST.ENERGY)
	
	--天赋
	inst:AddComponent("talents")

	-- 三维设置
	inst.components.health:SetMaxHealth(TUNING.KLEE_HEALTH)
	inst.components.hunger:SetMax(TUNING.KLEE_HUNGER)
	inst.components.sanity:SetMax(TUNING.KLEE_SANITY)

	-- 初始物品
	inst.starting_inventory = starting_inventory

	inst.components.hunger.hungerrate = TUNING.WILSON_HUNGER_RATE

	inst.components.combat:SetDefaultDamage(TUNING.KLEE_BASEATK)
	inst.components.combat.damagemultiplier = 1
	inst.components.combat.damagebonus = 0

	inst.components.combat.overrideattackkeyfn = AttackkeyFn

	inst:DoPeriodicTask(FRAMES, KleeHat)

	inst.OnLoad = OnLoad

	inst.normalattackdmgratefn = NormalATKRateFn
	inst.chargeattackdmgratefn = ChargeATKRateFn
	inst.customattackfn = CustomAttackFn
end

return MakePlayerCharacter("klee", prefabs, assets, common_postinit, master_postinit)

