local assets = {
	Asset("ANIM", "anim/dococotales.zip"),
	Asset("IMAGE", "images/inventoryimages/dococotales.tex"),
	Asset("ATLAS", "images/inventoryimages/dococotales.xml"),
}

local prefabs = {}

local projectile = "klee_proj"

local function OnEquip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_object", "swap_object")
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
	local atkup = TUNING.DOCOCOTALES_SECONDARY_EFFECT_RATE
	owner.components.combat.external_atk_multipliers:SetModifier(inst, atkup, "all_dodocotales_base")

	-- inst.components.weapon:SetProjectile(projectile)
end

local function OnUnequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
	owner.components.combat.external_atk_multipliers:RemoveModifier(inst, "all_dodocotales_base")

	-- inst.components.weapon:SetProjectile(nil)
	inst.components.weapon:SetRange(5)
end

local function OnProj(inst, attacker, target, proj)
	local AfterGetHit = function(proj, attacker, target)
		if attacker.charge_rate ~= nil then
			if not attacker.dococo_bonus1_cd then
				local dococo_bonus1 = (16 + (inst.components.refine.rank - 1) * 4) / 100
				attacker.charge_rate = attacker.charge_rate + dococo_bonus1
				attacker.dococo_bonus1_cd = true
				attacker:DoTaskInTime(6, function()
					attacker.dococo_bonus1_cd = nil
					attacker.charge_rate = attacker.charge_rate - dococo_bonus1
				end)
			end
		end
	end
	if attacker:HasTag("catalyst_class") then
		if proj.components.projectile then
			proj.components.projectile:SetAfterGetHitFn(AfterGetHit)
		elseif proj.components.complexprojectile then
			proj.components.complexprojectile:SetAfterGetHitFn(AfterGetHit)
		end
	end
end

local function DamageFn(weapon, attacker, target)
    if attacker == nil or attacker.components.combat == nil then
        return TUNING.DOCOCOTALES_DAMAGE
    end
    return attacker.components.combat.defaultdamage + TUNING.DOCOCOTALES_DAMAGE
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

	MakeInventoryFloatable(inst)

	inst:AddTag("weapon")
	inst:AddTag("thrown")

	inst:AddTag("dococo")
	inst:AddTag("genshin_projectile")
	inst:AddTag("genshin_weapon")
	inst:AddTag("genshin_catalyst")

	inst:AddTag("subtextweapon")
    inst.subtext = "atk"
    inst.subnumber = "55.1%"
    inst.description = TUNING.WEAPONEFFECT_DOCOCOTALES

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
	-- inst.components.weapon:SetOnProjectile(OnProj)
	-- inst.components.weapon:SetProjectile(projectile)

	inst:AddComponent("rechargeable")
	inst:AddComponent("refineable")
	inst.components.refineable.ingredient = "fragments_of_innocence"
	inst.components.refineable.overrideimage = "dococo_refinement"
	inst.components.refineable.overrideatlas = "images/inventoryimages/dococo_refinement.xml"

	-- inst.components.refineable.ingredient = "dococotales"

	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable.restrictedtag = "catalyst_class"

	return inst
end

return Prefab("dococotales", fn, assets, prefabs)