local assets = {
	Asset("ANIM", "anim/dococotales.zip"),
	Asset("IMAGE", "images/inventoryimages/dococotales.tex"),
	Asset("ATLAS", "images/inventoryimages/dococotales.xml"),
}

local prefabs = {}

--统一设置计时器的格式
local function LocalStartTimer(inst, name, time)
    if name == nil or time == nil or time < 0 then
        return
    end
    if inst.components.timer:TimerExists(name) then
        inst.components.timer:SetTimeLeft(name, time)
    else
        inst.components.timer:StartTimer(name, time)
    end
end

local function OwnerOnDamageCalculated(owner, data)
	local inst = owner.components.combat:GetWeapon()
    if inst == nil then
        return
    end
	-- 由武器本身来处理
    inst:PushEvent("damagecalculated", {target = data.target, damage = data.damage, weapon = data.weapon, stimuli = data.stimuli, elementvalue = data.elementvalue, crit = data.crit, attackkey = data.attackkey})
end

local function OnEquip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_object", "swap_object")
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
	local atkup = TUNING.DOCOCOTALES_SECONDARY_EFFECT_RATE
	owner.components.combat.external_atk_multipliers:SetModifier(inst, atkup, "all_dodocotales_base")

	owner:ListenForEvent("damagecalculated", OwnerOnDamageCalculated)
end

local function OnUnequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
	owner.components.combat.external_atk_multipliers:RemoveModifier(inst, "all_dodocotales_base")

	owner:RemoveEventCallback("damagecalculated", OwnerOnDamageCalculated)
end

local function OnDamageCalculated(inst, data)
    local owner = inst.components.inventoryitem.owner
    if owner == nil or owner.components.combat == nil then
        return
    end

	local level = inst.components.refineable:GetCurrentLevel()
	local rate = nil
	local duration = TUNING.DOCOCOTALES_EFFECT_DURATION
    if data.attackkey == "normal" then
        -- print("normalattack\n\n")
		rate = TUNING.DOCOCOTALES_EFFECT_RATE.charge[level]
        owner.components.combat.external_attacktype_multipliers:SetModifier(inst, rate, "charge_dococotaleseffect")
        LocalStartTimer(inst, "dococotales_chargedmg", duration)
    end
    --
    if data.attackkey == "charge" then
        -- print("chargeattack\n\n")
		rate = TUNING.DOCOCOTALES_EFFECT_RATE.normal[level]
        owner.components.combat.external_attacktype_multipliers:SetModifier(inst, rate, "normal_dococotaleseffect")
        LocalStartTimer(inst, "dococotales_basedmg", duration)
    end
end

local function DamageFn(weapon, attacker, target)
    if attacker == nil or attacker.components.combat == nil then
        return TUNING.DOCOCOTALES_DAMAGE
    end
    return attacker.components.combat.defaultdamage + TUNING.DOCOCOTALES_DAMAGE
end

local function OnTimerDone(inst, data)
    local owner = inst.components.inventoryitem.owner
    if owner == nil or owner.components.combat == nil then
        return
    end

    if data.name == "dococotales_chargedmg" then
        owner.components.combat.external_attacktype_multipliers:RemoveModifier(inst, "charge_dococotaleseffect")
    end
    if data.name == "dococotales_basedmg" then
        owner.components.combat.external_attacktype_multipliers:RemoveModifier(inst, "normal_dococotaleseffect")
    end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("dococotales")
	inst.AnimState:SetBuild("dococotales")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("sharp")
    inst:AddTag("pointy")

	inst:AddTag("weapon")
	-- inst:AddTag("chargeattack_weapon")
	-- thrown tag 能让元素反应的重击处理失效，真神奇
	-- inst:AddTag("thrown")

	inst:AddTag("dococo")
	inst:AddTag("genshin_projectile")
	inst:AddTag("genshin_weapon")
	inst:AddTag("genshin_catalyst")

	inst:AddTag("subtextweapon")
    inst.subtext = "atk"
    inst.subnumber = "55.1%"
    inst.description = TUNING.WEAPONEFFECT_DOCOCOTALES_DESC

	MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "dococotales"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/dococotales.xml"
	inst.components.inventoryitem:ChangeImageName("dococotales")

	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(DamageFn)
	inst.components.weapon:SetRange(5)
	-- inst.components.weapon:SetOnProjectile(GetOnProjectile(inst))
	-- inst.components.weapon:SetProjectile(projectile)

	inst:AddComponent("rechargeable")
	inst:AddComponent("refineable")
	inst.components.refineable.ingredient = "fragments_of_innocence"
	inst.components.refineable.overrideimage = "dococo_refinement"
	inst.components.refineable.overrideatlas = "images/inventoryimages/dococo_refinement.xml"

	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable.restrictedtag = "catalyst_class"

	inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)

	inst:ListenForEvent("damagecalculated", OnDamageCalculated)

	return inst
end

return Prefab("dococotales", fn, assets, prefabs)