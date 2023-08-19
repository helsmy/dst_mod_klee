local assets = {
	Asset("ANIM", "anim/apprentices_notes.zip"),
	Asset("IMAGE", "images/inventoryimages/apprentices_notes.tex"),
	Asset("ATLAS", "images/inventoryimages/apprentices_notes.xml")
}

local prefabs = {}

local function OnEquip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_object", "swap_object")
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
end

local function OnUnequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
end

local function DamageFn(weapon, attacker, target)
	local damage = 10
    if attacker == nil or attacker.components.combat == nil then
        return damage
    end
    return attacker.components.combat.defaultdamage + damage
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("apprentices_notes")
	inst.AnimState:SetBuild("apprentices_notes")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("sharp")
    inst:AddTag("pointy")

	inst:AddTag("weapon")

	inst:AddTag("apprentices_notes")
	inst:AddTag("genshin_projectile")
	inst:AddTag("genshin_weapon")
	inst:AddTag("genshin_catalyst")

	MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "apprentices_notes"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/apprentices_notes.xml"
	inst.components.inventoryitem:ChangeImageName("apprentices_notes")

	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(DamageFn)
	inst.components.weapon:SetRange(5)

	inst:AddComponent("rechargeable")
--	inst:AddComponent("refineable")

	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable.restrictedtag = "catalyst_class"

	return inst
end

return Prefab("apprentices_notes", fn, assets, prefabs)